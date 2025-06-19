package bootloader

import chisel3._
import chisel3.util._

/**
 * Simplified memory originated from the Wildcat datamemory module.
 * Created for testing the bootloader module.
 */

class TestMemIO extends Bundle {
  val rdAddress = Output(UInt(32.W))
  val rdData = Input(UInt(32.W))
  val rdEnable = Output(Bool())
  val wrAddress = Output(UInt(32.W))
  val wrData = Output(UInt(32.W))
  val wrEnable = Output(Vec (4, Bool()))
}

class TestMem(nrBytes: Int = 4096) extends Module {
  val io = IO(Flipped(new TestMemIO()))

  val mems = Array(
    SyncReadMem(nrBytes/4, UInt(8.W), SyncReadMem.WriteFirst),
    SyncReadMem(nrBytes/4, UInt(8.W), SyncReadMem.WriteFirst),
    SyncReadMem(nrBytes/4, UInt(8.W), SyncReadMem.WriteFirst),
    SyncReadMem(nrBytes/4, UInt(8.W), SyncReadMem.WriteFirst))


  val idx = log2Up(nrBytes/4)
  io.rdData := mems(3).read(io.rdAddress(idx+2, 2)) ## mems(2).read(io.rdAddress(idx+2, 2)) ## mems(1).read(io.rdAddress(idx+2, 2)) ## mems(0).read(io.rdAddress(idx+2, 2))
  when(io.wrEnable(0)) {
    mems(0).write(io.wrAddress(idx+2, 2), io.wrData(7, 0))
  }
  when(io.wrEnable(1)) {
    mems(1).write(io.wrAddress(idx+2, 2), io.wrData(15, 8))
  }
  when(io.wrEnable(2)) {
    mems(2).write(io.wrAddress(idx+2, 2), io.wrData(23, 16))
  }
  when(io.wrEnable(3)) {
    mems(3).write(io.wrAddress(idx+2, 2), io.wrData(31, 24))
  }
}
