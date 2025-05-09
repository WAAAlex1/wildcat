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
    val SPIctrl = Flipped(new SpiCTRLIO)


    // Debugging
    val dReqAck = Output(Bool())
    val iReqAck = Output(Bool())
    val masterID = Output(Bool())
    val rspHandled = Output(Bool())
    val iCacheRspInValid = Output(Bool())
    val iCacheRspInDataResponse = Output(UInt(32.W))
  })
  val CTRL = Module(new MemoryController())
  CTRL.io.dCacheReqOut <> io.dCacheReqOut
  io.dCacheRspIn <> CTRL.io.dCacheRspIn
  CTRL.io.iCacheReqOut <> io.iCacheReqOut
  io.iCacheRspIn <> CTRL.io.iCacheRspIn
  io.SPIctrl <>  CTRL.io.SPIctrl
  CTRL.io.SpiCtrlValid := DontCare
  io.dReqAck := DontCare
  io.iReqAck := DontCare
  io.masterID := DontCare
  io.rspHandled := DontCare
  io.iCacheRspInValid := DontCare
  io.iCacheRspInDataResponse := DontCare

  BoringUtils.bore(CTRL.dReqAck,Seq(io.dReqAck))
  BoringUtils.bore(CTRL.iReqAck,Seq(io.iReqAck))
  BoringUtils.bore(CTRL.masterID, Seq(io.masterID))
  //BoringUtils.bore(CTRL.rspHandled, Seq(io.rspHandled))
  BoringUtils.bore(CTRL.io.iCacheRspIn.valid, Seq(io.iCacheRspInValid))
  BoringUtils.bore(CTRL.io.iCacheRspIn.bits.dataResponse, Seq(io.iCacheRspInDataResponse))

}

class MemoryControllerTest extends AnyFlatSpec with ChiselScalatestTester {
  implicit val config = TilelinkConfig()

  "Controller" should "init" in {
    test(new MemoryControllerTester()) { dut =>
      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(false.B)

    }
  }

  "Controller" should "Store" in {
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
      dut.io.SPIctrl.en.expect(true.B)
      dut.io.SPIctrl.addr.expect(0.U)
      dut.io.SPIctrl.rw.expect(true.B)
      dut.io.SPIctrl.size.expect(4.U)
      dut.io.SPIctrl.dataIn.expect("hBEEFFACE".U)
      dut.io.dCacheReqOut.valid.poke(false.B)
      step()
      dut.io.SPIctrl.done.poke(true.B)
      step(10)

      // Write "hBEEF" at address 2 in RAM1 (request from iCache)
      dut.io.iCacheReqOut.bits.dataRequest.poke("hBEEFBEEF".U)
      dut.io.iCacheReqOut.bits.addrRequest.poke("h1000002".U)
      dut.io.iCacheReqOut.bits.isWrite.poke(true.B)
      dut.io.iCacheReqOut.bits.activeByteLane.poke(12.U)
      dut.io.iCacheReqOut.valid.poke(true.B)
      step()
      dut.io.iReqAck.expect(true.B)
      dut.io.SPIctrl.addr.expect(2.U)
      dut.io.SPIctrl.rw.expect(true.B)
      dut.io.SPIctrl.size.expect(2.U)
      dut.io.SPIctrl.dataIn.expect("hBEEF".U)

    }
  }

  "Controller" should "Load" in {
    test(new MemoryControllerTester()) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(false.B)

      // Read address 40 from RAM1 (b 1...00101000, h 1000028)  (Request from iCache)
      dut.io.iCacheReqOut.bits.addrRequest.poke("h1000028".U)
      dut.io.iCacheReqOut.bits.isWrite.poke(false.B)
      dut.io.iCacheReqOut.bits.activeByteLane.poke(15.U)
      dut.io.iCacheReqOut.valid.poke(true.B)
      step()
      dut.io.iReqAck.expect(true.B)
      dut.io.SPIctrl.en.expect(true.B)
      dut.io.SPIctrl.addr.expect(40.U)
      dut.io.SPIctrl.rw.expect(false.B)
      dut.io.SPIctrl.size.expect(4.U)
      dut.io.SPIctrl.dataIn.expect(0.U)
      //println("First step success with rspHandled = " + dut.io.rspHandled.peekBoolean())
      step()
      dut.io.SPIctrl.dataOut.poke("hBEEBBEEB".U)
      dut.io.SPIctrl.done.poke(true.B)
      dut.io.masterID.expect(true.B)
      //println("Second step success with rspHandled = " + dut.io.rspHandled.peekBoolean())
      step()
      dut.io.iCacheRspIn.valid.expect(true.B)
      dut.io.iCacheRspIn.bits.dataResponse.expect("hBEEBBEEB".U)
      dut.io.SPIctrl.done.poke(false.B)
      //println("Third step success with rspHandled = " + dut.io.rspHandled.peekBoolean())
      step()
      println("iCacheRspIn.valid = " + dut.io.iCacheRspInValid.peekBoolean())
      println(f"iCacheRspIn.bits.dataResponse = 0x${dut.io.iCacheRspInDataResponse.peekInt()}%08x")
      dut.io.iCacheRspIn.valid.expect(false.B)
      dut.io.iCacheRspIn.bits.dataResponse.expect(0.U)
      //println("Final step success with rspHandled = " + dut.io.rspHandled.peekBoolean())

    }
  }

}
