package Caches.SimpleCache

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
  val address = WireDefault(0.U)

  when(io.rw && io.EN){
    address := io.ad
    io.DO := mem.read(address)
  }.elsewhen(!io.rw && io.EN){
    mem.write(io.ad,io.DI)
    io.DO := 0.U
  }.otherwise{
    io.DO := 0.U
  }


}


