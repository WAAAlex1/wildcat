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

class MemoryControllerTopPhysical(prescale: UInt)(implicit val config:TilelinkConfig) extends Module {
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
    val dir = Output(Bool())
    val inSio = Input(UInt(4.W))
    val outSio = Output(UInt(4.W))
    val spiClk = Output(Bool())


  })
  val MemCtrl = Module(new MemoryController())


  MemCtrl.io.dCacheReqOut <> io.dCacheReqOut
  io.dCacheRspIn <> MemCtrl.io.dCacheRspIn
  MemCtrl.io.iCacheReqOut <> io.iCacheReqOut
  io.iCacheRspIn <> MemCtrl.io.iCacheRspIn

  val SpiCtrl = Module(new SpiControllerTop(prescale))
  SpiCtrl.io.SPIctrl <> MemCtrl.io.SPIctrl
  SpiCtrl.io.moduleSel := MemCtrl.io.moduleSel
  MemCtrl.io.SpiCtrlValid := SpiCtrl.io.valid
  when(SpiCtrl.io.startup){
    SpiCtrl.io.moduleSel := Seq(false.B, true.B, true.B)
  }

  io.CS0 := SpiCtrl.io.CS0
  io.CS1 := SpiCtrl.io.CS1
  io.CS2 := SpiCtrl.io.CS2
  io.spiClk := SpiCtrl.io.spiClk
  io.dir := SpiCtrl.io.dir
  io.inSio := SpiCtrl.io.inSio
  io.outSio := SpiCtrl.io.outSio




}
