package TileLink

import chisel3._


// Slave Interface to use in agents
class SlaveIF (implicit val conf: TLConfig) extends Module{
  val io = IO(new Bundle {
    // TL-UH interface
    val chA_i = Flipped(new MasterPorts())
    val chD_o = new SlavePorts()

    // Peripheral interface
    val re_o = Output(Bool())
    val we_o = Output(Bool())
    val addr_o = Output(UInt(conf.AW.W))
    val wdata_o = Output(UInt(conf.DW.W))
    val be_o = Output(UInt(conf.DBW.W))
    val rdata_i = Input(UInt(conf.DW.W))
    val error_i = Input(Bool())
  })

  when(reset.asBool) {
    io.chD_o.d_valid := false.B // During RESET the d_valid from slave must be low
  }

}
