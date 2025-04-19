package SPI

import chisel3._
import Bootloader.SpiCTRLIO


class SPITop extends Module{
  val io = IO(new Bundle{
    val memSPIctrl = Vec(2,new SpiCTRLIO)

    val clk = Output(Bool())
    val si = Output(UInt(4.W))
    val so = Input(UInt(4.W))
    val dir = Output(Bool()) // 1 = Output, 0 = Input (from buffer)
    val CS0out = Output(Bool())
    val CS1out = Output(Bool())
  })

  val SPICTRL0 = Module(new SpiMemController)
  val SPICTRL1 = Module(new SpiMemController)
  SPICTRL0.io.so := io.so
  SPICTRL1.io.so := io.so

  // Dummy default connections, see future update below
  SPICTRL0.io.rst := io.memSPIctrl(0).rst
  SPICTRL0.io.rw := io.memSPIctrl(0).rw
  SPICTRL0.io.en := io.memSPIctrl(0).en
  SPICTRL0.io.addr := io.memSPIctrl(0).addr
  SPICTRL0.io.dataIn := io.memSPIctrl(0).dataIn
  io.memSPIctrl(0).dataOut := SPICTRL0.io.dataOut
  io.memSPIctrl(0).done := SPICTRL0.io.done

  SPICTRL1.io.rst := io.memSPIctrl(1).rst
  SPICTRL1.io.rw := io.memSPIctrl(1).rw
  SPICTRL1.io.en := io.memSPIctrl(1).en
  SPICTRL1.io.addr := io.memSPIctrl(1).addr
  SPICTRL1.io.dataIn := io.memSPIctrl(1).dataIn
  io.memSPIctrl(1).dataOut := SPICTRL1.io.dataOut
  io.memSPIctrl(1).done := SPICTRL1.io.done


  // After updating SpiMemController.scala, should be:
  // SPICTRL(0).io.memSPIctrl <> io.memSPIctrl(0)
  // SPICTRL(1).io.memSPIctrl <> io.memSPIctrl(1)



  when(!SPICTRL0.io.ce){
    io.si := SPICTRL0.io.si
  }.elsewhen(!SPICTRL1.io.ce){
    io.si := SPICTRL1.io.si
  }.otherwise{
    io.si := 0.U
  }

  io.CS0out := SPICTRL0.io.ce
  io.CS1out := SPICTRL1.io.ce
  io.clk := Clock()
}
