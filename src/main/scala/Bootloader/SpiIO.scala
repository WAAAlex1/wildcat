package Bootloader

import chisel3._

class SpiCTRLIO extends Bundle{
  val rst = Input(Bool())
  val rw = Input(Bool())
  val en = Input(Bool())
  val addr = Input(UInt(24.W))
  val dataIn = Input(UInt(32.W))
  val dataOut = Output(UInt(32.W))
  val done = Output(Bool())
  val size = Input(UInt(3.W))

}
