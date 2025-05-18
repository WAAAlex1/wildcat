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
class WildcatTop(file: String, dmemNrByte: Int = 4096, freqHz: Int = 100000000) extends Module {

  val io = IO(new Bundle {
    val led = Output(UInt(16.W))
    val tx = Output(UInt(1.W))
    val rx = Input(UInt(1.W))
  })

  val (memory, start) = Util.getCode(file)

  // Here switch between different designs
  val cpu = Module(new ThreeCats(freqHz))
  cpu.io.Bootloader_Stall := false.B
  // val cpu = Module(new WildFour())
  // val cpu = Module(new StandardFive())

  //val dmem = Module(new ScratchPadMem(memory, nrBytes = dmemNrByte))
  //cpu.io.dmem <> dmem.io



  /*
  val imem = Module(new InstructionROM(memory))
  imem.io.address := cpu.io.imem.address
  cpu.io.imem.data := imem.io.data
  cpu.io.imem.stall := imem.io.stall
  */



  // Cache, bus and memory controller connections
  implicit val config = new TilelinkConfig
  val bus = Module(new BusInterconnect()) // Includes caches

  //bus.io.CPUiCacheMemIO := DontCare
  //bus.io.CPUdCacheMemIO := DontCare

  // Choose between simulated main memory or physical
  val MCU = Module(new MemoryControllerTopSimulator(1.U,memory))

  MCU.io.dCacheReqOut <> bus.io.dCacheReqOut
  bus.io.dCacheRspIn <> MCU.io.dCacheRspIn
  MCU.io.iCacheReqOut <> bus.io.iCacheReqOut
  bus.io.iCacheRspIn <> MCU.io.iCacheRspIn



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


  // Here IO stuff
  // IO is mapped ot 0xf000_0000
  // use lower bits to select IOs

  // UART:
  // 0xf000_0000 status:
  // bit 0 TX ready (TDE)
  // bit 1 RX data available (RDF)
  // 0xf000_0004 send and receive register
  // BUG: If using freqhz instead of 100000000 we might get an error if freqhz > baudrate (will get negative number).
  val tx = Module(new BufferedTx(100000000, 115200))
  val rx = Module(new Rx(100000000, 115200))
  io.tx := tx.io.txd
  rx.io.rxd := io.rx

  tx.io.channel.bits := cpu.io.dmem.wrData(7, 0)
  tx.io.channel.valid := false.B
  rx.io.channel.ready := false.B

  // Default values for memory accesses
  val uartStatusReg = RegNext(rx.io.channel.valid ## tx.io.channel.ready)
  val memAddressReg = RegNext(cpu.io.dmem.rdAddress)
  val writeAddressReg = RegNext(cpu.io.dmem.wrAddress)


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

  // Memory access logic with added CLINT handling
  when(memAddressReg(31, 28) === 0xf.U) {
    when(isClintAccess) {
      // Access to CLINT
      cpu.io.dmem.rdData := clint.io.link.rdData
    }.elsewhen(memAddressReg(19, 16) === 0.U) {
      // UART access
      when(memAddressReg(3, 0) === 0.U) {
        cpu.io.dmem.rdData := uartStatusReg
      }.elsewhen(memAddressReg(3, 0) === 4.U) {
        cpu.io.dmem.rdData := rx.io.channel.bits
        rx.io.channel.ready := cpu.io.dmem.rdEnable
      }.otherwise {
        cpu.io.dmem.rdData := 0.U
      }
    }.otherwise {
      cpu.io.dmem.rdData := 0.U
    }
  }

  val ledReg = RegInit(0.U(8.W))
  when ((cpu.io.dmem.wrAddress(31, 28) === 0xf.U) && cpu.io.dmem.wrEnable(0)) {
    when (isClintWrite) {
      // Write to CLINT handled by CLINT module
    } .elsewhen (cpu.io.dmem.wrAddress(19,16) === 0.U && cpu.io.dmem.wrAddress(3, 0) === 4.U) {
      //printf(" %c %d\n", cpu.io.dmem.wrData(7, 0), cpu.io.dmem.wrData(7, 0))
      tx.io.channel.valid := true.B
    } .elsewhen (cpu.io.dmem.wrAddress(19,16) === 1.U) {
      ledReg := cpu.io.dmem.wrData(7, 0)
    } .otherwise {
      // Any other IO or memory region, do nothing for write
    }
    //dmem.io.wrEnable := VecInit(Seq.fill(4)(false.B))
    bus.io.CPUdCacheMemIO.wrEnable := VecInit(Seq.fill(4)(false.B))
  }

  io.led := 1.U ## 0.U(7.W) ## RegNext(ledReg)

  when(isClintAccess) {
    //printf(p"[WildcatTop] CLINT Access: Addr=0x${Hexadecimal(memAddressReg)}, isWrite=${isClintWrite}\n")
  }
}

object WildcatTop extends App {
  emitVerilog(new WildcatTop(args(0)), Array("--target-dir", "generated"))
}