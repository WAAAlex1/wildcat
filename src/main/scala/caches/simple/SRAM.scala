package caches.simple

import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFile

/**
 * This file is part caches for wildcat
 *
 * This is a simple implementation meant to mimic SRAM modules
 *
 * Author: Gustav Junker
 *
 */

class SRAM(words: Int, BW: Int) extends Module {
  val io = IO(new Bundle {
    val rw = Input(Bool())
    val ad = Input(UInt(log2Down(words).W))
    val DI = Input(UInt(BW.W))
    val EN = Input(Bool())
    val DO = Output(UInt(BW.W))

  })

  val mem = SyncReadMem(words, UInt(BW.W), SyncReadMem.WriteFirst)
  val readValue = mem.read(io.ad)

  // Default
  //io.DO := 0.U
  io.DO := readValue

  when(io.EN){
    when(!io.rw){
      mem.write(io.ad,io.DI)
    }
  }

}


