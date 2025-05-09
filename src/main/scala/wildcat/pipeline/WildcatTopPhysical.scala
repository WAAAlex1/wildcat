package wildcat.pipeline

import Bootloader._
import Caches.BusInterconnect
import caravan.bus.tilelink.TilelinkConfig
import chisel3._
import wildcat.Util
import wildcat.CSR._
import chisel.lib.uart._

/*
 * This file is part of the RISC-V processor Wildcat.
 *
 * This is the top-level for a three stage pipeline.
 *
 * Author: Martin Schoeberl (martin@jopdesign.com)
 *
 * Edited by Georg and Alexander to test our Bootloader
 *
 */
class WildcatTopPhysical(freqHz: Int = 100000000) extends Module {

  val io = IO(new Bundle {
    val led = Output(UInt(16.W))
    val tx = Output(UInt(1.W))
    val rx = Input(UInt(1.W))

    // To/Form SPI modules
    val CS0 = Output(Bool())
    val CS1 = Output(Bool())
    val CS2 = Output(Bool())
    val spiCLK = Output(Bool())
    val dir = Output(Bool())
    val inSio = Input(UInt(4.W))
    val outSio = Output(UInt(4.W))
    val spiClk = Output(Bool())
  })

  // ********************************************************************

  // Here switch between different designs
  val cpu = Module(new ThreeCats(freqHz))

  // ********************************************************************

  // Cache, bus and memory controller connections
  implicit val config = new TilelinkConfig
  val bus = Module(new BusInterconnect()) // Includes caches
  val MCU = Module(new MemoryControllerTopPhysical(1.U))

  MCU.io.dCacheReqOut <> bus.io.dCacheReqOut
  bus.io.dCacheRspIn <> MCU.io.dCacheRspIn
  MCU.io.iCacheReqOut <> bus.io.iCacheReqOut
  bus.io.iCacheRspIn <> MCU.io.iCacheRspIn

  // Connect output
  io.CS0 := MCU.io.CS0
  io.CS1 := MCU.io.CS1
  io.CS2 := MCU.io.CS2
  io.spiClk := MCU.io.spiClk
  io.dir := MCU.io.dir
  io.inSio := MCU.io.inSio
  io.outSio := MCU.io.outSio

  //DMEM Connections
  cpu.io.dmem <> bus.io.CPUdCacheMemIO

  //IMEM Connections
  cpu.io.imem.data := bus.io.CPUiCacheMemIO.rdData
  cpu.io.imem.stall := bus.io.CPUiCacheMemIO.stall

  // Default drive of instruction cache
  bus.io.CPUiCacheMemIO.rdEnable := true.B
  bus.io.CPUiCacheMemIO.rdAddress := cpu.io.imem.address
  bus.io.CPUiCacheMemIO.wrData := 0.U
  bus.io.CPUiCacheMemIO.wrEnable := Seq.fill(4)(false.B)
  bus.io.CPUiCacheMemIO.wrAddress := 0.U

  // ********************************************************************

  // Here IO stuff
  // IO is mapped in the space 0xf000_0000 - 0xffff_ffff

  // Default values for memory accesses
  val uartStatusReg = RegNext(rx.io.channel.valid ## tx.io.channel.ready) // Mapped to 0xf000_0000, bit 0 TX ready (TDE), bit 1 RX data available (RDF)
  val bootloaderStatusReg = RegInit(0.U(8.W)) // Mapped to 0xf100_0000, 0x00 = Active, 0x01 = sleep
  val memAddressReg = RegNext(cpu.io.dmem.rdAddress)
  val writeAddressReg = RegNext(cpu.io.dmem.wrAddress)

  // ********************************************************************

  // Instantiate UART
  val tx = Module(new BufferedTx(100000000, 115200))
  val rx = Module(new Rx(100000000, 115200))
  io.tx := tx.io.txd
  rx.io.rxd := io.rx

  tx.io.channel.bits := cpu.io.dmem.wrData(7, 0)
  tx.io.channel.valid := false.B
  rx.io.channel.ready := false.B

  // ********************************************************************

  // Instantiate CLINT module
  val clint = Module(new CLINT())
  val isClintAccess = RegNext((memAddressReg >= MemoryMap.CLINT_BASE.U) &&
    (memAddressReg < (MemoryMap.CLINT_BASE + 0xC000).U))
  val isClintWrite = RegNext(cpu.io.dmem.wrEnable.asUInt.orR &&
    (writeAddressReg >= MemoryMap.CLINT_BASE.U) &&
    (writeAddressReg < (MemoryMap.CLINT_BASE + 0xC000).U))
  val clintWriteDataReg = RegNext(cpu.io.dmem.wrData)

  // Connect CLINT to CLINTLink interface
  clint.io.link.enable := isClintAccess
  clint.io.link.isWrite := isClintWrite
  clint.io.link.address := Mux(isClintWrite, writeAddressReg, memAddressReg)
  clint.io.link.wrData := clintWriteDataReg

  clint.io.currentTimeIn := cpu.io.timerCounter_out
  cpu.io.mtimecmpVal_in := clint.io.mtimecmpValueOut

  // ********************************************************************

  // Instantiate Bootloader
  val BL = Module(new Bootloader())
  val BL_Stall = ~bootloaderStatusReg(0).asBool // 0 = bootloader is active -> BL_stall = true
  //Connect bootloader
  BL.io.rx := io.rx
  BL.io.sleep := BL_Stall
  cpu.io.Bootloader_Stall := BL_Stall

  // ********************************************************************

  // MEMORYMAPPED OPERATIONS

  // Memory read with memorymapping (CLINT, UART, Bootloader)
  when(memAddressReg(31, 28) === 0xf.U) {
    when(isClintAccess) {
      // Access to CLINT
      cpu.io.dmem.rdData := clint.io.link.rdData
    }.elsewhen(memAddressReg === "hF000_0000".U) {    // UART status reg
      cpu.io.dmem.rdData := uartStatusReg
    }.elsewhen(memAddressReg === "hF000_0004".U) {    // UART Send and receive reg
      cpu.io.dmem.rdData := rx.io.channel.bits
      rx.io.channel.ready := cpu.io.dmem.rdEnable
    }.elsewhen(memAddressReg === "hF010_0000".U) {    // LED Data reg
      cpu.io.dmem.rdData := ledReg
    }.elsewhen(memAddressReg === "hF100_0000".U) {    // Bootloader status reg
      cpu.io.dmem.rdData := bootloaderStatusReg
    }.otherwise {
      cpu.io.dmem.rdData := 0.U
    }
  }

  // Memory write with memorymapping (CLINT, UART, LED)
  val ledReg = RegInit(0.U(8.W))
  when ((cpu.io.dmem.wrAddress(31, 28) === 0xf.U) && cpu.io.dmem.wrEnable(0)) {
    when (isClintWrite) { // Write to CLINT handled by CLINT module
      // do nothing
    } .elsewhen (cpu.io.dmem.wrAddress === "hF000_0004".U) {  // UART send and receive reg
      tx.io.channel.valid := true.B
    } .elsewhen (cpu.io.dmem.wrAddress === "hF010_0000".U) {  // LED Reg
      ledReg := cpu.io.dmem.wrData(7, 0)
    }.elsewhen(cpu.io.dmem.wrAddress   === "hF100_0000".U) {  // Bootloader status reg
      bootloaderStatusReg := cpu.io.dmem.wrData(7, 0)
    }.otherwise {
      // Any other IO or memory region, do nothing for write
    }
    //dmem.io.wrEnable := VecInit(Seq.fill(4)(false.B)) // dont actually write to mem if memorymapped
    bus.io.CPUdCacheMemIO.wrEnable := VecInit(Seq.fill(4)(false.B)) // dont actually write to mem if memorymapped
  }

  io.led := 1.U ## 0.U(7.W) ## RegNext(ledReg)

  // ********************************************************************

  // BOOTLOADER TAKES CONTROL WHEN ACTIVE
  when(BL_Stall === true.B){

    // when bootloader is in control
    // Data from bootloader is sent to the DMEM
    // Will go through the DMEM cache to shared RAM.
    // imem cache will be turned off in the meantime to avoid interference.

    cpu.io.dmem.wrAddress := BL.io.instrAddr
    cpu.io.dmem.wrData    := BL.io.instrData
    cpu.io.dmem.wrEnable  := BL.io.wrEnabled
    cpu.io.dmem.rdEnable  := false.B

    bus.io.CPUiCacheMemIO.rdEnable := false.B
  }

  // ********************************************************************

}

object WildcatTopPhysical extends App {
  emitVerilog(new WildcatTopPhysical(), Array("--target-dir", "generated"))
}