package Bootloader

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
  BoringUtils.bore(CTRL.RAM0.mode,Seq(io.RAM0Mode))
  BoringUtils.bore(CTRL.RAM1.mode,Seq(io.RAM1Mode))
  BoringUtils.bore(CTRL.SpiCtrl.io.si,Seq(io.SpiSi))
  BoringUtils.bore(CTRL.RAM0.lastCommand, Seq(io.LastCommand))
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
      var configure = 0
      while(!dut.io.CS0.peekBoolean() && !dut.io.CS1.peekBoolean()){
        step()
        //println(f"Cycle($configure) data: ${dut.io.SpiSi.peek()}")
        configure = configure + 1
        //println(f"Last command: ${dut.io.LastCommand.peek()}")
      }
      step()
      dut.io.RAM0Mode.expect(1.U)
      dut.io.RAM1Mode.expect(1.U)

      dut.io.CS0.expect(true.B)
      dut.io.CS1.expect(true.B)
      dut.io.CS2.expect(true.B)
    }
  }
}
