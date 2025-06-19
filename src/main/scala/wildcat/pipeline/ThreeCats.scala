package wildcat.pipeline

import chisel3._
import wildcat.pipeline.Functions._
import uart._

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
  // Some forward declarations
  val wbData = Wire(UInt(32.W))
  val wbDest = Wire(UInt(5.W))
  val wrEna = WireDefault(true.B)

  // Control signals
  val doBranch = WireDefault(false.B)
  val branchTarget = WireDefault(0.U(32.W))
  val inSleepMode = RegInit(false.B)
  val stall = WireDefault(io.dmem.stall || inSleepMode || io.imem.stall) // io.Bootloader_Stall) // Basic stall based on memory readiness and wfi
  val exceptionOccurred = WireDefault(false.B)
  val takeInterrupt = WireDefault(false.B)

  io.UARTport.init()

  // Forwarding data and register
  val exFwd = new Bundle() {
    val valid = Bool()
    val wbDest = UInt(5.W)
    val wbData = UInt(32.W)
  }
  val exFwdReg = RegInit(0.U.asTypeOf(exFwd))

  // Simple initialization flag
  val processorInitialized = RegInit(false.B)
  val initCounter = RegInit(0.U(2.W))
  when (!processorInitialized) {
    initCounter := initCounter + 1.U
    when (initCounter === 3.U) {
      processorInitialized := true.B
    }
  }

  /** ********************************************************************************************
   * FETCH STAGE & PC GEN
   * ******************************************************************************************** */

  // PC generation
  val pcReg = RegInit(-4.S(32.W).asUInt) // Start at address 0
  //val pcReg = RegInit(0.U(32.W)) // Start at address 0
  val pcNext = WireDefault(pcReg + 4.U)   // Update PC
  when(stall && !takeInterrupt) { pcNext := pcReg         }
    .elsewhen(doBranch)         { pcNext := branchTarget  }

  pcReg := pcNext
  io.imem.address := pcNext

  //Begin fetch instruction
  val instr = WireDefault(io.imem.data)

  // Instruction Register
  val pcRegReg = RegNext(pcReg)
  val instrReg = RegInit(0x00000013.U) // nop on reset
  instrReg := Mux(doBranch, 0x00000013.U, Mux(stall, instrReg, instr))

  when(io.Bootloader_Stall || io.imem.stall) {
    instr := 0x00000013.U
    pcNext := pcReg
  }

  /** ********************************************************************************************
   * DECODE STAGE
   * ******************************************************************************************** */

  // Decode instruction & Register Addresses
  val decOut = decode(instrReg)
  val rs1 = WireDefault(instr(19, 15))
  val rs2 = WireDefault(instr(24, 20))
  val rd = WireDefault(instr(11, 7))

  when(stall){
    rs1 := instrReg(19, 15)
    rs2 := instrReg(24, 20)
    rd := instrReg(11, 7)
  }

  val (rs1Val, rs2Val, debugRegs) = registerFile(rs1, rs2, wbDest, wbData, wrEna, true)

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

  // Data Memory Access Initiation
  val memAddress = (address.asSInt + decOut.imm).asUInt
  decEx.memLow := memAddress(1, 0)

  io.dmem.rdAddress := memAddress
  io.dmem.wrAddress := memAddress
  io.dmem.rdEnable  := decOut.isLoad && !doBranch
  io.dmem.wrEnable  := VecInit(Seq.fill(4)(false.B))
  io.dmem.wrData    := data

  when(decOut.isStore && !doBranch) { // && !stall ?
    val (wrd, wre) = getWriteData(data, decEx.func3, memAddress(1, 0))
    io.dmem.wrData := wrd
    io.dmem.wrEnable := wre

    when(memAddress === "hF000_0004".U){
      io.UARTport.writeRequest(0.U, wrd)
    }
  }

  // UART DRIVE CONNECTIONS
  when(memAddress=== "hF000_0000".U && (decOut.isLoad && !doBranch)) { // UART status reg
    io.UARTport.readRequest(1.U)
  }
  when(memAddress === "hF000_0004".U && (decOut.isLoad && !doBranch)) { // UART Send and receive reg
    io.UARTport.readRequest(0.U)
  }

  /**********************************************************************************************
   * EXECUTE STAGE
   **********************************************************************************************/
  // Pipeline registers for EX stage
  val decExReg = RegNext(decEx)
  when(stall){
    decExReg := decExReg
    decExReg.valid := false.B
  }

  // Forwarding of wbData from EX stage to EX stage
  val v1 = Mux(exFwdReg.valid && exFwdReg.wbDest === decExReg.rs1, exFwdReg.wbData, decExReg.rs1Val)
  val v2 = Mux(exFwdReg.valid && exFwdReg.wbDest === decExReg.rs2, exFwdReg.wbData, decExReg.rs2Val)

  // CSR MODULE ---------------------------------------------------------------------------------
  val csr = Module(new Csr(freqHz))

  // IO CONNECTIONS (timerCounter to CLINT, mtimecmpVal from CLINT)
  io.timerCounter_out := csr.io.timerCounter
  csr.io.mtimecmpVal := io.mtimecmpVal_in

  // CSR READ (IN:ADDRESS, IN:ENABLE, OUT:DATA) - instantaneous
  csr.io.readAddress := decExReg.csrAddr
  csr.io.readEnable := (decExReg.decOut.isCsrrw && decExReg.rd =/= 0.U) || decExReg.decOut.isCsrrs || decExReg.decOut.isCsrrc ||
    (decExReg.decOut.isCsrrwi && decExReg.rd =/= 0.U) || decExReg.decOut.isCsrrsi || decExReg.decOut.isCsrrci
  val csr_read_data = csr.io.data

  // CSR WRITE (IN:ADDRESS, IN:ENABLE, IN:DATA) - synchronous
  csr.io.writeAddress := decExReg.csrAddr
  csr.io.writeEnable := decExReg.valid && (
    decExReg.decOut.isCsrrw ||
      (decExReg.decOut.isCsrrs && decExReg.rs1 =/= 0.U) ||
      (decExReg.decOut.isCsrrc && decExReg.rs1 =/= 0.U) ||
      decExReg.decOut.isCsrrwi ||
      (decExReg.decOut.isCsrrsi && decExReg.rs1(4,0) =/= 0.U) ||
      (decExReg.decOut.isCsrrci && decExReg.rs1(4,0) =/= 0.U)
    )
  when(decExReg.decOut.isCsrrw)         { csr.io.writeData := v1 }
    .elsewhen(decExReg.decOut.isCsrrs)    { csr.io.writeData := csr_read_data | v1 }
    .elsewhen(decExReg.decOut.isCsrrc)    { csr.io.writeData := csr_read_data & (~v1).asUInt }
    .elsewhen(decExReg.decOut.isCsrrwi)   { csr.io.writeData := decExReg.rs1(4,0) }
    .elsewhen(decExReg.decOut.isCsrrsi)   { csr.io.writeData := csr_read_data | decExReg.rs1(4,0) }
    .elsewhen(decExReg.decOut.isCsrrci)   { csr.io.writeData := csr_read_data & (~decExReg.rs1(4,0)).asUInt }
    .otherwise                            { csr.io.writeData := 0.U }

  // Counting for CSR
  val instrComplete = decExReg.valid && !stall && !decExReg.decOut.isECall && !(exceptionOccurred || takeInterrupt)// ECALL Should not increment instret CSR
  csr.io.instrComplete := instrComplete

  // Trap handling
  val illegalInstr = decExReg.valid && decExReg.decOut.isIllegal && processorInitialized
  val isECALL = decExReg.valid && decExReg.decOut.isECall
  exceptionOccurred := (illegalInstr || isECALL) && decExReg.valid
  takeInterrupt := csr.io.interruptRequest && !exceptionOccurred && (decExReg.valid || inSleepMode)

  val exceptionCause = WireDefault(0.U(32.W))
  when(illegalInstr)  { exceptionCause := 2.U}
    .elsewhen(isECALL)   { exceptionCause := 11.U}

  // Trap Handling Connections
  csr.io.takeTrap := (exceptionOccurred || takeInterrupt)                   // Trap occurs if exception or interrupt taken
  csr.io.trapIsInterrupt := takeInterrupt                                   // Specify if it's an interrupt
  csr.io.exceptionCause := exceptionCause                                   // Provide synchronous cause code
  csr.io.trapPC := decExReg.pc                                              // PC of instruction causing trap/interrupt
  csr.io.trapInstruction := Mux(isECALL, 0.U, decExReg.instruction)         // Instruction causing exception (mtval)
  csr.io.mret_executing   := decExReg.valid && decExReg.decOut.isMret && !stall
  // -------------------------------------------------------------------------------------------------------

  // ALU Operations and result selection -------------------------------------------------------------------
  val val2 = Mux(decExReg.decOut.isImm, decExReg.decOut.imm.asUInt, v2)
  val aluResult = alu(decExReg.decOut.aluOp, v1, val2)

  // Determine final result for write back
  val finalResult = WireDefault(aluResult) // Default to ALU result
  when(decExReg.decOut.isLui)   { finalResult := decExReg.decOut.imm.asUInt } // LUI
  when(decExReg.decOut.isAuiPc) { finalResult := (decExReg.pc.asSInt + decExReg.decOut.imm).asUInt } // AUIPC
  when(decExReg.decOut.isCsrrw  ||
    decExReg.decOut.isCsrrs     ||
    decExReg.decOut.isCsrrc     ||
    decExReg.decOut.isCsrrwi    ||
    decExReg.decOut.isCsrrsi    ||
    decExReg.decOut.isCsrrci) {
    finalResult := csr_read_data // CSR
  }

  // Write Back Data and Destination
  wbDest := decExReg.rd
  wbData := finalResult
  when(decExReg.decOut.isJal || decExReg.decOut.isJalr) { wbData := decExReg.pc + 4.U } // JAL / JALR

  // Write Enable - active if the instruction is valid and requests a write
  wrEna := decExReg.valid && decExReg.decOut.rfWrite && (wbDest =/= 0.U) && !(exceptionOccurred || takeInterrupt)

  // Determine if branch is taken and the target address
  // order -> exception/interrupt, MRET, JALR, JAL, Branch
  when((exceptionOccurred || takeInterrupt)) {
    doBranch := true.B
    branchTarget := csr.io.trapVector
  }.elsewhen(decExReg.valid && decExReg.decOut.isMret) {
    doBranch := true.B
    branchTarget := csr.io.mretTarget
  }.elsewhen(decExReg.valid && decExReg.decOut.isJalr) {
    doBranch := true.B
    branchTarget := (aluResult & "hFFFF_FFFE".U )
  }.elsewhen(decExReg.valid && decExReg.decOut.isJal) {
    doBranch := true.B
    branchTarget := (decExReg.pc.asSInt + decExReg.decOut.imm).asUInt
  }.elsewhen(decExReg.valid && decExReg.decOut.isBranch && compare(decExReg.func3, v1, v2)) {
    doBranch := true.B
    branchTarget := (decExReg.pc.asSInt + decExReg.decOut.imm).asUInt
  }.otherwise {
    doBranch := false.B
    branchTarget := (decExReg.pc.asSInt + decExReg.decOut.imm).asUInt // Default target
  }

  // Memory Read Access
  when(decExReg.decOut.isLoad && !doBranch) { // LOAD
    finalResult := selectLoadData(io.dmem.rdData, decExReg.func3, decExReg.memLow)
  }

  // Forwarding register values to ALU
  exFwdReg.valid := !stall && wrEna
  exFwdReg.wbDest := wbDest
  exFwdReg.wbData := wbData

  // WFI Handling
  when(decExReg.valid && decExReg.decOut.isWfi && processorInitialized) {
    // If interrupts already pending, WFI should immediately continue
    when(csr.io.interruptRequest) {
      inSleepMode := false.B // Ensure we're not in sleep mode
    }.elsewhen(csr.io.globalInterruptEnabled && csr.io.timerInterruptEnabled) {
      inSleepMode := true.B
      doBranch := true.B // Immediately flush the pipeline by branching to current pc
      branchTarget := decExReg.pc
    }.otherwise {
      //printf("[CPU] WFI with interrupts disabled - continuing as NOP\n")
    }
  }
  // WFI handling - Leaving Sleep mode
  when(inSleepMode && csr.io.interruptRequest) {
    inSleepMode := false.B
    //printf("[CPU] Wake up! Interrupt detected during sleep mode\n")
  }

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
  //dontTouch(debugRegs)

  // ------------------------------------------------------------------------------


}