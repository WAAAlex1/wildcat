package Bootloader

import chisel3._

/**
 * This is a bootloader top module intended for testing the bootloader on an FPGA by itself with a test memory.
 *
 * @param frequ
 * @param baudRate
 */

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
  testMem.io.wrEnable(0) := bootloader.io.wrEnabled
  testMem.io.wrEnable(1) := bootloader.io.wrEnabled
  testMem.io.wrEnable(2) := bootloader.io.wrEnabled
  testMem.io.wrEnable(3) := bootloader.io.wrEnabled
  testMem.io.wrData := bootloader.io.instrData
  testMem.io.rdAddress := 0.U
  testMem.io.rdEnable := false.B

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

  io.led := 1.U ## 0.U(7.W) ## ledReg
}

//We test the bootloader on its own without the wildcat first.
object BootloaderTopTop extends App {
  emitVerilog(new BootloaderTop(100000000), Array("--target-dir", "generated"))
}