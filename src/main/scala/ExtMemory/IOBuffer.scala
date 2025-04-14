package ExtMemory

import chisel3._
import chisel3.experimental._


class IOBuffer extends Module {
  val io = IO(new Bundle {
    val data = Analog(1.W)
    val dir  = Input(Bool()) // 1 = Output, 0 = Input
    val out  = Output(UInt(1.W))
    val in   = Input(UInt(1.W))
  })

  val internalAnalog = Wire(Analog(1.W)) // Internal bidirectional signal

  attach(io.data, internalAnalog)


  val inWire = Wire(UInt(1.W))
  inWire <> internalAnalog


  val outReg = RegNext(io.in) // Register output for stable timing

  when(io.dir) {
    internalAnalog := outReg // Drive output onto the Analog line
    io.out := 0.U
  }

  io.out := inWire.asUInt // Output the read value

}