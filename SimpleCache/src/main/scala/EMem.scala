import chisel3._
import chisel3.util._

class EMem(words: Int) extends Module {
  val io = IO(new Bundle {
    val rw = Input(Bool())
    val ad = Input(UInt(log2Up(words).W))
    val DI = Input(UInt(32.W))
    val EN = Input(Bool())
    val DO = Output(UInt(32.W))
  })

  // First try with a vector of registers and a FSM to control
  val lines = RegInit(VecInit(Seq.fill(128)(0.U(32.W)))) // 128 cache lines, initialized to 0

  object State extends ChiselEnum {
    val read, write, idle = Value
  }

  import State._
  // The state register
  val stateReg = RegInit(idle)

  // Next state logic
  switch(stateReg){
    is (idle) {
      when(io.EN && io.rw){
        stateReg := read
      }.elsewhen(io.EN && !io.rw){
        stateReg := write
      }.otherwise{
        stateReg := idle
      }
    }
    is (read){
      when(io.EN && !io.rw){
        stateReg := write
      }.elsewhen(!io.EN){
        stateReg := idle
      }
    }
    is(write){
      when(io.EN && io.rw){
        stateReg := read
      }.elsewhen(!io.EN){
        stateReg := idle
      }
    }
  }

  // Output logic (read/write)
  when(stateReg === read){
    io.DO := lines(io.ad)
  }.otherwise{
    io.DO := 0.U
  }
  when(stateReg === write){
    lines(io.ad) := io.DI
  }


}


