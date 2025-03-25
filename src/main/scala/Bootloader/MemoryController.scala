package Bootloader

import chisel3._
import chisel.lib.uart._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import wildcat.pipeline.MemIO

/**
 * First draft of memory controller module for the Wildcat.
 *
 * We will first write the input interface.
 *
 * By Georg Brink Dyvad, @GeorgBD
 */

class MemoryController extends Module {
  val io = IO(Flipped(new MemIO()))



}
