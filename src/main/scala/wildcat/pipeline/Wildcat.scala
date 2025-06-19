package wildcat.pipeline

import chisel3._
import uart._

/*
 * This file is part of the RISC-V processor Wildcat.
 *
 * This is the common top-level for different implementations.
 * Interface is to instruction memory and data memory.
 * All SPMs, caches, and IOs shall be in a SoC top level
 *
 * Author: Martin Schoeberl (martin@jopdesign.com)
 *
 */
abstract class Wildcat(freqHz: Int = 100000000) extends Module {
  val io = IO(new Bundle {
    val imem = new InstrIO()
    val dmem = new MemIO()

    val mtimecmpVal_in = Input(UInt(64.W))
    val timerCounter_out = Output(UInt(64.W))
    val Bootloader_Stall = Input(Bool())


    //UART
    val UARTport = Bus.RequestPort() // bus port

  })
}