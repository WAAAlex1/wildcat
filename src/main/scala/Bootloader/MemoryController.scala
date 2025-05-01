package Bootloader

import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
// Import MemoryMap and CLINTLink
import wildcat.CSR.MemoryMap
import wildcat.pipeline.CLINTLink

// TODO : EVALUATE IF CACHE-COHERENCE NEEDED

/**
 * Memory controller module for the Wildcat.
 * Now with CLINT support while maintaining original structure.
 */
class MemoryController(implicit val config: TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    val memIO = Flipped(new TestMemIO())
    val stall = Output(Bool())
    val bootloading = Input(Bool())

    // To/From caches via bus
    val dCacheReqOut = Flipped(Decoupled(new TLRequest))
    val dCacheRspIn = Decoupled(new TLResponse)

    val iCacheReqOut = Flipped(Decoupled(new TLRequest))
    val iCacheRspIn = Decoupled(new TLResponse)

    // To/Form SPI controllers
    val SPIctrl = Vec(2, Flipped(new SpiCTRLIO)) // SPI0 is RAM0, SPI1 is RAM1

    // CLINT interface for timer support
    val clintLink = new CLINTLink()
  })

  // Keep the existing memory module connection
  val memory = Module(new TestMem(4096))
  io.memIO <> memory.io

  //--------------------------------------------------------------------
  // Original signals and structure (some renamed)
  //--------------------------------------------------------------------
  val dCacheTransaction = io.dCacheReqOut.valid && io.dCacheReqOut.ready // Request acknowledged and accepted
  val iCacheTransaction = io.iCacheReqOut.valid && io.iCacheReqOut.ready // Request acknowledged and accepted
  val currentReq = Reg(new TLRequest()) // TileLink request format
  val dataSize = WireInit(4.U(3.W)) // Number of bytes to transfer
  val rspPending = RegInit(false.B)
  val data2write = WireInit(0.U(32.W))
  val readData = WireInit(0.U((config.w * 8).W))
  val masterID = RegInit(false.B) // Master (cache) identifier
  val rspValid = WireInit(false.B)

  // signal for correct handshaking and usage of SPI
  val rspHandled = RegInit(true.B) // Start as handled (no pending response)

  // signal to track target for pending requests (CLINT or SPI)
  val targetIsCLINT = RegInit(false.B)
  val isCLINT = (io.dCacheReqOut.bits.addrRequest >= MemoryMap.CLINT_BASE.U) &&
    (io.dCacheReqOut.bits.addrRequest < (MemoryMap.CLINT_BASE.U + MemoryMap.MTIME_OFFSET.U + 8.U))

  // STALLING THE PROCESSOR
  val stallForMemory = rspPending && !rspValid && !targetIsCLINT
  val stallForCLINT = rspPending && targetIsCLINT && !rspValid
  val stallForBootloading = io.bootloading

  // Only stall when absolutely necessary
  io.stall := stallForMemory || stallForCLINT || stallForBootloading

  // Arbitration on ready for requests, data cache has priority
  // io.dCacheReqOut.ready := io.dCacheReqOut.valid
  // io.iCacheReqOut.ready := (!io.dCacheReqOut.valid && io.iCacheReqOut.valid)
  // Changes needed - receiver readiness should NOT be dependent on sender being valid
  // Standard handshake practice is that ready should be based on rspPending
  // Only ready to accept if not waiting for a response
  val canAcceptRequest = !rspPending && !io.bootloading
  io.dCacheReqOut.ready := canAcceptRequest
  io.iCacheReqOut.ready := canAcceptRequest && !io.dCacheReqOut.valid

  // Default Responses
  io.dCacheRspIn.bits.dataResponse := readData
  io.iCacheRspIn.bits.dataResponse := readData
  io.dCacheRspIn.bits.error := false.B
  io.iCacheRspIn.bits.error := false.B
  io.dCacheRspIn.valid := false.B
  io.iCacheRspIn.valid := false.B

  // Default settings for SPI controllers
  for (i <- 0 until 2) {
    io.SPIctrl(i).en := false.B
    io.SPIctrl(i).rw := currentReq.isWrite
    io.SPIctrl(i).rst := false.B
    io.SPIctrl(i).addr := currentReq.addrRequest(23, 0)
    io.SPIctrl(i).dataIn := data2write
    io.SPIctrl(i).size := dataSize
  }

  // Default settings for CLINT - new
  io.clintLink.enable := false.B
  io.clintLink.isWrite := false.B
  io.clintLink.address := 0.U
  io.clintLink.wrData := 0.U

  // Process requests
  when(dCacheTransaction) {
    currentReq := io.dCacheReqOut.bits
    rspPending := true.B
    masterID := false.B  // dCache
    rspHandled := false.B  // Reset response handling flag

    // Check if address is in CLINT range
    targetIsCLINT := isCLINT

  }.elsewhen(iCacheTransaction) {
    currentReq := io.iCacheReqOut.bits
    rspPending := true.B
    masterID := true.B   // iCache
    rspHandled := false.B  // Reset response handling flag

    // Check if address is in CLINT range
    targetIsCLINT := isCLINT
  }

  // Modify data to write - same as original
  when(currentReq.isWrite) {
    // Compute dataSize based on number of active bits in the lane mask
    dataSize := MuxLookup(currentReq.activeByteLane, 1.U, Seq(
      15.U -> 4.U,
      12.U -> 2.U,
      3.U -> 2.U
    ))

    // Compute data2write based on the lowest set bit
    val shiftAmount = PriorityEncoder(currentReq.activeByteLane)
    // TODO: Check if this limitation is correct/needed
    val byteShift = (shiftAmount & 0x3.U) * 8.U  // Limit to 0-3 bytes (0-24 bits)
    data2write := (currentReq.dataRequest >> byteShift)

  }.otherwise {
    dataSize := 4.U // Standard for read
  }

  // Address decoding on response
  when(rspPending) {
    when(targetIsCLINT) {
      // Access CLINT for timer functionality - new section
      io.clintLink.enable := true.B
      io.clintLink.isWrite := currentReq.isWrite
      io.clintLink.address := currentReq.addrRequest
      io.clintLink.wrData := currentReq.dataRequest

      // CLINT response is available in the same cycle
      readData := io.clintLink.rdData
      rspValid := true.B
      rspPending := false.B
    }.elsewhen(currentReq.addrRequest(31, 28) === 0xF.U) {
      // Handle memory-mapped IO - same as original

      // WILL CURRENTLY STALL FOREVER AS rspPENDING IS NEVER CLEARED
      // FIX:
      readData := 0.U
      rspValid := true.B
      rspPending := false.B

    }.elsewhen(currentReq.addrRequest(24)) {
      // RAM 1 read/write - with response handling
      io.SPIctrl(1).en := true.B

      // Check for completion // responses
      when(io.SPIctrl(1).done && !rspHandled) {
        rspPending := false.B
        when(!currentReq.isWrite) {
          readData := io.SPIctrl(1).dataOut
        }
        rspValid := true.B
        rspHandled := true.B  // Mark response as handled
      }
    }.elsewhen(!currentReq.addrRequest(24)) {
      // RAM 0 read/write - with response handling
      io.SPIctrl(0).en := true.B

      // Check for completion // responses
      when(io.SPIctrl(0).done && !rspHandled) {
        rspPending := false.B
        when(!currentReq.isWrite) {
          readData := io.SPIctrl(0).dataOut
        }
        rspValid := true.B
        rspHandled := true.B  // Mark response as handled
      }
    }.otherwise {
      // Default case - Flash read or unmapped address
    }
  }

  // Process responses
  when(rspValid) {
    when(masterID) { // iCache requested
      io.iCacheRspIn.valid := true.B
    }.otherwise { // dCache requested
      io.dCacheRspIn.valid := true.B
    }
  }

  // Deassert SPI enable signals when done with transaction
  when(rspHandled && !rspPending) {
    // Safe to deassert all device enables when response is handled and no pending request
    io.SPIctrl(0).en := false.B
    io.SPIctrl(1).en := false.B
  }

}