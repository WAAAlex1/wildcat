package Bootloader

import extmemory._
import spi.SpiControllerTop
import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3.experimental._
import chisel3._
import chisel3.util.Decoupled

/**
 * Top level of memory controller + SPI controller module for the Wildcat. Meant for simulation
 *

 * By Gustav Philip Junker
 */

class MemoryControllerTopSimulator(prescale: UInt, code: Array[Int])(implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    // To/From caches via bus
    val dCacheReqOut = Flipped(Decoupled(new TLRequest))
    val dCacheRspIn = Decoupled(new TLResponse)

    val iCacheReqOut = Flipped(Decoupled(new TLRequest))
    val iCacheRspIn = Decoupled(new TLResponse)

    // To/From SPI modules
    val CS0 = Output(Bool())
    val CS1 = Output(Bool())
    val CS2 = Output(Bool())


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

  val CNT_MAX = (1.U << prescale)
  val cntClk = RegInit(0.U(33.W))
  val spiClkReg = RegInit(false.B)

  when (prescale =/= 1.U) {
    cntClk := cntClk + 1.U

    when (cntClk === CNT_MAX) {
      cntClk := 0.U
      spiClkReg := ~spiClkReg  // toggle the SPI clock
    }
  } .otherwise {
    spiClkReg := !spiClkReg  // direct pass-through (always high)
  }

  val SimClk = Mux(SpiCtrl.io.startup, spiClkReg, !spiClkReg)

  // For simulation
  withClock(SimClk.asClock){
    val RAM0 = Module(new PSRAM_InstrModel(4096, code))
    val RAM1 = Module(new PSRAM_Model(4096))

    RAM0.io.CS := SpiCtrl.io.CS1
    RAM0.io.IN := SpiCtrl.io.outSio
    RAM1.io.IN := SpiCtrl.io.outSio
    RAM1.io.CS := SpiCtrl.io.CS2
    SpiCtrl.io.inSio := 0.U
    when(!SpiCtrl.io.CS1) {
      SpiCtrl.io.inSio := RAM0.io.OUT
    }.elsewhen(!SpiCtrl.io.CS2) {
      SpiCtrl.io.inSio := RAM1.io.OUT
    }
  }




}
