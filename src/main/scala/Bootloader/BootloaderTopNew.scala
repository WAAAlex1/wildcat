package Bootloader

import chisel3._
import chisel.lib.uart._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import wildcat.Util
import wildcat.pipeline.ScratchPadMem

class BootloaderTop(frequ: Int, baudRate: Int = 115200) extends Module {
  val io = IO(new Bundle {
    val rx = Input(UInt(1.W))
    val led = Output(UInt(16.W))
    val bootSleeping = Output(Bool())
  })

  val testMem = Module(new TestMem())
  val bootloader = Module(new Bootloader(frequ))

  bootloader.io.rx := io.rx
  testMem.io.wrAddress := bootloader.io.instrAddr
  testMem.io.wrEnable := VecInit(Seq.fill(4)(bootloader.io.wrEnabled))
  testMem.io.wrData := bootloader.io.instrData
  testMem.io.rdAddress := 0.U
  testMem.io.rdEnable := false.B

  val bootAddrReg = RegInit(0.U(16.W))
  when(bootloader.io.wrEnabled === 1.U){
    bootAddrReg := bootloader.io.instrAddr(31,16)
  }

  //Bootloader IO
  //Map bootloader sleep bit to 0xf100_0000, write 0x00 to set bootloader active or 0x01 to set it to sleep
  val bootSleepReg = RegInit(0.U(8.W))
  //Pseudo memory mapping
  bootloader.io.sleep := bootSleepReg(0).asBool
  io.bootSleeping := bootSleepReg(0).asBool
  when((testMem.io.wrAddress(31, 28) === 0xf.U) && testMem.io.wrEnable(0)) {
    when(testMem.io.wrAddress(27, 24) === 1.U) {
      bootSleepReg := testMem.io.wrData(7, 0)

    }

  }

  //Scuffed memory mapped LED
  val ledReg = RegInit(0.U(8.W))
  when((testMem.io.wrAddress(31, 28) === 0xf.U) && testMem.io.wrEnable(0)) {
    when(testMem.io.wrAddress(19, 16) === 1.U) {
      ledReg := testMem.io.wrData(7, 0)
    }
  }

  io.led := bootAddrReg


}

//We test the bootloader on its own without the wildcat first.
object BootloaderTopTop extends App {
  emitVerilog(new BootloaderTop(100000000), Array("--target-dir", "generated"))
}