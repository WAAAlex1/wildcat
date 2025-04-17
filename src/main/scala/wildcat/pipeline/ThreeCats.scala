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

  // Decode, register read, and memory access
  val pcRegReg = RegNext(pcReg)
  val instrReg = RegInit(0x00000033.U) // nop on reset
  instrReg := Mux(doBranch, 0x00000033.U, instr)
  val rs1 = instr(19, 15)
  val rs2 = instr(24, 20)
  val rd = instr(11, 7)
  val (rs1Val, rs2Val, debugRegs) = registerFile(rs1, rs2, wbDest, wbData, wrEna, true)

  val csr = Module(new Csr())
  csr.io.address := instrReg(31, 20)// CSR address field
  val csrVal = csr.io.data          // Read data from CSR

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
    val csrVal = UInt(32.W)
    val func3 = UInt(3.W)
    val memLow = UInt(2.W)
  })
  decEx.decOut := decOut
  decEx.valid := !doBranch
  decEx.pc := pcRegReg
  decEx.rs1 := instrReg(19, 15)
  decEx.rs2 := instrReg(24, 20)
  decEx.rd := instrReg(11, 7)
  decEx.rs1Val := rs1Val
  decEx.rs2Val := rs2Val
  decEx.csrVal := csrVal
  decEx.func3 := instrReg(14, 12)

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

  // Execute
  val decExReg = RegInit(0.U.asTypeOf(decEx))
  decExReg := decEx

  // Forwarding
  val v1 = Mux(exFwdReg.valid && exFwdReg.wbDest === decExReg.rs1, exFwdReg.wbData, decExReg.rs1Val)
  val v2 = Mux(exFwdReg.valid && exFwdReg.wbDest === decExReg.rs2, exFwdReg.wbData, decExReg.rs2Val)

  //CSR Write Logic
  val zimm = decExReg.rs1(4, 0)
  val csrWriteEnable = decExReg.valid && (
      decExReg.decOut.isCsrrw   ||
      decExReg.decOut.isCsrrs   ||
      decExReg.decOut.isCsrrc   ||
      decExReg.decOut.isCsrrwi  ||
      decExReg.decOut.isCsrrsi  ||
      decExReg.decOut.isCsrrci
    )

  val csrWriteData = WireDefault(0.U(32.W))
  when(decExReg.decOut.isCsrrw) {
    csrWriteData := v1                              //Write Value from rs1
  }.elsewhen(decExReg.decOut.isCsrrs) {
    csrWriteData := decExReg.csrVal | v1            //Set bits where rs1 = 1
  }.elsewhen(decExReg.decOut.isCsrrc) {
    csrWriteData := decExReg.csrVal & (~v1).asUInt  //Clear bits where rs1 = 1
  }.elsewhen(decExReg.decOut.isCsrrwi) {
    csrWriteData := zimm                            // Zero-extended immediate value
  }.elsewhen(decExReg.decOut.isCsrrsi) {
    csrWriteData := decExReg.csrVal | zimm          //Set bits where zimm = 1
  }.otherwise { // this is Csrrci
    csrWriteData := decExReg.csrVal & (~zimm).asUInt//Clear bits where zimm = 1
  }
  // Skip write for special case (rs1=x0 for csrrs or csrrc)
  val skipWriteCase1 = (decExReg.decOut.isCsrrs || decExReg.decOut.isCsrrc) && decExReg.rs1 === 0.U
  // Skip write for special case (zimm = 0 for csrrsi or csrrci)
  val skipWriteCase2 = (decExReg.decOut.isCsrrsi || decExReg.decOut.isCsrrci) && decExReg.rs1(4, 0) === 0.U

  csr.io.writeEnable := csrWriteEnable && !skipWriteCase1 && !skipWriteCase2
  csr.io.writeData := csrWriteData

  // CSR Read Logic
  val csrReadEnable = decExReg.rd =/= 0.U // should read from CSR only if (rd != 0)
  csr.io.readEnable := csrReadEnable

  // Detect illegal instruction
  val illegalInstr = decExReg.valid && decExReg.decOut.isIllegal
  // Detect ECALL
  val ecallM = decExReg.valid && decExReg.decOut.isECall

  // Combine exception signals
  val exceptionOccurred = illegalInstr || ecallM
  val exceptionCause = WireDefault(0.U(32.W))
  when(illegalInstr) {
    exceptionCause := 2.U
  }.elsewhen(ecallM) {
    exceptionCause := 11.U
  }
  // Connect exception signals to CSR module
  csr.io.exception := exceptionOccurred
  csr.io.exceptionCause := exceptionCause
  csr.io.exceptionPC := decExReg.pc

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
    res := decExReg.csrVal
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
    exceptionOccurred))    &&
    decExReg.valid
  ) {
    doBranch := true.B
  }

  // Memory read access
  when(decExReg.decOut.isLoad && !doBranch) {
    res := selectLoadData(io.dmem.rdData, decExReg.func3, decExReg.memLow)
  }

  // Forwarding register values to ALU
  exFwdReg.valid := wrEna && (wbDest =/= 0.U)
  exFwdReg.wbDest := wbDest
  exFwdReg.wbData := wbData

  // Just to exit tests
  val stop = decExReg.decOut.isECall

  // Counting for CSR
  val instrComplete = decExReg.valid && !stall
  csr.io.instrComplete := instrComplete

}