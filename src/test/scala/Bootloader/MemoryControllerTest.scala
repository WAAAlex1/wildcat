package Bootloader

import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3._
import chiseltest._
import chisel3.util._
import chisel3.util.experimental.BoringUtils
import chiseltest.ChiselScalatestTester
import org.scalatest.flatspec.AnyFlatSpec



class MemoryControllerTester (implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    // To/From caches via bus
    val dCacheReqOut = Flipped(Decoupled(new TLRequest))
    val dCacheRspIn = Decoupled(new TLResponse)

    val iCacheReqOut = Flipped(Decoupled(new TLRequest))
    val iCacheRspIn = Decoupled(new TLResponse)

    // To/Form SPI controllers
    val SPIctrl = Vec(2, Flipped(new SpiIO))


    // Debugging
    val dReqAck = Output(Bool())
    val iReqAck = Output(Bool())

  })
  val CTRL = Module(new MemoryController())
  CTRL.io.bootloading := false.B
  CTRL.io.memIO.wrData := DontCare
  CTRL.io.memIO.wrEnable := DontCare
  CTRL.io.memIO.rdEnable := DontCare
  CTRL.io.memIO.rdAddress := DontCare
  CTRL.io.memIO.wrAddress := DontCare
  CTRL.io.dCacheReqOut <> io.dCacheReqOut
  io.dCacheRspIn <> CTRL.io.dCacheRspIn
  CTRL.io.iCacheReqOut <> io.iCacheReqOut
  io.iCacheRspIn <> CTRL.io.iCacheRspIn
  io.SPIctrl <>  CTRL.io.SPIctrl
  io.dReqAck := DontCare
  io.iReqAck := DontCare

  BoringUtils.bore(CTRL.dReqAck,Seq(io.dReqAck))
  BoringUtils.bore(CTRL.iReqAck,Seq(io.iReqAck))

}

class MemoryControllerTest extends AnyFlatSpec with ChiselScalatestTester {
  implicit val config = TilelinkConfig()

  "Bus" should "init" in {
    test(new MemoryControllerTester()) { dut =>
      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(false.B)

    }
  }

  "Bus" should "Store word in RAM0 and store half in RAM1" in {
    test(new MemoryControllerTester()) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(false.B)

      // Write "BEEFFACE" in address 0 in RAM0 (Request from dCache)
      dut.io.dCacheReqOut.bits.dataRequest.poke("hBEEFFACE".U)
      dut.io.dCacheReqOut.bits.addrRequest.poke(0.U)
      dut.io.dCacheReqOut.bits.isWrite.poke(true.B)
      dut.io.dCacheReqOut.bits.activeByteLane.poke(15.U)
      dut.io.dCacheReqOut.valid.poke(true.B)
      step()
      dut.io.dReqAck.expect(true.B)
      dut.io.SPIctrl(0).en.expect(true.B)
      dut.io.SPIctrl(0).addr.expect(0.U)
      dut.io.SPIctrl(0).rw.expect(true.B)
      dut.io.SPIctrl(0).size.expect(4.U)
      dut.io.SPIctrl(0).dataIn.expect("hBEEFFACE".U)
      dut.io.SPIctrl(1).en.expect(false.B)

      // Write "hBEEF" at address 2 in RAM1 (request from iCache)
      dut.io.dCacheReqOut.valid.poke(false.B)
      dut.io.iCacheReqOut.bits.dataRequest.poke("hBEEFBEEF".U)
      dut.io.iCacheReqOut.bits.addrRequest.poke("h1000002".U)
      dut.io.iCacheReqOut.bits.isWrite.poke(true.B)
      dut.io.iCacheReqOut.bits.activeByteLane.poke(12.U)
      dut.io.iCacheReqOut.valid.poke(true.B)
      step()
      dut.io.iReqAck.expect(true.B)
      dut.io.SPIctrl(1).en.expect(true.B)
      dut.io.SPIctrl(1).addr.expect(2.U)
      dut.io.SPIctrl(1).rw.expect(true.B)
      dut.io.SPIctrl(1).size.expect(2.U)
      dut.io.SPIctrl(1).dataIn.expect("hBEEF".U)
      dut.io.SPIctrl(0).en.expect(false.B)
    }
  }

}
