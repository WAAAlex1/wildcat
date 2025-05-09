package wildcat.explore

import chisel.lib.uart._
import chisel3._


/*
 * This file is part of the RISC-V processor Wildcat.
 *
 * This is the top-level for a UART test.
 *
 * Author: Martin Schoeberl (martin@jopdesign.com)
 *
 */
class UartTop(freqHz: Int = 100000000) extends Module {

  val io = IO(new Bundle {
    val led = Output(UInt(16.W))
    val tx = Output(UInt(1.W))
    val rx = Input(UInt(1.W))
  })


  val tx = Module(new BufferedTx(freqHz, 115200))
  val rx = Module(new Rx(freqHz, 115200))
  io.tx := tx.io.txd
  rx.io.rxd := io.rx
  tx.io.channel <> rx.io.channel

  rx.io.channel.ready := false.B // base case

  val ledReg = RegInit(0.U(8.W))
  when (rx.io.channel.valid) {
    ledReg := rx.io.channel.bits
    rx.io.channel.ready := true.B
  }

  io.led := 1.U ## 0.U(7.W) ## RegNext(ledReg)
}

object UartTop extends App {
  emitVerilog(new UartTop(), Array("--target-dir", "generated"))
}