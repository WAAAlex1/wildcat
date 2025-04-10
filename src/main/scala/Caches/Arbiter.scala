package Caches

import caravan.bus.tilelink._
import chisel3._
import chisel3.util._

class Arbiter (implicit val config:TilelinkConfig) extends Module{
  val io = IO(new Bundle{
    val ImemReqOut = Flipped(Decoupled(new TLRequest))
    val ImemRspIn = Decoupled(new TLResponse)

    val DmemReqOut = Flipped(Decoupled(new TLRequest))
    val DmemRspIn = Decoupled(new TLResponse)

    val reqOut = Decoupled(new TLRequest)
    val rspIn = Flipped(Decoupled(new TLResponse))
    val source = Output(UInt(1.W))
  })
  // Default Dmem
  io.reqOut <> io.DmemReqOut
  io.DmemRspIn <> io.rspIn
  io.source := 0.U

  io.ImemRspIn.valid := false.B
  io.ImemRspIn.bits.error := false.B
  io.ImemRspIn.bits.dataResponse := 0.U
  io.ImemReqOut.ready := false.B

  when(io.DmemReqOut.valid && io.ImemReqOut.valid){
    io.reqOut <> io.DmemReqOut
    io.DmemRspIn <> io.rspIn
    io.source := 0.U
  }.elsewhen(io.DmemReqOut.valid && !io.ImemReqOut.valid){
    io.reqOut <> io.DmemReqOut
    io.DmemRspIn <> io.rspIn
    io.source := 0.U
  }.elsewhen(!io.DmemReqOut.valid && io.ImemReqOut.valid){
    io.reqOut <> io.ImemReqOut
    io.ImemRspIn <> io.rspIn
    io.source := 1.U
  }.elsewhen(!io.DmemReqOut.valid && !io.ImemReqOut.valid){
    io.reqOut <> io.DmemReqOut
    io.DmemRspIn <> io.rspIn
    io.source := 0.U
  }

}
