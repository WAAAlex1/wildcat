package ExtMemory

import chisel3._
import chisel3.experimental._

class IOBufferBlackBox extends ExtModule {
  val io = IO(new Bundle {
    val io  = Analog(1.W)  // Bidirectional QSPI pin
    val dir = Input(Bool()) // 1 = Output, 0 = Input
    val out = Input(UInt(1.W)) // Data to drive when output
    val in  = Output(UInt(1.W)) // Data read when input
  })
}
