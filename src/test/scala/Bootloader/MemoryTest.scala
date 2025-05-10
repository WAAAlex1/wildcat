package Bootloader

import Caches.BusInterconnect
import Caches.SimpleCache.CacheFunctions.pokeVecBool
import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import wildcat.pipeline.MemIO

class MemoryTester(implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    // To/From caches via bus
    val CPUdCacheMemIO = Flipped(new MemIO())
    val CPUiCacheMemIO = Flipped(new MemIO())



    // Debugging
  })
  val bus = Module(new BusInterconnect())
  val CTRL = Module(new MemoryControllerTopSimulator(1.U))

  bus.io.CPUdCacheMemIO <> io.CPUdCacheMemIO
  bus.io.CPUiCacheMemIO <> io.CPUiCacheMemIO

  CTRL.io.dCacheReqOut <> bus.io.dCacheReqOut
  bus.io.dCacheRspIn <> CTRL.io.dCacheRspIn
  bus.io.iCacheRspIn <> CTRL.io.iCacheRspIn
  CTRL.io.iCacheReqOut <> bus.io.iCacheReqOut

}

class MemoryTest extends AnyFlatSpec with ChiselScalatestTester {
  implicit val config = TilelinkConfig()

  "Mem" should "init" in {
    test(new MemoryTester()) { dut =>
      dut.io.CPUiCacheMemIO.stall.expect(false.B)
      dut.io.CPUdCacheMemIO.stall.expect(false.B)
    }
  }

  "Mem" should "work" in {
    test(new MemoryTester()).withAnnotations(Seq(WriteVcdAnnotation))  { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      dut.io.CPUiCacheMemIO.stall.expect(false.B)
      dut.io.CPUdCacheMemIO.stall.expect(false.B)

      dut.io.CPUdCacheMemIO.stall.expect(false.B)
      dut.io.CPUdCacheMemIO.rdEnable.poke(false.B)
      dut.io.CPUdCacheMemIO.wrAddress.poke(2.U)
      pokeVecBool(dut.io.CPUdCacheMemIO.wrEnable, 12)
      dut.io.CPUdCacheMemIO.wrData.poke("hBABEBABE".U)

      step()
      while(dut.io.CPUdCacheMemIO.stall.peekBoolean){
        step()
      }
      dut.io.CPUdCacheMemIO.wrAddress.poke(0.U)
      pokeVecBool(dut.io.CPUdCacheMemIO.wrEnable, 3)
      dut.io.CPUdCacheMemIO.wrData.poke("hFACEFACE".U)
      step()
      while(dut.io.CPUdCacheMemIO.stall.peekBoolean){
        step()
      }
      pokeVecBool(dut.io.CPUdCacheMemIO.wrEnable, 0)
      step(2)
      dut.io.CPUdCacheMemIO.rdAddress.poke(0.U)
      dut.io.CPUdCacheMemIO.rdEnable.poke(true.B)
      step()
      dut.io.CPUdCacheMemIO.rdAddress.poke(4.U)
      step()
      dut.io.CPUdCacheMemIO.rdAddress.poke(8.U)
      step()



    }
  }


}