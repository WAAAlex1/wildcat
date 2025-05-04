package wildcat.pipeline

import chisel3._
import wildcat.pipeline.Functions._

/*
 * This file is part of the RISC-V processor Wildcat.
 *
 * This is a three stage pipeline.
 *
 * 0. PC generation
 * 1. Fetch
 * 2. Decode, register read, memory address computation and write
 * 3. Execute, memory read
 *
 * Author: Martin Schoeberl (martin@jopdesign.com)
 *
 * CSR Instruction handling / Exception handling added by:
 * Alexander Aakersø and Georg Dyvad
 */
class ThreeCats(freqHz: Int = 100000000) extends Wildcat() {
  // some forward declarations
  val stall = WireDefault(false.B)
  val wbData = Wire(UInt(32.W))
  val wbDest = Wire(UInt(5.W))
  val wrEna = WireDefault(true.B)

  val doBranch = WireDefault(false.B)
  val branchTarget = WireDefault(0.U)

  // Forwarding data and register
  val exFwd = new Bundle() {
    val valid = Bool()
    val wbDest = UInt(5.W)
    val wbData = UInt(32.W)
  }
  val exFwdReg = RegInit(0.U.asTypeOf(exFwd))

  // PC generation
  // the following should be correct, but 2 tests fail
  // val pcReg = RegInit(-4.S(32.W).asUInt)
  val pcReg = RegInit(0.S(32.W).asUInt)
  val pcNext = WireDefault(Mux(doBranch, branchTarget, pcReg + 4.U))
  pcReg := pcNext
  io.imem.address := pcNext

  // Control signal for if processor has been initialized -- used to prevent exceptions at startup/reset
  val processorInitialized = RegInit(false.B)
  val initCounter = RegInit(0.U(2.W))

  // simple counter which toggles processorInitialized after 3 clock cycles
  when (!processorInitialized) {
    initCounter := initCounter + 1.U
    when (initCounter === 3.U) {
      processorInitialized := true.B
    }
  }

  // Fetch
  val instr = WireDefault(io.imem.data)
  when (io.imem.stall) {
    instr := 0x00000013.U
    pcNext := pcReg
  }

  /**********************************************************************************************
   *                                                                                            *
   *                                      DECODE STAGE                                          *
   *                This section handles DECODE, REGISTER READ, MEMORY ACCESS                   *
   *                                                                                            *
   **********************************************************************************************/
  val pcRegReg = RegNext(pcReg)
  val instrReg = RegInit(0x00000033.U) // nop on reset
  instrReg := Mux(doBranch, 0x00000033.U, instr)
  val rs1 = instr(19, 15)
  val rs2 = instr(24, 20)
  val rd = instr(11, 7)
  val (rs1Val, rs2Val, debugRegs) = registerFile(rs1, rs2, wbDest, wbData, wrEna, true)

  val decOut = decode(instrReg)

  val decEx = Wire(new Bundle() {
    val decOut = new DecodedInstr()
    val valid = Bool()
    val pc = UInt(32.W)
    val rs1 = UInt(5.W)
    val rs2 = UInt(5.W)
    val rd = UInt(5.W)
    val rs1Val = UInt(32.W)
    val rs2Val = UInt(32.W)
    val csrAddr = UInt(12.W)
    val func3 = UInt(3.W)
    val memLow = UInt(2.W)
    val instruction = UInt(32.W)
    val csr_data = UInt(32.W)
  })
  decEx.decOut := decOut
  decEx.valid := !doBranch
  decEx.pc := pcRegReg
  decEx.rs1 := instrReg(19, 15)
  decEx.rs2 := instrReg(24, 20)
  decEx.rd := instrReg(11, 7)
  decEx.rs1Val := rs1Val
  decEx.rs2Val := rs2Val
  decEx.func3 := instrReg(14, 12)
  decEx.instruction := instrReg
  decEx.csrAddr := instrReg(31, 20)

  // Forwarding to memory
  val address = Mux(wrEna && (wbDest =/= 0.U) && wbDest === decEx.rs1, wbData, rs1Val)
  val data = Mux(wrEna && (wbDest =/= 0.U) && wbDest === decEx.rs2, wbData, rs2Val)

  val memAddress = (address.asSInt + decOut.imm).asUInt
  decEx.memLow := memAddress(1, 0)

  io.dmem.rdAddress := memAddress
  io.dmem.rdEnable := false.B
  io.dmem.wrAddress := memAddress
  io.dmem.wrData := data
  io.dmem.wrEnable := VecInit(Seq.fill(4)(false.B))
  when(decOut.isLoad && !doBranch) {
    io.dmem.rdEnable := true.B
  }
  when(decOut.isStore && !doBranch) {
    val (wrd, wre) = getWriteData(data, decEx.func3, memAddress(1, 0))
    io.dmem.wrData := wrd
    io.dmem.wrEnable := wre
  }

  // --------------------------- CSR IN DECODE (READ) ---------------------------------------
  // DECODE STAGE -> HERE WE READ CSR
  val csr = Module(new Csr(freqHz))
  // Input for mtimecmp (assuming added as per Issue #1 fix) ---
  csr.io.mtimecmpVal := io.mtimecmpVal_in

  // READ CSR IN DECODE STAGE
  csr.io.readEnable := (decOut.isCsrrw && decEx.rd =/= 0.U) || decOut.isCsrrs || decOut.isCsrrc ||
    (decOut.isCsrrwi && decEx.rd =/= 0.U) || decOut.isCsrrsi || decOut.isCsrrci

  // The CSR address comes from the instruction field
  csr.io.readAddress := decEx.csrAddr
  decEx.csr_data := csr.io.data
  // ---------------------------------------------------------------------------------------

  /**********************************************************************************************
   *                                                                                            *
   *                                      EXECUTE STAGE                                         *
   *         This section handles execution, ALU, MEMORY READ, CSR WRITE, TRAPS                 *
   *                                                                                            *
   **********************************************************************************************/

  // Pipeline registers for EX stage
  val decExReg = RegNext(decEx)

  // Forwarding of wbData from EX stage to EX stage
  val v1 = Mux(exFwdReg.valid && exFwdReg.wbDest === decExReg.rs1, exFwdReg.wbData, decExReg.rs1Val)
  val v2 = Mux(exFwdReg.valid && exFwdReg.wbDest === decExReg.rs2, exFwdReg.wbData, decExReg.rs2Val)

  // ---------------------- EXCEPTION HANDLING ----------------------------------------------
  val exceptionCause = WireDefault(0.U(32.W))
  val illegalInstr = decExReg.valid && decExReg.decOut.isIllegal && processorInitialized
  val ecallM = decExReg.valid && decExReg.decOut.isECall

  when(illegalInstr) {
    exceptionCause := 2.U
  }.elsewhen(ecallM) {
    exceptionCause := 11.U
  }

  // Combine exception signals
  val exceptionOccurred = (illegalInstr || ecallM) && decExReg.valid

  // ---------------------- INTERRUPT HANDLING ---------------------------------------------
  // Check for interrupt request *only if* no synchronous exception occurred in this stage
  val takeInterrupt = csr.io.interruptRequest && !exceptionOccurred && decExReg.valid

  // --------------------- CSR HANDLING IN EXECUTE STAGE (WRITE) ---------------------------
  // Signals
  val zimm = decExReg.rs1(4,0)
  // Extract CSR Write address in execute stage
  csr.io.writeAddress := decExReg.instruction(31, 20)
  // Determine when we need to write to a CSR
  csr.io.writeEnable := decExReg.valid && (
    decExReg.decOut.isCsrrw ||
      (decExReg.decOut.isCsrrs && decExReg.rs1 =/= 0.U) ||
      (decExReg.decOut.isCsrrc && decExReg.rs1 =/= 0.U) ||
      decExReg.decOut.isCsrrwi ||
      (decExReg.decOut.isCsrrsi && zimm =/= 0.U) ||
      (decExReg.decOut.isCsrrci && zimm =/= 0.U)
    )

  // Compute the value to write based on CSR operation
  when(decExReg.decOut.isCsrrw) {
    csr.io.writeData := v1 // v1 is forwarded rs1 value
  }.elsewhen(decExReg.decOut.isCsrrs) {
    csr.io.writeData := decExReg.csr_data | v1
  }.elsewhen(decExReg.decOut.isCsrrc) {
    csr.io.writeData := decExReg.csr_data & (~v1).asUInt
  }.elsewhen(decExReg.decOut.isCsrrwi) {
    csr.io.writeData := zimm
  }.elsewhen(decExReg.decOut.isCsrrsi) {
    csr.io.writeData := decExReg.csr_data | zimm
  }.elsewhen(decExReg.decOut.isCsrrci) {
    csr.io.writeData := decExReg.csr_data & (~zimm).asUInt
  }.otherwise {
    csr.io.writeData := 0.U
  }

  // Counting for CSR
  val instrComplete = decExReg.valid && !stall
  csr.io.instrComplete := instrComplete

  // --- Connect Trap Information to CSR Module ---
  // Inform CSR module *if* a trap (exception OR interrupt) is being taken *now*
  csr.io.takeTrap := (exceptionOccurred || takeInterrupt) // Trap occurs if exception or interrupt taken
  csr.io.trapIsInterrupt := takeInterrupt                 // Specify if it's an interrupt
  csr.io.exceptionCause := exceptionCause                 // Provide synchronous cause code
  csr.io.trapPC := decExReg.pc                            // PC of instruction causing trap/interrupt
  csr.io.trapInstruction := decExReg.instruction          // Instruction causing exception (mtval)

  // ALU Operations and result selection
  val res = Wire(UInt(32.W))
  val val2 = Mux(decExReg.decOut.isImm, decExReg.decOut.imm.asUInt, v2)
  res := alu(decExReg.decOut.aluOp, v1, val2)
  when(decExReg.decOut.isLui) {
    res := decExReg.decOut.imm.asUInt
  }
  when(decExReg.decOut.isAuiPc) {
    res := (decExReg.pc.asSInt + decExReg.decOut.imm).asUInt
  }
  when(decExReg.decOut.isCsrrw  ||
    decExReg.decOut.isCsrrs     ||
    decExReg.decOut.isCsrrc     ||
    decExReg.decOut.isCsrrwi    ||
    decExReg.decOut.isCsrrsi    ||
    decExReg.decOut.isCsrrci) {
    res := decExReg.csr_data
  }
  wbDest := decExReg.rd
  wbData := res
  when(decExReg.decOut.isJal || decExReg.decOut.isJalr) {
    wbData := decExReg.pc + 4.U
  }

  // --- Write Enable Logic ---
  // Ensure write enable is only active if the instruction is valid and requests a write (and not stalling)
  val isStalledLoad = decExReg.decOut.isLoad && io.dmem.stall
  wrEna := decExReg.valid && decExReg.decOut.rfWrite && (wbDest =/= 0.U) && !isStalledLoad

  // Branching and jumping
  // Calculate the target address based on priority: Exception > MRET > Interrupt > JALR > JAL/Branch
  when(exceptionOccurred) { // Sync exceptions have highest priority for redirection
    branchTarget := csr.io.trapVector
  }.elsewhen(decExReg.decOut.isMret && decExReg.valid) {
    branchTarget := csr.io.mretTarget
  }.elsewhen(takeInterrupt) { // Interrupts redirect *after* current instruction
    branchTarget := csr.io.trapVector
  }.elsewhen(decExReg.decOut.isJalr) { // JALR target from ALU result
    branchTarget := (res & "hFFFF_FFFE".U ) // Ensure target is 2-byte aligned
  }.otherwise { // JAL or Branch target calculated with immediate
    branchTarget := (decExReg.pc.asSInt + decExReg.decOut.imm).asUInt
  }

  // Branch condition - ordered by priority:
  // 1. Branch instructions that evaluate to true (when valid)
  // 2. JAL, JALR, MRET instructions and exceptions (when valid)
  when(decExReg.valid && ((compare(decExReg.func3, v1, v2) && decExReg.decOut.isBranch) ||
    decExReg.decOut.isJal ||
    decExReg.decOut.isJalr||
    decExReg.decOut.isMret||
    exceptionOccurred     ||
    takeInterrupt         )
  ) {
    doBranch := true.B
  }

  // Memory read access
  when(decExReg.decOut.isLoad && !doBranch) {
    when(!io.dmem.stall) {
      wbData := selectLoadData(io.dmem.rdData, decExReg.func3, decExReg.memLow)
    }.otherwise{
      // Freeze inputs to pipeline stages
      pcNext := pcReg
      instrReg := instrReg
      decExReg := decExReg

      // Guard writes
      exFwdReg.valid := false.B
    }
  }

  // Forwarding register values to ALU
  exFwdReg.valid := wrEna
  exFwdReg.wbDest := wbDest
  exFwdReg.wbData := wbData

  // Just to exit tests -- no longer sufficient with ecall handling
  val stop = decExReg.decOut.isECall && (pcNext === 0.U)


  // ------------------------------ DEBUGGING -------------------------------------
//  when(illegalInstr) {
//    printf("ILLEGAL INSTRUCTION DETECTED: PC=0x%x, Instruction=0x%x\n",
//      decExReg.pc, decExReg.instruction)
//  }
//
//  when(decExReg.decOut.isMret){
//    printf("MRET DETECTED: PC=0x%x, TARGET=0x%x\n",
//      decExReg.pc, csr.io.mretTarget )
//  }
//  when(ecallM){
//    printf("ECALL DETECTED: PC=0x%x, ExceptionPC=0x%x, ExceptionCause=0x%x\n",
//      decExReg.pc, csr.io.exceptionPC, csr.io.exceptionCause)
//  }

  // Add debug wires
  val debug_isJal = Wire(Bool())
  val debug_isJalr = Wire(Bool())
  val debug_branchInstr = Wire(Bool())
  val debug_compareResult = Wire(Bool())

  // In the execute stage
  debug_isJal := decExReg.decOut.isJal
  debug_isJalr := decExReg.decOut.isJalr
  debug_branchInstr := decExReg.decOut.isBranch
  debug_compareResult := compare(decExReg.func3, v1, v2)

  dontTouch(pcReg)
  dontTouch(instr)
  dontTouch(instrReg)
  dontTouch(doBranch)
  dontTouch(branchTarget)
  dontTouch(stall)
  dontTouch(debug_isJal)
  dontTouch(debug_isJalr)
  dontTouch(debug_branchInstr)
  dontTouch(debug_compareResult)

  // ------------------------------------------------------------------------------


}