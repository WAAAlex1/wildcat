package Bootloader

import spi.SpiControllerTop
import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3.experimental._
import chisel3._
import chisel3.util.Decoupled

/**
 * Top level of memory controller + SPI controller for the Wildcat. Meant for implementation on FPGA
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
  MemCtrl.io.startup := SpiCtrl.io.startup

  io.CS0 := SpiCtrl.io.CS0
  io.CS1 := SpiCtrl.io.CS1
  io.CS2 := SpiCtrl.io.CS2
  io.spiClk := SpiCtrl.io.spiClk
  io.dir := SpiCtrl.io.dir
  SpiCtrl.io.inSio := io.inSio
  io.outSio := SpiCtrl.io.outSio




}
