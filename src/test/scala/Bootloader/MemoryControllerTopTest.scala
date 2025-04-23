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


  })
  val CTRL = Module(new MemoryControllerTop())
  CTRL.io.dCacheReqOut <> io.dCacheReqOut
  io.dCacheRspIn <> CTRL.io.dCacheRspIn
  CTRL.io.iCacheReqOut <> io.iCacheReqOut
  io.iCacheRspIn <> CTRL.io.iCacheRspIn
  io.CS0 := CTRL.io.CS0
  io.CS1 := CTRL.io.CS1
  io.CS2 := CTRL.io.CS2


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

}
