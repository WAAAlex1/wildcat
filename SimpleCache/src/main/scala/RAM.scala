import chisel3._
import chisel3.util._

class RAM(words: Int, BW: Int) extends Module {
  val io = IO(new Bundle {
    val rw = Input(Bool())
    val ad = Input(UInt(log2Down(words).W))
    val DI = Input(UInt(BW.W))
    val EN = Input(Bool())
    val DO = Output(UInt(BW.W))
  })

  val mem = SyncReadMem(words, UInt(BW.W))

  when(io.rw && io.EN){
    io.DO := mem.read(io.ad)
  }.elsewhen(!io.rw && io.EN){
    mem.write(io.ad,io.DI)
    io.DO := 0.U
  }.otherwise{
    io.DO := 0.U
  }


}


