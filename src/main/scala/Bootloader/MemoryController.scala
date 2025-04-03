package Bootloader

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum


/**
 * First draft of memory controller module for the Wildcat.
 *
 * Address space:
 * [0xf000_0000] is the IO space for the Wildcat
 * [23,0] is the real address space of the memory
 * [23] is the toggling bit between instr and data mem. So far they are equal in size but it can change.
 * [27,24] are so far unused control signal bits we might need later
 * [0x1000_0000 etc.] is also unused so far.
 * By Georg Brink Dyvad, @GeorgBD
 */

class MemoryController extends Module {
  val io = IO(new Bundle {
    val memIO = IO(Flipped(new TestMemIO()))
    val stall = Output(Bool())
    val bootloading = Input(Bool())
  })

  val memory = Module(new TestMem(4096))
  io.memIO <> memory.io

  //Address mapping
  when(io.memIO.rdAddress(31,28) === "hf".U){
    //Do nothing cause memory mapped IO defined in Wildcattop?
  }.elsewhen(io.memIO.rdAddress(23) === 1.U){
    //DataMem.read addresser (23,0)
  }.elsewhen(true.B){
    //instrMem.read addresser (23,0)
  }

  //I assume stalling will also be enabled by the caches and slower mem so the OR is for that.
  io.stall := io.bootloading || false.B
}
