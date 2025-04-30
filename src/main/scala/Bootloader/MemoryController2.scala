// In src/main/scala/Bootloader/MemoryController.scala
package Bootloader

import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
// *** Import MemoryMap and CLINTLink ***
import wildcat.CSR.MemoryMap
import wildcat.pipeline.CLINTLink // Adjust import path if CLINT.scala is elsewhere

/**
 * Memory controller module for the Wildcat.
 * Handles requests from caches and routes them to SPI RAM or CLINT.
 */
class MemoryController(implicit val config: TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    // Mem IO to TestMem - Keep if still used, otherwise remove/tie-off
    val memIO = Flipped(new TestMemIO())
    val stall = Output(Bool())            // Stall signal (if needed by caches/CPU)
    val bootloading = Input(Bool())     // Bootloader active signal

    // To/From caches via TileLink bus
    val dCacheReqOut = Flipped(Decoupled(new TLRequest))
    val dCacheRspIn = Decoupled(new TLResponse)

    val iCacheReqOut = Flipped(Decoupled(new TLRequest))
    val iCacheRspIn = Decoupled(new TLResponse)

    // To/Form SPI controllers for external RAM
    val SPIctrl = Vec(2, Flipped(new SpiCTRLIO)) // SPI0=RAM0, SPI1=RAM1

    // --- NEW: Interface to CLINT module ---
    val clintLink = new CLINTLink()
  })

  //----------------------------------------------------------------------------
  // Internal State and Registers
  //----------------------------------------------------------------------------
  val currentReq   = Reg(new TLRequest()) // Latched TileLink request
  val rspPending   = RegInit(false.B)     // Is a response to memory/CLINT pending?
  val targetIsCLINT= RegInit(false.B)     // Was the pending request targeting CLINT?
  val targetIsSPI0 = RegInit(false.B)     // Was the pending request targeting SPI0?
  val targetIsSPI1 = RegInit(false.B)     // Was the pending request targeting SPI1?
  val masterID     = RegInit(false.B)     // 0 for dCache, 1 for iCache (source of currentReq)

  val readData     = WireInit(0.U((config.w * 8).W)) // Data received from target (CLINT or SPI)
  val rspValid     = WireInit(false.B)          // Indicates a valid response is ready this cycle

  // Default stall signal
  io.stall := rspPending // Stall upstream if waiting for response (simplistic)

  // Connect TestMem IO (if still used) - Placeholder
  val memory = Module(new TestMem(4096)) // Instantiate if memIO is used
  memory.io <> io.memIO // Connect if memIO is used

  //----------------------------------------------------------------------------
  // Request Arbitration & Latching
  //----------------------------------------------------------------------------
  // Simple arbitration: D-Cache has priority over I-Cache if both valid
  val canAcceptRequest = !rspPending // Can accept if not already handling one
  val dCacheFire = io.dCacheReqOut.valid && canAcceptRequest
  val iCacheFire = io.iCacheReqOut.valid && !io.dCacheReqOut.valid && canAcceptRequest

  io.dCacheReqOut.ready := canAcceptRequest
  io.iCacheReqOut.ready := !io.dCacheReqOut.valid && canAcceptRequest

  when(dCacheFire) {
    currentReq := io.dCacheReqOut.bits
    rspPending := true.B
    masterID   := false.B // D-Cache is master 0
    printf(p"[MemCtrl] D-Cache Request Accepted: Addr=0x${Hexadecimal(io.dCacheReqOut.bits.addrRequest)}, Write=${io.dCacheReqOut.bits.isWrite}\n")
  }.elsewhen(iCacheFire) {
    currentReq := io.iCacheReqOut.bits
    rspPending := true.B
    masterID   := true.B // I-Cache is master 1
    printf(p"[MemCtrl] I-Cache Request Accepted: Addr=0x${Hexadecimal(io.iCacheReqOut.bits.addrRequest)}, Write=${io.iCacheReqOut.bits.isWrite}\n")
  }

  //----------------------------------------------------------------------------
  // Address Decoding and Target Selection (based on latched currentReq)
  //----------------------------------------------------------------------------
  val reqAddr = currentReq.addrRequest
  // Define CLINT address range check (ensure size covers MTIME + 8 bytes)
  val clintRangeEnd = MemoryMap.CLINT_BASE.U + MemoryMap.MTIME_OFFSET.U + 8.U // End address (exclusive?)
  val accessIsCLINT = (reqAddr >= MemoryMap.CLINT_BASE.U) && (reqAddr < clintRangeEnd)

  // Modify SPI selection based on CLINT check
  // Example: use bit 24 if not CLINT and not Bootloader/IO (assuming 0xF... is handled differently)
  val isHighIO = reqAddr(31, 28) === 0xF.U // Check if address is in the 0xFxxxxxxx range
  val accessIsSPI0  = !accessIsCLINT && !isHighIO && !reqAddr(24)
  val accessIsSPI1  = !accessIsCLINT && !isHighIO && reqAddr(24)
  // Add handling for other ranges like Bootloader IO (0xF...) if necessary

  // Latch target only when a new request is accepted
  when(dCacheFire || iCacheFire) {
    targetIsCLINT := accessIsCLINT
    targetIsSPI0  := accessIsSPI0
    targetIsSPI1  := accessIsSPI1
    // Reset rspValid when accepting a new request
    rspValid      := false.B
    printf(p"[MemCtrl] Request Latched: Addr=0x${Hexadecimal(currentReq.addrRequest)} -> Target CLINT=${accessIsCLINT}, SPI0=${accessIsSPI0}, SPI1=${accessIsSPI1}, HighIO=${isHighIO}\n")
  }

  //----------------------------------------------------------------------------
  // Driving Downstream Interfaces (CLINT or SPI) & Response Handling
  //----------------------------------------------------------------------------

  // Default outputs to downstream modules
  for (i <- 0 until 2) {
    io.SPIctrl(i).en     := false.B
    io.SPIctrl(i).rw     := DontCare
    io.SPIctrl(i).rst    := false.B
    io.SPIctrl(i).addr   := DontCare
    io.SPIctrl(i).dataIn := DontCare
    io.SPIctrl(i).size   := DontCare
  }
  io.clintLink.enable  := false.B
  io.clintLink.isWrite := false.B
  io.clintLink.address := 0.U
  io.clintLink.wrData  := 0.U

  // Drive the target and handle response based on the latched request type when a response is pending
  when(rspPending) {
    // Calculate data/size for write once (simplified)
    val dataToWrite = currentReq.dataRequest
    val sizeForSPI = 4.U // Example size, adjust if needed

    when(targetIsCLINT) {
      // --- Drive CLINT Interface ---
      io.clintLink.enable  := true.B // Assert enable for this cycle
      io.clintLink.isWrite := currentReq.isWrite
      io.clintLink.address := currentReq.addrRequest
      io.clintLink.wrData  := dataToWrite
      printf(p"[MemCtrl] Driving CLINT: Addr=0x${Hexadecimal(currentReq.addrRequest)}, Write=${currentReq.isWrite}, Data=0x${Hexadecimal(dataToWrite)}\n")

      // --- CLINT Response Handling (Assumed ready in same cycle enable is high) ---
      readData   := io.clintLink.rdData // Get read data from CLINT (combinational)
      rspValid   := true.B              // Response is valid this cycle
      rspPending := false.B             // Clear pending state for CLINT access
      printf(p"[MemCtrl] CLINT Response generated: ReadData=0x${Hexadecimal(readData)}\n")

    }.elsewhen(targetIsSPI0) {
      // --- Drive SPI0 Interface ---
      io.SPIctrl(0).en     := true.B // Keep enable high until done? Depends on SPI controller
      io.SPIctrl(0).rw     := currentReq.isWrite // Assuming SPI ctrl uses same polarity
      io.SPIctrl(0).addr   := currentReq.addrRequest(23, 0) // Example address mapping
      io.SPIctrl(0).dataIn := dataToWrite
      io.SPIctrl(0).size   := sizeForSPI
      printf(p"[MemCtrl] Driving SPI0: Addr=0x${Hexadecimal(currentReq.addrRequest)}, Write=${currentReq.isWrite}\n")

      // --- SPI0 Response Handling ---
      when(io.SPIctrl(0).done) {
        readData   := io.SPIctrl(0).dataOut
        rspValid   := true.B
        rspPending := false.B // Clear pending state
        io.SPIctrl(0).en := false.B // Deassert enable once done?
        printf(p"[MemCtrl] SPI0 Response received: ReadData=0x${Hexadecimal(readData)}\n")
      }

    }.elsewhen(targetIsSPI1) {
      // --- Drive SPI1 Interface ---
      io.SPIctrl(1).en     := true.B
      io.SPIctrl(1).rw     := currentReq.isWrite
      io.SPIctrl(1).addr   := currentReq.addrRequest(23, 0)
      io.SPIctrl(1).dataIn := dataToWrite
      io.SPIctrl(1).size   := sizeForSPI
      printf(p"[MemCtrl] Driving SPI1: Addr=0x${Hexadecimal(currentReq.addrRequest)}, Write=${currentReq.isWrite}\n")

      // --- SPI1 Response Handling ---
      when(io.SPIctrl(1).done) {
        readData   := io.SPIctrl(1).dataOut
        rspValid   := true.B
        rspPending := false.B // Clear pending state
        io.SPIctrl(1).en := false.B // Deassert enable once done?
        printf(p"[MemCtrl] SPI1 Response received: ReadData=0x${Hexadecimal(readData)}\n")
      }
    }.otherwise {
      // --- Handle other address ranges (e.g., High IO 0xF... or Unmapped) ---
      // This example assumes 0xF... is handled elsewhere or is an error.
      // You might need specific logic here for UART/LEDs if MemoryController handles them.
      // For now, treat as an error/unmapped access.
      printf(p"[MemCtrl] WARNING: Access to unhandled address 0x${Hexadecimal(currentReq.addrRequest)} while rspPending.\n")
      rspValid   := true.B      // Signal completion, maybe with error
      readData   := 0.U         // Or error pattern
      // Set error bit in TLResponse if available/needed
      rspPending := false.B
    }
  }

  //----------------------------------------------------------------------------
  // Driving TileLink Response Channels
  //----------------------------------------------------------------------------
  io.dCacheRspIn.valid := rspValid && !masterID // Response valid for D-Cache if it was the master
  io.iCacheRspIn.valid := rspValid && masterID  // Response valid for I-Cache if it was the master

  // Populate response data (assuming config.uh=false, simple AccessAck/AccessAckData)
  val commonRspBits = Wire(new TLResponse)
  commonRspBits.dataResponse := readData
  commonRspBits.error        := false.B // TODO: Add actual error detection (e.g., from CLINT/SPI errors, or unmapped access)

  io.dCacheRspIn.bits := commonRspBits
  io.iCacheRspIn.bits := commonRspBits

}

// Keep Hexadecimal object if needed and not imported
// object Hexadecimal {
//   def apply(n: UInt): String = scala.math.BigInt(n.litValue).toString(16)
// }