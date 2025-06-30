package wildcat

import chisel3._
import chisel3.util.experimental.BoringUtils
import wildcat.pipeline._


/*
 * Top-level for testing and verification
 *
 */
class WildcatTestTop(file: String, freqHz: Int = 100000000, baudrate: Int = 115200) extends Module {

  val io = IO(new Bundle {
    val regFile = Output(Vec(32,UInt(32.W)))
    val led = Output(UInt(8.W))
    val tx = Output(UInt(1.W))
    val rx = Input(UInt(1.W))
    val stop = Output(Bool())

    // Add debug outputs to IO bundle
    val debug_pc = Output(UInt(32.W))
    val debug_instr = Output(UInt(32.W))
    val debug_doBranch = Output(Bool())
    val debug_branchTarget = Output(UInt(32.W))
    val debug_stall = Output(Bool())
    val debug_csrWrite = Output(Bool())
    val debug_csrResult = Output(UInt(32.W))
    val debug_isIllegal = Output(Bool())
    val debug_isValid = Output(Bool())
    val debug_timer = Output(UInt(64.W))
    val debug_timerInterruptActive = Output(Bool())
    val debug_timerInterruptEnabled = Output(Bool())
    val debug_globalInterruptEnabled = Output(Bool())
    val debug_interruptRequest = Output(Bool())
    val debug_mtimecmp = Output(UInt(32.W))
  })
  val cpuTop = Module(new WildcatTop(file = file, freqHz = freqHz, baudrate = baudrate))

  io.regFile := DontCare
  BoringUtils.bore(cpuTop.cpu.debugRegs, Seq(io.regFile))
  io.stop := DontCare
  BoringUtils.bore(cpuTop.cpu.stop, Seq(io.stop))
  io.led := DontCare
  BoringUtils.bore(cpuTop.ledReg, Seq(io.led))

  // Initialize debug outputs with default values
  io.debug_pc := 0.U
  io.debug_instr := 0.U
  io.debug_doBranch := false.B
  io.debug_branchTarget := 0.U
  io.debug_stall := false.B
  io.debug_csrWrite := false.B
  io.debug_csrResult := 0.U
  io.debug_isIllegal := false.B
  io.debug_isValid := false.B
  io.debug_timer := 0.U
  io.debug_interruptRequest := false.B
  io.debug_timerInterruptActive := false.B
  io.debug_timerInterruptEnabled := false.B
  io.debug_globalInterruptEnabled := false.B
  io.debug_mtimecmp := 0.U

  BoringUtils.bore(cpuTop.cpu.decExReg.pc, Seq(io.debug_pc))
  BoringUtils.bore(cpuTop.cpu.decExReg.instruction, Seq(io.debug_instr))
  BoringUtils.bore(cpuTop.cpu.doBranch, Seq(io.debug_doBranch))
  BoringUtils.bore(cpuTop.cpu.branchTarget, Seq(io.debug_branchTarget))
  BoringUtils.bore(cpuTop.cpu.stall, Seq(io.debug_stall))
  BoringUtils.bore(cpuTop.cpu.csr.io.writeEnable, Seq(io.debug_csrWrite))
  BoringUtils.bore(cpuTop.cpu.csr.io.data, Seq(io.debug_csrResult))
  BoringUtils.bore(cpuTop.cpu.decExReg.decOut.isIllegal, Seq(io.debug_isIllegal))
  BoringUtils.bore(cpuTop.cpu.decExReg.valid, Seq(io.debug_isValid))
  BoringUtils.bore(cpuTop.cpu.io.timerCounter_out, Seq(io.debug_timer))
  BoringUtils.bore(cpuTop.cpu.csr.interruptController.timerInterruptEnabled, Seq(io.debug_timerInterruptEnabled))
  BoringUtils.bore(cpuTop.cpu.csr.interruptController.io.globalInterruptEnable, Seq(io.debug_globalInterruptEnabled))
  BoringUtils.bore(cpuTop.cpu.csr.interruptController.io.interruptRequest, Seq(io.debug_interruptRequest))
  BoringUtils.bore(cpuTop.cpu.csr.interruptController.timerInterruptActive, Seq(io.debug_timerInterruptActive))
  BoringUtils.bore(cpuTop.clint.mtimecmpReg, Seq(io.debug_mtimecmp))
  cpuTop.io.rx := io.rx
  io.tx := cpuTop.io.tx
}