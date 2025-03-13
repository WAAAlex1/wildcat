import chisel3._
import chisel3.util._

class CacheTop extends Module {
  val io = IO(new Bundle {
    val cacheReady = Input(Bool())
    val valid = Output(Bool())
    val rw = Output(Bool())
    val memAdd = Output(UInt(32.W))
    val DI = Input(UInt(32.W))
    val DO = Output(UInt(32.W))
  })
  /*
  val controller = Module(new CacheController)


  io.cacheReady := controller.io.ready
  io.DI := controller.io.DO
  controller.io.memAdd := io.memAdd
  controller.io.validReq := io.valid
  controller.io.DI := io.DO
  controller.io.rw := io.rw
  */
}

