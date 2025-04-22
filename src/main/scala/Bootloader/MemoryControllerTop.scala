package Bootloader

import ExtMemory.IOBUFFER
import SPI.SPITop
import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3.experimental._
import chisel3._
import chisel3.util.Decoupled

/**
 * First draft of a top level of memory controller  + SPI controller module for the Wildcat
 *

 * By Gustav Philip Junker
 */

class MemoryControllerTop(implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    // To/From caches via bus
    val dCacheReqOut = Flipped(Decoupled(new TLRequest))
    val dCacheRspIn = Decoupled(new TLResponse)

    val iCacheReqOut = Flipped(Decoupled(new TLRequest))
    val iCacheRspIn = Decoupled(new TLResponse)

    // To/Form SPI modules
    val CS0 = Output(Bool())
    val CS1 = Output(Bool())
    val CS2 = Output(Bool())
    val IO0 = Analog(1.W)
    val IO1 = Analog(1.W)
    val IO2 = Analog(1.W)
    val IO3 = Analog(1.W)
  })
  val MemCtrl = Module(new MemoryController())
  // dummy code
  MemCtrl.io.bootloading := false.B
  MemCtrl.io.memIO.wrData := DontCare
  MemCtrl.io.memIO.wrEnable := DontCare
  MemCtrl.io.memIO.rdEnable := DontCare
  MemCtrl.io.memIO.rdAddress := DontCare
  MemCtrl.io.memIO.wrAddress := DontCare


  MemCtrl.io.dCacheReqOut <> io.dCacheReqOut
  io.dCacheRspIn <> MemCtrl.io.dCacheRspIn
  MemCtrl.io.iCacheReqOut <> io.iCacheReqOut
  io.iCacheRspIn <> MemCtrl.io.iCacheRspIn

  val SpiCtrl = Module(new SPITop)

  SpiCtrl.io.memSPIctrl(0) <> MemCtrl.io.SPIctrl(0)
  SpiCtrl.io.memSPIctrl(1) <> MemCtrl.io.SPIctrl(1)

  val SPIbuffer0 = Module(new IOBUFFER)
  val SPIbuffer1 = Module(new IOBUFFER)
  val SPIbuffer2 = Module(new IOBUFFER)
  val SPIbuffer3 = Module(new IOBUFFER)

  SPIbuffer0.io.dir := SpiCtrl.io.dir
  SPIbuffer1.io.dir := SpiCtrl.io.dir
  SPIbuffer2.io.dir := SpiCtrl.io.dir
  SPIbuffer3.io.dir := SpiCtrl.io.dir

  SPIbuffer0.io.out := SpiCtrl.io.si(0)
  SPIbuffer1.io.out := SpiCtrl.io.si(1)
  SPIbuffer2.io.out := SpiCtrl.io.si(2)
  SPIbuffer3.io.out := SpiCtrl.io.si(3)
  SpiCtrl.io.so(0) := SPIbuffer0.io.in
  SpiCtrl.io.so(1) := SPIbuffer1.io.in
  SpiCtrl.io.so(2) := SPIbuffer2.io.in
  SpiCtrl.io.so(3) := SPIbuffer3.io.in

  attach(io.IO0,SPIbuffer0.io.io)
  attach(io.IO1,SPIbuffer1.io.io)
  attach(io.IO2,SPIbuffer2.io.io)
  attach(io.IO3,SPIbuffer3.io.io)
  io.CS0 := SpiCtrl.io.CS0out
  io.CS1 := SpiCtrl.io.CS1out
  io.CS2 := true.B // Attach flash ctrl here
}
