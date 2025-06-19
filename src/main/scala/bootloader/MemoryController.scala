// OLD / ORIGINAL MEMORYCONTROLLER

package bootloader

import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import wildcat.CSR.MemoryMap
import wildcat.pipeline.CLINTLink

/**
 * Memory controller module for the Wildcat. Performs arbitration, address decoding
 * and request/response processing
 *
 * Address space:
 * [0xfxxx_xxxx] is the IO space for the Wildcat
 * [23,0] is the real address space of the memory (including flash)
 * [27,25] are so far unused control signal bits we might need later
 * [0x1000_0000 etc.] is also unused so far.
 */

class MemoryController(implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle {

    // To/From caches via bus
    val dCacheReqOut = Flipped(Decoupled(new TLRequest))
    val dCacheRspIn = Decoupled(new TLResponse)

    val iCacheReqOut = Flipped(Decoupled(new TLRequest))
    val iCacheRspIn = Decoupled(new TLResponse)

    // To/From SPI controllers
    val SPIctrl = Flipped(new SpiCTRLIO)
    val startup = Input(Bool())
    val SpiCtrlValid = Input(Bool())
    val moduleSel = Output(Vec(3, Bool())) // 0 for flash, 1 for psram a, 2 for psram b, (flash not working)
  })

  io.moduleSel := Seq.fill(3)(false.B) // No module selected



  val dReqAck = io.dCacheReqOut.valid && io.dCacheReqOut.ready // Request acknowledged
  val iReqAck = io.iCacheReqOut.valid && io.iCacheReqOut.ready // Request acknowledged
  val currentReq = Reg(new TLRequest()) // TileLink request format
  val dataSize = WireInit(4.U(6.W)) // Number of bytes to transfer
  val rspPending = RegInit(false.B)
  val data2write = WireInit(0.U(32.W))
  val readData = WireInit(0.U(32.W))
  val masterID = RegInit(false.B) // Master (cache) identifier
  val rspValid = WireInit(false.B)

  // signal for correct handshaking and usage of SPI
  val rspHandled = RegInit(true.B) // true = handled (no pending response)

  // Arbitration on ready for requests. Data cache has priority
  io.dCacheReqOut.ready := io.dCacheReqOut.valid  && !io.startup
  io.iCacheReqOut.ready := !io.dCacheReqOut.valid && io.iCacheReqOut.valid  && !io.startup

  // Default Responses
  io.dCacheRspIn.bits.dataResponse := readData
  io.iCacheRspIn.bits.dataResponse := readData
  io.dCacheRspIn.bits.error := false.B // dummy
  io.iCacheRspIn.bits.error := false.B // dummy
  io.dCacheRspIn.valid := false.B
  io.iCacheRspIn.valid := false.B

  // Default settings for SPI controllers
  io.SPIctrl.en := rspPending
  io.SPIctrl.rw := currentReq.isWrite
  io.SPIctrl.addr := 0.B ## currentReq.addrRequest(22, 0)
  io.SPIctrl.dataIn := data2write
  io.SPIctrl.size := dataSize


  // Process requests
  when(dReqAck && !rspPending){
    currentReq := io.dCacheReqOut.bits
    rspPending := true.B
    masterID := false.B  // dCache
    rspHandled := false.B  // response currently being handled
  }.elsewhen(iReqAck && !rspPending){
    currentReq := io.iCacheReqOut.bits
    rspPending := true.B
    masterID := true.B   // iCache
    rspHandled := false.B  // response currently being handled
  }



  // Compute dataSize based on number of active bits in the lane mask (size is in bytes)
  dataSize := MuxLookup(currentReq.activeByteLane, 1.U, Seq(
    15.U -> 4.U,
    12.U -> 2.U,
    3.U -> 2.U
  ))

  // Modify data to write
  when(currentReq.isWrite){
    // Compute data2write based on the highest set bit
    val shiftAmount = PriorityEncoder(currentReq.activeByteLane)
    data2write := (currentReq.dataRequest >> (shiftAmount * 8.U))

  }

  // Address decoding on response
  when(rspPending){
    when(currentReq.addrRequest(31, 28) === 0xF.U) {
      //Do nothing cause memory mapped IO defined in Wildcattop
      readData := 0.U
      rspValid := true.B
      rspPending := false.B

    }.elsewhen(currentReq.addrRequest(24)){
      // Flash read/write
      io.moduleSel := Seq(true.B, false.B, false.B)
    }.elsewhen(!currentReq.addrRequest(23)) {
      // RAMa read/write
      io.moduleSel := Seq(false.B, true.B, false.B)

    }.elsewhen(currentReq.addrRequest(23)) {
      // RAMb read/write
      io.moduleSel := Seq(false.B, false.B, true.B)
    }.otherwise{
      // undefined
    }
  }

  // Process responses
  when(io.SPIctrl.done) {
    rspPending := false.B
    when(!currentReq.isWrite) {
      readData := io.SPIctrl.dataOut
    }
    rspValid := true.B
    rspHandled := true.B // Mark response as handled
  }

  when(rspValid){
    when(masterID){ // iCache requested
      io.iCacheRspIn.valid := true.B
    }.otherwise{ // dCache requested
      io.dCacheRspIn.valid := true.B
    }
  }

  // Deassert SPI enable signals when done with transaction
  when(rspHandled && !rspPending) {
    // Safe to deassert all device enables when response is handled and no pending request
    io.moduleSel := Seq.fill(3)(false.B)
  }

  when(io.startup){
    io.moduleSel := Seq(false.B, true.B, true.B)
  }

}

