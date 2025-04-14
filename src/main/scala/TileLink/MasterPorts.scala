package TileLink

import chisel3._

// Master Ports mainly containing the A Channel
class MasterPorts (implicit val conf: TLConfig) extends Bundle{
  val a_valid = Output(Bool())
  val a_opcode = Output(UInt(3.W))
  val a_param = Output(UInt(3.W))
  val a_size = Output(UInt(conf.SZW.W))
  val a_source = Output(UInt(conf.ASW.W))
  val a_address = Output(UInt(conf.AW.W))
  val a_mask = Output(UInt(conf.DBW.W))
  val a_data = Output(UInt(conf.DW.W))
  val d_ready = Output(Bool())
}
