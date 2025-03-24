package Caches.SimpleCache

import chisel3._
import chisel3.util._
import wildcat.pipeline._
import Caches.SimpleCache.CacheFunctions._

/**
 * This file is part of caches for wildcat
 *
 * This is the top-level for the simple cache
 *
 * Author: Gustav Junker
 *
 */

class CacheTop extends Module {
  val io = IO(Flipped(new MemIO()))


  val Controller = Module(new CacheController)

  Controller.io.memReady := true.B // dummy code

  Controller.io.validReq := false.B
  Controller.io.rw := true.B
  Controller.io.memAdd := io.rdAddress
  Controller.io.wrEnable := io.wrEnable
  Controller.io.DI := io.wrData
  io.rdData := Controller.io.DO
  io.stall := false.B


  // Stall  processor on miss
  when(Controller.io.cacheMiss){
    io.stall := true.B
  }

  // Convert Vec[Bool] to UInt
  val weBits = io.wrEnable.asUInt


  when(io.rdEnable){ // lb, lh or lw
    Controller.io.validReq := true.B
    Controller.io.rw := true.B
    Controller.io.memAdd := io.rdAddress
  }

  when(weBits > 0.U){ // sb, sh or sw
    Controller.io.validReq := true.B
    Controller.io.rw := false.B
    Controller.io.memAdd := io.wrAddress
  }


}

object CacheTop extends App {
  println("I will now generate the Verilog file")
  emitVerilog(new CacheTop())
}
