package TileLink

import chisel3._


// Master Interface to use in agents
class MasterIF(implicit val conf: TLConfig) extends Module{
  val io = IO(new Bundle {
    val req_i = Input(Bool())             // Request
    val gnt_o = Output(Bool())            // grant
    val addr_i = Input(UInt(conf.AW.W))
    val we_i = Input(Bool())              // write enable
    val wrdata_i = Input(UInt(conf.DW.W))
    val be_i = Input(UInt(conf.DBW.W))    // byte enable
    val valid_o = Output(Bool())
    val rdata_o = Output(UInt(conf.DW.W))
    val err_o = Output(Bool())

    // TL-UH Interface
    val chA_o = new MasterPorts()
    val chD_i = Flipped(new SlavePorts())
  })

  when(reset.asBool) {
    io.chA_o.a_valid := false.B // During RESET a_valid from master must be low
  }

  val OC = RegInit(ChA_Opcode.Get)

}
