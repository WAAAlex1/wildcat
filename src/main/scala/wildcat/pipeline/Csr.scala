package wildcat.pipeline

import chisel3._
import chisel3.util._
import wildcat.CSR._

/**
 * Control and Status Registers File - Simple Implementation without masking
 * and also with simple exception handling (No reason for editing MSTATUS).
 */
class Csr() extends Module {
  val io = IO(new Bundle {
    // INPUTS
    val address       = Input(UInt(12.W))
    val writeEnable   = Input(Bool())
    val writeData     = Input(UInt(32.W))
    val readEnable    = Input(Bool())
    val instrComplete = Input(Bool())

    // OUTPUTS
    val data        = Output(UInt(32.W))
    val mretTarget  = Output(UInt(32.W))   // For MRET instruction

    // Exception handling signals
    val exception       = Input(Bool())
    val exceptionCause  = Input(UInt(32.W))
    val exceptionPC     = Input(UInt(32.W))
    val instruction     = Input(UInt(32.W))
    val trapVector      = Output(UInt(32.W))
  })

  // Create a CSR file supporting the entire range of registers (4096)
  val csrMem = SyncReadMem(4096, UInt(32.W))

  // Special registers for counters
  val cycle = RegInit(0.U(32.W))
  val cycleh = RegInit(0.U(32.W))
  val instret = RegInit(0.U(32.W))
  val instreth = RegInit(0.U(32.W))

  // Update cycle counter every cycle
  cycle := cycle + 1.U
  when(cycle === 0.U) {
    cycleh := cycleh + 1.U
  }

  // Update Instruction complete counter
  when(io.instrComplete) {
    instret := instret + 1.U
    when(instret === 0.U) {
      instreth := instreth + 1.U
    }
  }

  // Read operation
  val readData = Wire(UInt(32.W))
  readData := 0.U
  when(io.readEnable) {
    readData := csrMem.read(io.address)
    // Special cases for specific CSR addresses
    when(io.address === CYCLE.U)     { readData := cycle }
    when(io.address === CYCLEH.U)    { readData := cycleh }
    when(io.address === TIME.U)      { readData := cycle }
    when(io.address === TIMEH.U)     { readData := cycleh }
    when(io.address === MCYCLE.U)    { readData := cycle }
    when(io.address === MCYCLEH.U)   { readData := cycleh }
    when(io.address === INSTRET.U)   { readData := instret }
    when(io.address === INSTRETH.U)  { readData := instreth }
    when(io.address === MINSTRET.U)  { readData := instret }
    when(io.address === MINSTRETH.U) { readData := instreth }
    when(io.address === MARCHID.U)   { readData := WILDCAT_MARCHID.U }
    when(io.address === MVENDORID.U) { readData := WILDCAT_VENDORID.U }
    when(io.address === MISA.U)      { readData := WILDCAT_MISA.U }
  }
  io.data := readData

  // Helper function to determine if a CSR is read-only
  def isReadOnly(addr: UInt): Bool = {
    // Check address ranges 0xC00-0xCFF and 0xD00-0xDFF (read-only ranges)
    val upperBits = addr(11, 8)
    val isStandardReadOnly = (upperBits === "b1100".U) || (upperBits === "b1101".U)

    // Check specific read-only registers
    val specificReadOnly = (addr === MARCHID.asUInt) ||
      (addr === MVENDORID.asUInt) ||
      (addr === HARTID.asUInt)

    isStandardReadOnly || specificReadOnly
  }

  // Write operation
  when(io.writeEnable) {
    // Special handling for counter registers
    when(io.address === CYCLE.asUInt || io.address === TIME.asUInt || io.address === MCYCLE.asUInt) {
      cycle := io.writeData
    }.elsewhen(io.address === CYCLEH.asUInt || io.address === TIMEH.asUInt || io.address === MCYCLEH.asUInt) {
      cycleh := io.writeData
    }.elsewhen(io.address === INSTRET.asUInt || io.address === MINSTRET.asUInt) {
      instret := io.writeData
    }.elsewhen(io.address === INSTRETH.asUInt || io.address === MINSTRETH.asUInt) {
      instreth := io.writeData
    }.elsewhen(isReadOnly(io.address)) {
      // Empty : Don't write to read-only registers
    }.otherwise {
      // For all other CSRs, write directly - for a minimal RISC-V this is sufficient
      csrMem.write(io.address, io.writeData)
    }
  }

  // Provide MEPC content for MRET instruction
  io.mretTarget := csrMem.read(MEPC.asUInt)

  // Handle exceptions
  when(io.exception) {
    // Save PC to MEPC
    csrMem.write(MEPC.asUInt, io.exceptionPC)
    // Save cause to MCAUSE
    csrMem.write(MCAUSE.asUInt, io.exceptionCause)
    // Save instr to MTVAL
    csrMem.write(MTVAL.asUInt, io.instruction)
  }

  // Trap vector address
  io.trapVector := csrMem.read(MTVEC.asUInt)


  // ------------------------ DEBUGGING ------------------------------
  when(io.readEnable) {
    printf("CSR READ: addr=0x%x, data=0x%x\n", io.address, readData)
  }

  when(io.writeEnable) {
    printf("CSR WRITE: addr=0x%x, data=0x%x\n", io.address, io.writeData)
  }

  // Debug dump for mepc
  when(io.address === 0x341.U) {
    printf("MEPC access: read=%d, write=%d, value=0x%x\n",
      io.readEnable, io.writeEnable,
      Mux(io.writeEnable, io.writeData, readData))
  }

  //-------------------------------------------------------------------

}