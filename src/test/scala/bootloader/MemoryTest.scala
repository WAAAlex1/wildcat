package bootloader

import caches.BusInterconnect
import caches.simple.CacheFunctions.pokeVecBool
import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import wildcat.Util
import wildcat.pipeline.MemIO

class MemoryTester(implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    // To/From caches via bus
    val CPUdCacheMemIO = Flipped(new MemIO())
    val CPUiCacheMemIO = Flipped(new MemIO())



    // Debugging

    val dready = Output(Bool())
    val iready = Output(Bool())
  })
  val file = "risc-v-lab/tests/simple/addpos.bin"
  val (memory, start) = Util.getCode(file)

  val bus = Module(new BusInterconnect())
  val CTRL = Module(new MemoryControllerTopSimulator(1.U, memory))

  bus.io.CPUdCacheMemIO <> io.CPUdCacheMemIO
  bus.io.CPUiCacheMemIO <> io.CPUiCacheMemIO

  CTRL.io.dCacheReqOut <> bus.io.dCacheReqOut
  bus.io.dCacheRspIn <> CTRL.io.dCacheRspIn
  bus.io.iCacheRspIn <> CTRL.io.iCacheRspIn
  CTRL.io.iCacheReqOut <> bus.io.iCacheReqOut


  io.dready := DontCare
  io.iready := DontCare
  BoringUtils.bore(bus.dCacheAdapter.Cache.Controller.io.ready, Seq(io.dready))
  BoringUtils.bore(bus.iCacheAdapter.Cache.Controller.io.ready, Seq(io.iready))
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


      dut.io.CPUiCacheMemIO.rdEnable.poke(true.B)
      dut.io.CPUiCacheMemIO.rdAddress.poke(0.U)
      step()
      dut.io.CPUiCacheMemIO.rdEnable.poke(false.B)
      while(dut.io.CPUiCacheMemIO.stall.peekBoolean()){
        step()
      }


      dut.io.CPUdCacheMemIO.stall.expect(false.B)
      dut.io.CPUdCacheMemIO.rdEnable.poke(false.B)
      dut.io.CPUdCacheMemIO.wrAddress.poke(2.U)
      pokeVecBool(dut.io.CPUdCacheMemIO.wrEnable, 12)
      dut.io.CPUdCacheMemIO.wrData.poke("hBABEBABE".U)

      step()

      dut.io.CPUdCacheMemIO.wrAddress.poke(0.U)
      pokeVecBool(dut.io.CPUdCacheMemIO.wrEnable, 0)

      while(!dut.io.dready.peekBoolean()){
        step()
      }
      dut.io.CPUdCacheMemIO.rdAddress.poke(0.U)
      dut.io.CPUdCacheMemIO.rdEnable.poke(true.B)
      step()
      dut.io.CPUdCacheMemIO.rdEnable.poke(false.B)
      while(dut.io.CPUdCacheMemIO.stall.peekBoolean){
        step()
      }
      dut.io.CPUdCacheMemIO.rdEnable.poke(false.B)
      dut.io.CPUiCacheMemIO.rdEnable.poke(false.B)

      step(2)

      pokeVecBool(dut.io.CPUiCacheMemIO.wrEnable, 15)
      dut.io.CPUiCacheMemIO.wrAddress.poke(16.U)
      dut.io.CPUiCacheMemIO.wrData.poke("h12345678".U)


      step()
      pokeVecBool(dut.io.CPUiCacheMemIO.wrEnable, 0)
      while(!dut.io.iready.peekBoolean()){
        step()
      }

      dut.io.CPUdCacheMemIO.rdEnable.poke(true.B)
      dut.io.CPUdCacheMemIO.rdAddress.poke(16.U)
      step()

      while(dut.io.CPUdCacheMemIO.stall.peekBoolean){
        step()
      }




    }
  }


}