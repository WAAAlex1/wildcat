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
class ThreeCats() extends Wildcat() {
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
    val csrReadVal = UInt(32.W)
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
  val csr = Module(new Csr())

  // READ CSR IN DECODE STAGE
  csr.io.readEnable := (decOut.isCsrrw && decEx.rd =/= 0.U) || decOut.isCsrrs || decOut.isCsrrc ||
    (decOut.isCsrrwi && decEx.rd =/= 0.U) || decOut.isCsrrsi || decOut.isCsrrci

  csr.io.readAddress := decEx.instruction(31, 20)

  // Store the CSR value in the pipeline register
  decEx.csrReadVal := csr.io.data
  // ---------------------------------------------------------------------------------------

  /**********************************************************************************************
   *                                                                                            *
   *                                      EXECUTE STAGE                                         *
   *                This section handles execution of instructions, ALU, MEMORY                 *
   *                                                                                            *
   **********************************************************************************************/

  // Pipeline registers for EX stage
  val decExReg = RegNext(decEx)

  // Forwarding of wbData from EX stage to EX stage
  val v1 = Mux(exFwdReg.valid && exFwdReg.wbDest === decExReg.rs1, exFwdReg.wbData, decExReg.rs1Val)
  val v2 = Mux(exFwdReg.valid && exFwdReg.wbDest === decExReg.rs2, exFwdReg.wbData, decExReg.rs2Val)

  // ---------------------- EXCEPTION HANDLING ----------------------------------------------
  val exceptionCause = WireDefault(0.U(32.W))
  // Detect illegal instruction
  val illegalInstr = decExReg.valid && decExReg.decOut.isIllegal
  // Detect ECALL
  val ecallM = decExReg.valid && decExReg.decOut.isECall

  when(illegalInstr) {
    exceptionCause := 2.U
  }.elsewhen(ecallM) {
    exceptionCause := 11.U
  }

  // Combine exception signals
  val exceptionOccurred = illegalInstr || ecallM

  // Connect exception signals to CSR module
  csr.io.exception := exceptionOccurred
  csr.io.exceptionCause := exceptionCause
  csr.io.exceptionPC := decExReg.pc
  // ---------------------------------------------------------------------------------------

  // --------------------- CSR HANDLING IN EXECUTE STAGE (WRITE) ---------------------------
  // Signals
  val csrWriteData = Wire(UInt(32.W))
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
    csrWriteData := v1 // v1 is forwarded rs1 value
  }.elsewhen(decExReg.decOut.isCsrrs) {
    csrWriteData := decExReg.csrReadVal | v1
  }.elsewhen(decExReg.decOut.isCsrrc) {
    csrWriteData := decExReg.csrReadVal & (~v1).asUInt
  }.elsewhen(decExReg.decOut.isCsrrwi) {
    csrWriteData := zimm
  }.elsewhen(decExReg.decOut.isCsrrsi) {
    csrWriteData := decExReg.csrReadVal | zimm
  }.otherwise { // CSRRCI
    csrWriteData := decExReg.csrReadVal & (~zimm).asUInt
  }

  // Update CSR module signals for the write
  csr.io.writeData := csrWriteData
  csr.io.instruction := decExReg.instruction

  // Counting for CSR
  val instrComplete = decExReg.valid && !stall
  csr.io.instrComplete := instrComplete
  // ----------------------------------------------------------------

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
    res := decExReg.csrReadVal
  }
  wbDest := decExReg.rd
  wbData := res
  when(decExReg.decOut.isJal || decExReg.decOut.isJalr) {
    wbData := decExReg.pc + 4.U
  }

  // Branching and jumping
  // Prioritize Exceptions and MRET
  when(exceptionOccurred) {
    branchTarget := csr.io.trapVector
  }.elsewhen(decExReg.decOut.isMret && decExReg.valid) {
    branchTarget := csr.io.mretTarget
  }.elsewhen(decExReg.decOut.isJalr) {
    branchTarget := res
  }.otherwise{ //Default - normal branching
    branchTarget := (decExReg.pc.asSInt + decExReg.decOut.imm).asUInt
  }

  wrEna := decExReg.valid && decExReg.decOut.rfWrite

  // Branch condition - ordered by priority:
  // 1. Branch instructions that evaluate to true (when valid)
  // 2. JAL, JALR, MRET instructions and exceptions (when valid)
  when(((compare(decExReg.func3, v1, v2) && decExReg.decOut.isBranch) || (
    decExReg.decOut.isJal ||
    decExReg.decOut.isJalr||
    decExReg.decOut.isMret||
    exceptionOccurred))   &&
    decExReg.valid
  ) {
    doBranch := true.B
  }

  // Memory read access
  when(decExReg.decOut.isLoad && !doBranch) {
    when(!io.dmem.stall) {
      res := selectLoadData(io.dmem.rdData, decExReg.func3, decExReg.memLow)
    }.otherwise{
      // Freeze inputs to pipeline stages
      pcNext := pcReg
      instrReg := instrReg
      decExReg := decExReg

      // Guard writes
      exFwdReg.valid := false.B
      decExReg.valid := false.B
    }
  }

  // Forwarding register values to ALU
  exFwdReg.valid := wrEna && (wbDest =/= 0.U)
  exFwdReg.wbDest := wbDest
  exFwdReg.wbData := wbData

  // Just to exit tests -- no longer sufficient with ecall handling
  val stop = decExReg.decOut.isECall


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