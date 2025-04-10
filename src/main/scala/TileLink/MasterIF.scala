package TileLink

import chisel3.util._
import chisel3._


// Master Interface to use in agents
class MasterIF(id: Int)(implicit val conf: TLConfig) extends Module{
  val io = IO(new Bundle {
    val req_i = Input(Bool())             // Request
    val gnt_o = Output(Bool())            // grant
    val addr_i = Input(UInt(conf.AW.W))
    val we_i = Input(Bool())              // write enable
    val wrData_i = Input(UInt(conf.DW.W))
    val be_i = Input(UInt(conf.DBW.W))   // byte enable
    val valid_o = Output(Bool())
    val rdData_o = Output(UInt(conf.DW.W))
    val err_o = Output(Bool())

    // TL-UH Interface
    val chA_o = new MasterPorts()
    val chD_i = Flipped(new SlavePorts())
  })

  when(reset.asBool) {
    io.chA_o.a_valid := false.B // During RESET a_valid from master must be low
  }

  val wordSize = log2Ceil(conf.DBW)
  val tl_source = Wire(UInt(conf.ASW.W))
  val tl_be = Wire(UInt(conf.DBW.W))

  tl_source := id.asUInt(conf.ASW.W)
  tl_be := Mux(io.we_i, io.be_i, Fill(conf.DBW, 1.U)) //  assign byte enable wire depending on write enable

  // Connect master IO to TileLink interface
  io.chA_o.a_valid := io.req_i
  io.chA_o.a_opcode := Mux(io.we_i, Mux(io.be_i.andR, ChA_Opcode.PutFullData, ChA_Opcode.PutPartialData), ChA_Opcode.Get) // .andR is AND reduction that return true if all bits are set.
  io.chA_o.a_param := 0.U
  io.chA_o.a_size := wordSize.asUInt(conf.SZW.W)
  io.chA_o.a_mask := tl_be
  io.chA_o.a_source := tl_source
  io.chA_o.a_address := io.addr_i
  io.chA_o.a_data := io.wrData_i
  io.chA_o.d_ready := true.B

  io.gnt_o := io.chD_i.a_ready
  io.valid_o := io.chD_i.d_valid
  io.rdData_o := io.chD_i.d_data
  io.err_o := io.chD_i.d_error




}
