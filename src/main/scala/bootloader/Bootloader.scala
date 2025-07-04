package bootloader

import chisel3._
import chisel.lib.uart._
import chisel3.util._
import chisel3.experimental.ChiselEnum

/**
 * Bootloader by Alexander and Georg for the Wildcat
 * To use this new module you should first send the address through UART and then immedietly after the instr
 *
 * receive address, then receive data, then send data to address
 *
 * New design : Use a memory-mapped IO signal to deactivate/activate the bootloader
 *
 */
class Bootloader(frequ: Int = 100000000, baudRate: Int = 115200) extends Module {
  val io = IO(new Bundle {
    val instrData = Output(UInt(32.W))
    val instrAddr = Output(UInt(32.W))
    val wrEnabled = Output(UInt(1.W))
    val rx = Input(UInt(1.W))
    val sleep = Input(Bool())
  })

  val rx = Module(new Rx(frequ, baudRate))
  val buffer = Module(new BootBuffer())

  object State extends ChiselEnum {
    val Active, Sleep = Value
  }
  import State._
  val stateReg = RegInit(Active)

  val incr = RegInit(0.U(1.W))
  val save = RegInit(0.U(1.W))
  val wrEnabled = RegInit(0.U(1.W))
  val byteCount = RegInit(0.U(4.W))

  when(incr === 1.U){
    byteCount := byteCount + 1.U
  }

  //Buffer connections
  buffer.io.saveCtrl := save
  buffer.io.dataIn := rx.io.channel.bits

  //Default signals
  rx.io.channel.ready := false.B
  incr := 0.U
  save := 0.U
  wrEnabled := 0.U

  //FSM
  switch(stateReg){
    is(Sleep){
      when(!io.sleep){
        stateReg := Active
      } .elsewhen(true.B){
        stateReg := Sleep
      }
    }
    is(Active) {
     when(io.sleep) {
       stateReg := Sleep
     }.elsewhen(byteCount === 8.U) {
       wrEnabled := 1.U
       byteCount := 0.U
       stateReg := Active
     } .elsewhen(rx.io.channel.valid) {
       incr := 1.U
       rx.io.channel.ready := true.B
       save := 1.U
       stateReg := Active
     } .elsewhen(true.B) {
       stateReg := Active
     }
    }
  }

  //IO connections
  io.wrEnabled := wrEnabled
  io.instrData := buffer.io.dataOut(63,32)
  io.instrAddr := buffer.io.dataOut(31,0)
  rx.io.rxd := io.rx
}



