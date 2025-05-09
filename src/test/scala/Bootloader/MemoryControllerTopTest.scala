package Bootloader

import ExtMemory.SPICommands._
import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._


class MemoryControllerTopTester(prescale: UInt) (implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    // To/From caches via bus
    val dCacheReqOut = Flipped(Decoupled(new TLRequest))
    val dCacheRspIn = Decoupled(new TLResponse)

    val iCacheReqOut = Flipped(Decoupled(new TLRequest))
    val iCacheRspIn = Decoupled(new TLResponse)

    val CS0 = Output(Bool())
    val CS1 = Output(Bool())
    val CS2 = Output(Bool())


    // Debugging
    val quadMode = Output(UInt(2.W))
    val RAM1Mode = Output(UInt(2.W))
    val SpiSi = Output(UInt(4.W))
    val SpiSo = Output(UInt(4.W))
    val LastCommand = Output(UInt(8.W))

    val SpiCtrlDone = Output(Bool())
    val SpiCtrlTopState = Output(UInt(4.W))




  })
  val CTRL = Module(new MemoryControllerTopSimulator(prescale))
  CTRL.io.dCacheReqOut <> io.dCacheReqOut
  io.dCacheRspIn <> CTRL.io.dCacheRspIn
  CTRL.io.iCacheReqOut <> io.iCacheReqOut
  io.iCacheRspIn <> CTRL.io.iCacheRspIn
  io.CS0 := CTRL.io.CS0
  io.CS1 := CTRL.io.CS1
  io.CS2 := CTRL.io.CS2
  io.quadMode := DontCare
  io.RAM1Mode := DontCare
  io.SpiSi := DontCare
  io.LastCommand := DontCare
  io.SpiCtrlDone := DontCare
  io.SpiSo := DontCare
  io.SpiCtrlTopState := DontCare
  BoringUtils.bore(CTRL.SpiCtrl.quadReg, Seq(io.quadMode))
  BoringUtils.bore(CTRL.SpiCtrl.io.inSio,Seq(io.SpiSi))
  BoringUtils.bore(CTRL.MemCtrl.io.SPIctrl.done, Seq(io.SpiCtrlDone))
  BoringUtils.bore(CTRL.SpiCtrl.io.outSio, Seq(io.SpiSo))
  BoringUtils.bore(CTRL.SpiCtrl.state, Seq(io.SpiCtrlTopState))
}

class MemoryControllerTopTest extends AnyFlatSpec with ChiselScalatestTester{
  implicit val config = TilelinkConfig()
  val prescale = 1

  "Controller" should "init" in {
    test(new MemoryControllerTopTester(prescale.asUInt)) { dut =>
      dut.io.CS0.expect(true.B)
      dut.io.CS1.expect(true.B)
      dut.io.CS2.expect(true.B)
    }
  }

  "Controller" should "configure ext memory" in {
    test(new MemoryControllerTopTester(prescale.asUInt)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      def expectSerialWrite(num: UInt): Unit = {
        for (i <- num.getWidth  to 1 by -1) {
          dut.io.SpiSo.expect(num(i))
          step(2 << prescale)
        }
        dut.io.SpiSo.expect(num(0))
        step(2)
      }

      def expectQpi(port: UInt, num: UInt): Unit = {
        for(i <- num.getWidth/4 to 1 by -1){
          port.expect(num(i*4 - 1, i*4 - 4))
          step(4 << prescale)
        }
      }
      step(26 + (16 << prescale))

      dut.io.quadMode.expect(true.B)

      step((2 << prescale))

    }
  }

  "Controller" should "Write and read" in {
    test(new MemoryControllerTopTester(prescale.asUInt)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      def expectSerialWrite(num: UInt): Unit = {
        for (i <- num.getWidth  to 1 by -1) {
          dut.io.SpiSo.expect(num(i))
          step(2 << prescale)
        }
        dut.io.SpiSo.expect(num(0))
        step(2)
      }

      def expectQpi(port: UInt, num: UInt): Unit = {
        for(i <- num.getWidth/4 to 1 by -1){
          port.expect(num(i*4 - 1, i*4 - 4))
          step(2 << prescale)
        }
      }

      step(18 + (16 << prescale))

      dut.io.quadMode.expect(true.B)

      step((2 << prescale))

      // Write "BEEFFACE" in address 4 in RAM0 (Request from dCache)
      dut.io.dCacheReqOut.bits.dataRequest.poke("hBEEFFACE".U)
      dut.io.dCacheReqOut.bits.addrRequest.poke(4.U)
      dut.io.dCacheReqOut.bits.isWrite.poke(true.B)
      dut.io.dCacheReqOut.bits.activeByteLane.poke(15.U)
      dut.io.dCacheReqOut.valid.poke(true.B)
      step(4 << prescale)
      dut.io.dCacheReqOut.valid.poke(false.B)
      step(18 << prescale)


      // Write "hBEEF" at address 2 in RAM1 (request from iCache)
      dut.io.dCacheReqOut.valid.poke(false.B)
      dut.io.iCacheReqOut.bits.dataRequest.poke("hABABABAB".U)
      dut.io.iCacheReqOut.bits.addrRequest.poke("h1000003".U)
      dut.io.iCacheReqOut.bits.isWrite.poke(true.B)
      dut.io.iCacheReqOut.bits.activeByteLane.poke(8.U)
      dut.io.iCacheReqOut.valid.poke(true.B)
      step(4 << prescale)
      dut.io.iCacheReqOut.valid.poke(false.B)
      step(18 << prescale)

      // Read address 0 in RAM0 and Read address 0 in RAM1 (Request from both)
      dut.io.iCacheReqOut.bits.addrRequest.poke("h1000000".U)
      dut.io.iCacheReqOut.bits.isWrite.poke(false.B)
      dut.io.iCacheReqOut.bits.activeByteLane.poke(15.U)
      dut.io.iCacheReqOut.valid.poke(true.B)
      dut.io.dCacheReqOut.bits.addrRequest.poke(4.U)
      dut.io.dCacheReqOut.bits.isWrite.poke(false.B)
      dut.io.dCacheReqOut.bits.activeByteLane.poke(15.U)
      dut.io.dCacheReqOut.valid.poke(true.B)
      step(4 << prescale)
      dut.io.dCacheReqOut.valid.poke(false.B)
      step(32 << prescale)
      dut.io.dCacheReqOut.valid.poke(true.B)
      dut.io.dCacheReqOut.bits.addrRequest.poke(0.U)
      step(42 << prescale)
    }
  }
}
