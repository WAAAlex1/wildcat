package Bootloader

import ExtMemory.{IOBUFFER, PSRAM_Model}
import SPI.{SPITop, SpiControllerTop}
import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3.experimental._
import chisel3._
import chisel3.util.Decoupled

/**
 * First draft of a top level of memory controller  + SPI controller module for the Wildcat
 *

 * By Gustav Philip Junker
 */

class MemoryControllerTopPhysical(implicit val config:TilelinkConfig) extends Module {
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
    val spiCLK = Output(Bool())

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

  val SpiCtrl = Module(new SpiControllerTop)
  io.spiCLK := SpiCtrl.io.spiClk
  SpiCtrl.io.memSPIctrl <> MemCtrl.io.SPIctrl


  io.CS0 := SpiCtrl.io.CS0
  io.CS1 := SpiCtrl.io.CS1
  io.CS2 := SpiCtrl.io.CS2





}
