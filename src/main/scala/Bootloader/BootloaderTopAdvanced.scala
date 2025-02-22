package Bootloader

import chisel.lib.uart._
import chisel3._
import chisel3.experimental.ChiselEnum
import chisel3.util._

/**
 * Bootloader by Alexander and Georg for the Wildcat
 *
 * Advanced version of the bootloader, which is designed to be more advanced, able to boot uCLinux.
 * Fixes the following problems needed to run uCLinux:
 *  1. ELF files contain a .data segment consisting of constants and so forth. This section should be put in DMEM.
 *  2. ELF files contain a _start location which is where the program should execute from after booting.
 *  3. ELF files 
 */
class BootloaderTopAdvanced(frequ: Int, baudRate: Int = 115200) extends Module {
  val io = IO(new Bundle {
    val instrData = Output(UInt(32.W))
    val wrEnabled = Output(UInt(1.W))
    val rx = Input(UInt(1.W))
  })

  //val tx = Module(new BufferedTx(100000000, baudRate))
  val rx = Module(new Rx(100000000, baudRate))
  val buffer = Module(new BootBuffer())
  //Counter for keeping track of address and when 4 bytes are ready to be sent
  val counter = RegInit(0.U(32.W))


  object State extends ChiselEnum {
    val Idle, Sample, Send = Value
  }
  import State._
  val stateReg = RegInit(Idle)

  val incr = RegInit(0.U(1.W))
  val save = RegInit(0.U(1.W))
  val wrEnabled = RegInit(0.U(1.W))

  when(incr === 1.U){
    counter := counter + 1.U
  }
  val byteCount = counter % 4.U

  buffer.io.saveCtrl := save
  buffer.io.dataIn := rx.io.channel.bits

  rx.io.channel.ready := false.B

  switch(stateReg){
    is(Idle){
      when(rx.io.channel.valid){
        stateReg := Sample
        incr := 1.U
        rx.io.channel.ready := true.B
        save := 1.U
      }
    }
    is(Sample){
      when(byteCount === 3.U) { //temp couner signal
        wrEnabled := 1.U
        stateReg := Send
      } .elsewhen(rx.io.channel.valid && (byteCount =/= 3.U)){
        stateReg := Sample
        rx.io.channel.ready := true.B
      } .elsewhen(true.B) {
        stateReg := Idle
      }
    }
    is(Send){
      when(rx.io.channel.valid) {
        incr := 1.U
        save := 1.U
        stateReg := Sample
        rx.io.channel.ready := true.B
      } .elsewhen(true.B) {
        stateReg := Idle
      }

    }
  }

  io.wrEnabled := wrEnabled
  io.instrData := buffer.io.dataOut
  rx.io.rxd := io.rx
}
