package Bootloader

import ExtMemory.SPICommands._
import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._


class MemoryControllerTopTester (implicit val config:TilelinkConfig) extends Module {
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
    val RAM0Mode = Output(UInt(2.W))
    val RAM1Mode = Output(UInt(2.W))
    val SpiSi = Output(UInt(4.W))
    val LastCommand = Output(UInt(8.W))

    val SpiCtrl0Done = Output(Bool())
    val SpiCtrl1Done = Output(Bool())

  })
  val CTRL = Module(new MemoryControllerTop())
  CTRL.io.dCacheReqOut <> io.dCacheReqOut
  io.dCacheRspIn <> CTRL.io.dCacheRspIn
  CTRL.io.iCacheReqOut <> io.iCacheReqOut
  io.iCacheRspIn <> CTRL.io.iCacheRspIn
  io.CS0 := CTRL.io.CS0
  io.CS1 := CTRL.io.CS1
  io.CS2 := CTRL.io.CS2
  io.RAM0Mode := DontCare
  io.RAM1Mode := DontCare
  io.SpiSi := DontCare
  io.LastCommand := DontCare
  io.SpiCtrl0Done := DontCare
  io.SpiCtrl1Done := DontCare


  BoringUtils.bore(CTRL.RAM0.mode,Seq(io.RAM0Mode))
  BoringUtils.bore(CTRL.RAM1.mode,Seq(io.RAM1Mode))
  BoringUtils.bore(CTRL.SpiCtrl.io.si,Seq(io.SpiSi))
  BoringUtils.bore(CTRL.RAM0.lastCommand, Seq(io.LastCommand))
  BoringUtils.bore(CTRL.MemCtrl.io.SPIctrl(0).done, Seq(io.SpiCtrl0Done))
  BoringUtils.bore(CTRL.MemCtrl.io.SPIctrl(1).done, Seq(io.SpiCtrl1Done))

}

class MemoryControllerTopTest extends AnyFlatSpec with ChiselScalatestTester{
  implicit val config = TilelinkConfig()

  "Controller" should "init" in {
    test(new MemoryControllerTopTester()) { dut =>
      dut.io.CS0.expect(false.B)
      dut.io.CS1.expect(false.B)
      dut.io.CS2.expect(true.B)
    }
  }

  "Controller" should "configure ext memory" in {
    test(new MemoryControllerTopTester()) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      def expectSerialWrite(num: UInt): Unit = {
        for (i <- num.getWidth  to 0 by -1) {
          dut.io.SpiSi.expect(num(i))
          step()
        }
      }

      expectSerialWrite(QUAD_MODE_ENABLE)
      step()
      dut.io.RAM0Mode.expect(1.U)
      dut.io.RAM1Mode.expect(1.U)

      dut.io.CS0.expect(true.B)
      dut.io.CS1.expect(true.B)
      dut.io.CS2.expect(true.B)
    }
  }

  "Controller" should "Write to" in {
    test(new MemoryControllerTopTester()) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      def expectSerialWrite(num: UInt): Unit = {
        for (i <- num.getWidth to 0 by -1) {
          dut.io.SpiSi.expect(num(i))
          step()
        }
      }

      def expectQpiWrite(num: UInt): Unit = {
        for(i <- num.getWidth/4 to 1 by -1){
          dut.io.SpiSi.expect(num(i*4 - 1, i*4 - 4))
          step()
        }
      }

      expectSerialWrite(QUAD_MODE_ENABLE)
      step()
      dut.io.RAM0Mode.expect(1.U)
      dut.io.RAM1Mode.expect(1.U)

      dut.io.CS0.expect(true.B)
      dut.io.CS1.expect(true.B)
      dut.io.CS2.expect(true.B)

      // Write "BEEFFACE" in address 0 in RAM0 (Request from dCache)
      dut.io.dCacheReqOut.bits.dataRequest.poke("hBEEFFACE".U)
      dut.io.dCacheReqOut.bits.addrRequest.poke(0.U)
      dut.io.dCacheReqOut.bits.isWrite.poke(true.B)
      dut.io.dCacheReqOut.bits.activeByteLane.poke(15.U)
      dut.io.dCacheReqOut.valid.poke(true.B)
      step(2)
      dut.io.CS0.expect(false.B)
      dut.io.CS1.expect(true.B)

      expectQpiWrite(QPI_WRITE)
      expectQpiWrite(0.U(24.W)) // Address
      expectQpiWrite("hBEEFFACE".U)
      dut.io.CS0.expect(true.B)
      dut.io.SpiCtrl0Done.expect(true.B)
      dut.io.dCacheRspIn.valid.expect(true.B)
      step()


      // Write "hBEEF" at address 2 in RAM1 (request from iCache)
      dut.io.dCacheReqOut.valid.poke(false.B)
      dut.io.iCacheReqOut.bits.dataRequest.poke("hBEEFBEEF".U)
      dut.io.iCacheReqOut.bits.addrRequest.poke("h1000002".U)
      dut.io.iCacheReqOut.bits.isWrite.poke(true.B)
      dut.io.iCacheReqOut.bits.activeByteLane.poke(12.U)
      dut.io.iCacheReqOut.valid.poke(true.B)
      step(2)
      dut.io.CS1.expect(false.B)
      dut.io.CS0.expect(true.B)

      expectQpiWrite(QPI_WRITE)
      expectQpiWrite(2.U(24.W)) // Address
      step(4)
      expectQpiWrite("hBEEF".U)

      dut.io.CS1.expect(true.B)
      dut.io.SpiCtrl1Done.expect(true.B)
      dut.io.iCacheRspIn.valid.expect(true.B)

    }
  }
}
