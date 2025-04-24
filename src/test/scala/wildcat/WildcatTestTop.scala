package wildcat

import chisel3._
import chisel3.util.experimental.BoringUtils
import wildcat.pipeline._


/*
 * Top-level for testing and verification
 *
 */
class WildcatTestTop(file: String) extends Module {

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
  })
  val cpuTop = Module(new WildcatTop(file))

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

  BoringUtils.bore(cpuTop.cpu.pcReg, Seq(io.debug_pc))
  BoringUtils.bore(cpuTop.cpu.decExReg.instruction, Seq(io.debug_instr))
  BoringUtils.bore(cpuTop.cpu.doBranch, Seq(io.debug_doBranch))
  BoringUtils.bore(cpuTop.cpu.branchTarget, Seq(io.debug_branchTarget))
  BoringUtils.bore(cpuTop.cpu.stall, Seq(io.debug_stall))
  BoringUtils.bore(cpuTop.cpu.csr.io.writeEnable, Seq(io.debug_csrWrite))
  BoringUtils.bore(cpuTop.cpu.decExReg.csrVal, Seq(io.debug_csrResult))
  cpuTop.io.rx := io.rx
  io.tx := cpuTop.io.tx
}