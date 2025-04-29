package wildcat.pipeline

import chisel3._
import chisel3.util._
import firrtl.passes.memlib.DefaultWriteFirstAnnotation
import wildcat.CSR
import wildcat.CSR._

/**
 * Control and Status Registers File - Simple Implementation without masking
 * and also with simple exception handling (No reason for editing MSTATUS).
 */
class Csr() extends Module {
  val io = IO(new Bundle {
    // INPUTS
    val readAddress   = Input(UInt(12.W))
    val writeAddress  = Input(UInt(12.W))
    val readEnable    = Input(Bool())
    val writeEnable   = Input(Bool())
    val writeData     = Input(UInt(32.W))
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

  // Special registers for exception handling and forwarding
  val mepcReg = RegInit(0.U(32.W))
  val mcauseReg = RegInit(0.U(32.W))
  val mtvalReg = RegInit(0.U(32.W))
  val mtvecReg = RegInit(0.U(32.W))

  // Register to track CSR addresses for forwarding
  val lastWriteAddr = RegNext(io.writeAddress)
  val lastWriteEnable = RegNext(io.writeEnable && !isReadOnly(io.writeAddress), false.B)
  val lastWriteData = RegNext(io.writeData)

  // Exception handling registers
  val lastExceptionAddr = RegNext(Mux(io.exception,
    Mux(io.readAddress === MEPC.U, MEPC.U,
      Mux(io.readAddress === MCAUSE.U, MCAUSE.U,
        Mux(io.readAddress === MTVAL.U, MTVAL.U, 0.U))), 0.U))
  val lastExceptionOccurred = RegNext(io.exception, false.B)
  val lastExceptionPC = RegNext(io.exceptionPC)
  val lastExceptionCause = RegNext(io.exceptionCause)
  val lastInstruction = RegNext(io.instruction)

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

  // READ OPERATION
  val csrReadData = csrMem.read(io.readAddress, io.readEnable)
  // Output data with forwarding
  val readData = Wire(UInt(32.W))
  // Special handling for counter registers and frequently accessed CSRs
  when(io.readAddress === CYCLE.U)     { readData := cycle }
  .elsewhen(io.readAddress === CYCLEH.U)    { readData := cycleh }
  .elsewhen(io.readAddress === TIME.U)      { readData := cycle }
  .elsewhen(io.readAddress === TIMEH.U)     { readData := cycleh }
  .elsewhen(io.readAddress === MCYCLE.U)    { readData := cycle }
  .elsewhen(io.readAddress === MCYCLEH.U)   { readData := cycleh }
  .elsewhen(io.readAddress === INSTRET.U)   { readData := instret }
  .elsewhen(io.readAddress === INSTRETH.U)  { readData := instreth }
  .elsewhen(io.readAddress === MINSTRET.U)  { readData := instret }
  .elsewhen(io.readAddress === MINSTRETH.U) { readData := instreth }
  .elsewhen(io.readAddress === MARCHID.U)   { readData := WILDCAT_MARCHID.U }
  .elsewhen(io.readAddress === MVENDORID.U) { readData := WILDCAT_VENDORID.U }
  .elsewhen(io.readAddress === MISA.U)      { readData := WILDCAT_MISA.U }
  .elsewhen(io.readAddress === MEPC.U)      { readData := mepcReg }
  .elsewhen(io.readAddress === MCAUSE.U)    { readData := mcauseReg }
  .elsewhen(io.readAddress === MTVAL.U)     { readData := mtvalReg }
  .elsewhen(io.readAddress === MTVEC.U)     { readData := mtvecReg }
  .otherwise                                { readData := csrReadData }

// Forwarding logic: The read was initiated in decode stage and now in execute stage we need the result
  // 1. Same-cycle read/write forwarding (if simultaneous read/write to same CSR)
  // 2. Inter-instruction forwarding (if a previous write affects a current read)
  // 3. Exception forwarding (if an exception updated a CSR)
  when(io.readEnable && io.writeEnable && (io.readAddress === io.writeAddress) && !isReadOnly(io.writeAddress)) {
    // If reading and writing to the same CSR in the same cycle, use the write value
    io.data := io.writeData
  }.elsewhen(io.readEnable && io.exception) {
    // If an exception occurs this cycle, forward exception-related values
    when(io.readAddress === MEPC.U)         { io.data := RegNext(io.exceptionPC) }
    .elsewhen(io.readAddress === MCAUSE.U)  { io.data := RegNext(io.exceptionCause) }
    .elsewhen(io.readAddress === MTVAL.U)   { io.data := RegNext(io.instruction) }
    .otherwise                              { io.data := RegNext(readData) }
  }.elsewhen(io.readEnable && lastWriteEnable && io.readAddress === lastWriteAddr) {
    // If reading a CSR that was written in the previous cycle, forward the written value
    io.data := lastWriteData
  }.elsewhen(io.readEnable && lastExceptionOccurred && io.readAddress === lastExceptionAddr) {
    // If reading a CSR that was affected by an exception in the previous cycle
    when(io.readAddress === MEPC.U)         { io.data := lastExceptionPC }
    .elsewhen(io.readAddress === MCAUSE.U)  { io.data := lastExceptionCause }
    .elsewhen(io.readAddress === MTVAL.U)   { io.data := lastInstruction }
    .otherwise                              { io.data := readData }
  }.otherwise {
    // Normal case - use the value from readData (which already handles special CSRs)
    io.data := readData
  }

  // Write operation
  // Shadow registers for critical registers: MTVEC, MEPC, MCAUSE, MTVAL
  when(io.writeEnable) {
    // Special handling for counter registers
    when(io.writeAddress === CYCLE.asUInt || io.writeAddress === TIME.asUInt || io.writeAddress === MCYCLE.asUInt) {
      cycle := io.writeData
    }.elsewhen(io.writeAddress === CYCLEH.asUInt || io.writeAddress === TIMEH.asUInt || io.writeAddress === MCYCLEH.asUInt) {
      cycleh := io.writeData
    }.elsewhen(io.writeAddress === INSTRET.asUInt || io.writeAddress === MINSTRET.asUInt) {
      instret := io.writeData
    }.elsewhen(io.writeAddress === INSTRETH.asUInt || io.writeAddress === MINSTRETH.asUInt) {
      instreth := io.writeData
    }.elsewhen(io.writeAddress === MEPC.asUInt) {
      mepcReg := io.writeData
    }.elsewhen(io.writeAddress === MCAUSE.asUInt) {
      mcauseReg := io.writeData
    }.elsewhen(io.writeAddress === MTVAL.asUInt) {
      mtvalReg := io.writeData
    }.elsewhen(io.writeAddress === MTVEC.asUInt) {
      mtvecReg := io.writeData
    }.otherwise {
      // For all other CSRs, write to memory (if not read-only)
      when(!(isReadOnly(io.writeAddress))){
        csrMem.write(io.writeAddress, io.writeData)
        // printf("CSR WRITE: address=0x%x, data=0x%x\n", io.writeAddress, io.writeData)
      }
    }
  }

  // Handle exceptions
  when(io.exception) {
    // Save PC to MEPC
    mepcReg := io.exceptionPC
    // Save cause to MCAUSE
    mcauseReg := io.exceptionCause
    // Save instr to MTVAL
    mtvalReg := io.instruction
//    printf("MEPC(0x%x)=0x%x  ||  MCAUSE(0x%x)=0x%x ||  MTVAL(0x%x)=0x%x\n",
//      MEPC.asUInt, io.exceptionPC, MCAUSE.asUInt, io.exceptionCause, MTVAL.asUInt, io.instruction)
  }

  // Provide MEPC content for MRET instruction
  io.mretTarget := mepcReg

  // Trap vector address
  io.trapVector := mtvecReg

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

  // ------------------------ DEBUGGING ------------------------------
//  when(io.readEnable) {
//    printf("CSR READ: addr=0x%x, data=0x%x\n", io.address, readData)
//  }

//  when(io.writeEnable) {
//    printf("CSR WRITE: addr=0x%x, data=0x%x\n", io.address, io.writeData)
//  }

  // Debug dump for mepc
//  when(io.readAddress === 0x341.U && io.readEnable) {
//    printf("MEPC READ access: value=0x%x\n", csrMem.read(MEPC.asUInt))
//  }
//  when(io.writeAddress === 0x341.U && io.writeEnable) {
//    printf("MEPC WRITE access: value=0x%x\n", io.writeData)
//  }
  //-------------------------------------------------------------------

}