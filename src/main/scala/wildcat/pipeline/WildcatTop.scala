package wildcat.pipeline

import Bootloader._
import chisel3._
import wildcat.Util
import chisel.lib.uart._

/*
 * This file is part of the RISC-V processor Wildcat.
 *
 * This is the top-level for a three stage pipeline.
 *
 * Author: Martin Schoeberl (martin@jopdesign.com)
 *
 * Edited by Georg and Alexander to test our Bootloader
 *
 */
class WildcatTop(file: String, dmemNrByte: Int = 4096) extends Module {

  val io = IO(new Bundle {
    val led = Output(UInt(16.W))
    val tx = Output(UInt(1.W))
    val rx = Input(UInt(1.W))
  })

  //No file loading necessary when using the bootloader. Instead pass empty int array.
  //val (memory, start) = Util.getCode(file)
  val memory = new Array [Int](100)

  // Here switch between different designs
  val cpu = Module(new ThreeCats())
  // val cpu = Module(new WildFour())
  // val cpu = Module(new StandardFive())
  val dmem = Module(new ScratchPadMem(memory, nrBytes = dmemNrByte))
  cpu.io.dmem <> dmem.io
  val imem = Module(new InstructionROM(memory))
  imem.io.address := cpu.io.imem.address
  cpu.io.imem.data := imem.io.data

  //Implement quick stalling:
  val pcStallReg = RegInit(true.B)
  cpu.io.imem.stall := pcStallReg

  //Bootloader module initialization
  //Frequency set to 100MHz
  val bootloader = Module(new Bootloader(100000000))

  // Here IO stuff
  // IO is mapped ot 0xf000_0000
  // use lower bits to select IOs

  // UART:
  // For our uCLinux Kernel we need the wildcat to follow an existing UART driver, the simplest being liteuart.
  // This means we have to alter the mmap addresses of the UART to match that.
  // 0xf000_0000 send and receive register:
  // 0xf000_0004 TX_FULL (Probably equivalent to ~tx.io.channel.ready)
  // 0xf000_0008 RX_EMPTY (Probably equivalent to ~rx.io.channel.valid)
  //This is not yet implemented

  val tx = Module(new BufferedTx(100000000, 115200))
  val rx = Module(new Rx(100000000, 115200))
  io.tx := tx.io.txd
  rx.io.rxd := io.rx

  tx.io.channel.bits := cpu.io.dmem.wrData(7, 0)
  tx.io.channel.valid := false.B
  rx.io.channel.ready := false.B

  val uartStatusReg = RegNext(rx.io.channel.valid ## tx.io.channel.ready)
  val memAddressReg = RegNext(cpu.io.dmem.rdAddress)
  when (memAddressReg(31, 28) === 0xf.U && memAddressReg(19,16) === 0.U) {
    when (memAddressReg(3, 0) === 0.U) {
      cpu.io.dmem.rdData := uartStatusReg
    } .elsewhen(memAddressReg(3, 0) === 4.U) {
      cpu.io.dmem.rdData := rx.io.channel.bits
      rx.io.channel.ready := cpu.io.dmem.rdEnable
    }
  }

  val ledReg = RegInit(0.U(8.W))
  when ((cpu.io.dmem.wrAddress(31, 28) === 0xf.U) && cpu.io.dmem.wrEnable(0)) {
    when (cpu.io.dmem.wrAddress(19,16) === 0.U && cpu.io.dmem.wrAddress(3, 0) === 4.U) {
      printf(" %c %d\n", cpu.io.dmem.wrData(7, 0), cpu.io.dmem.wrData(7, 0))
      tx.io.channel.valid := true.B
    } .elsewhen (cpu.io.dmem.wrAddress(19,16) === 1.U) {
      ledReg := cpu.io.dmem.wrData(7, 0)
    }
    dmem.io.wrEnable := VecInit(Seq.fill(4)(false.B))
  }

  //Bootloader IO
  //Map bootloader sleep bit to 0xf100_0000, write 0x00 to set bootloader active or 0x01 to set it to sleep
  bootloader.io.rx := io.rx //Connect bootloader UART to toplevel UART rx
  val bootSleepReg = RegInit(0.U(8.W))
  when(bootSleepReg === 1.U){
    pcStallReg := false.B
  }.elsewhen(true.B){
    //Cannot implement bootloader on instrROM, because its ROM
    /*
    imem.io.address := bootloader.io.instrAddr
    imem.io.data := bootloader.io.instrData
    imem.io.

     */
  }

  //Memory mapped bootloader toggling
  bootloader.io.sleep := bootSleepReg(0).asBool
  when((cpu.io.dmem.wrAddress(31,28) === 0xf.U) && cpu.io.dmem.wrEnable(0)){
    when(cpu.io.dmem.wrAddress(27,24) === 1.U){
      bootSleepReg := cpu.io.dmem.wrData(7,0)

    }

    dmem.io.wrEnable := VecInit(Seq.fill(4)(false.B))
  }






  io.led := 1.U ## 0.U(7.W) ## RegNext(ledReg)
}

object WildcatTop extends App {
  emitVerilog(new WildcatTop(args(0)), Array("--target-dir", "generated"))
}