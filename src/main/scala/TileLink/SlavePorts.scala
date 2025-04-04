package TileLink

import chisel3._

// Slave ports mainly containing the D Channel
class SlavePorts(implicit val conf: TLConfig) extends Bundle {
  val d_valid = Output(Bool())
  val d_opcode = Output(UInt(3.W))
  val d_param = Output(UInt(3.W))
  val d_size = Output(UInt(conf.SZW.W))
  val d_source = Output(UInt(conf.ASW.W))
  val d_sink = Output(UInt(conf.DSW.W))
  val d_data = Output(UInt(conf.DW.W))
  val d_error = Output(Bool())
  val a_ready = Output(Bool())
}
