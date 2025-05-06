package Bootloader

import ExtMemory.{IOBUFFER, PSRAM_Model}
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

class MemoryControllerTopSimulator(implicit val config:TilelinkConfig) extends Module {
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

  io.CS0 := SpiCtrl.io.CS0out
  io.CS1 := SpiCtrl.io.CS1out
  io.CS2 := true.B // Attach flash ctrl here

  // For simulation
  val RAM0 = Module(new PSRAM_Model(2048))
  val RAM1 = Module(new PSRAM_Model(2048))

  RAM0.io.CS := SpiCtrl.io.CS0out
  RAM0.io.IN := SpiCtrl.io.si
  RAM1.io.IN := SpiCtrl.io.si
  RAM1.io.CS := SpiCtrl.io.CS1out
  SpiCtrl.io.so := 0.U
  when(!SpiCtrl.io.CS0out) {
    SpiCtrl.io.so := RAM0.io.OUT
  }.elsewhen(!SpiCtrl.io.CS1out) {
    SpiCtrl.io.so := RAM1.io.OUT
  }

}
