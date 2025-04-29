package Caches


import chisel3._
import chiseltest._
import chiseltest.{ChiselScalatestTester, testableBool}
import org.scalatest.flatspec.AnyFlatSpec
import caravan.bus.tilelink.TilelinkConfig
import Caches.SimpleCache.CacheFunctions._

class CacheBusAdapterTest extends AnyFlatSpec with ChiselScalatestTester {
  implicit val config = TilelinkConfig()

  "Bus" should "init" in {
    test(new CacheBusAdapter()) { dut =>
      dut.io.reqOut.valid.expect(false.B)
      dut.io.reqOut.bits.isWrite.expect(false)

    }
  }

  "Bus" should "SW" in {
    test(new CacheBusAdapter()) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }
      dut.io.rspIn.valid.poke(true.B)
      dut.io.reqOut.ready.poke(true.B)
      dut.io.reqOut.valid.expect(false.B)
      dut.io.CPUMemIO.stall.expect(false.B)
      dut.io.CPUMemIO.rdEnable.poke(false.B)
      dut.io.CPUMemIO.wrAddress.poke(0.U)
      pokeVecBool(dut.io.CPUMemIO.wrEnable, 15)
      dut.io.CPUMemIO.wrData.poke("hCAFEBABE".U)
      step()
      dut.io.CPUMemIO.stall.expect(true.B) // miss / invalid
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.reqOut.bits.addrRequest.expect(0.U)
      dut.io.reqOut.bits.dataRequest.expect(0.U)
      dut.io.reqOut.bits.isWrite.expect(false.B)
      dut.io.reqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.reqOut.bits.isWrite.expect(false.B)
      dut.io.reqOut.bits.addrRequest.expect(4.U)
      dut.io.reqOut.bits.dataRequest.expect(0.U)
      dut.io.reqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.reqOut.bits.addrRequest.expect(8.U)
      dut.io.reqOut.bits.dataRequest.expect(0.U)
      dut.io.reqOut.bits.isWrite.expect(false.B)
      dut.io.reqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.reqOut.bits.addrRequest.expect(12.U)
      dut.io.reqOut.bits.dataRequest.expect(0.U)
      dut.io.reqOut.bits.isWrite.expect(false.B)
      dut.io.reqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.CPUMemIO.stall.expect(true.B) // hit after allocate, but stall since cache is busy
      dut.io.CPUMemIO.rdData.expect(0.U) // Reading before write
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.reqOut.bits.addrRequest.expect(0.U)
      dut.io.reqOut.bits.dataRequest.expect("hCAFEBABE".U)
      dut.io.reqOut.bits.isWrite.expect(true.B)
      dut.io.reqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.CPUMemIO.stall.expect(false.B)


    }
  }
  "Bus" should "SB" in {
    test(new CacheBusAdapter()) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      dut.io.rspIn.valid.poke(true.B)
      dut.io.reqOut.ready.poke(true.B)
      dut.io.reqOut.valid.expect(false.B)
      dut.io.CPUMemIO.stall.expect(false.B)
      dut.io.CPUMemIO.rdEnable.poke(false.B)
      dut.io.CPUMemIO.wrAddress.poke(2.U)
      pokeVecBool(dut.io.CPUMemIO.wrEnable, 4)
      dut.io.CPUMemIO.wrData.poke("hAAAAAAAA".U)
      step()
      dut.io.CPUMemIO.stall.expect(true.B) // miss / invalid
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.reqOut.bits.addrRequest.expect(0.U)
      dut.io.reqOut.bits.dataRequest.expect(0.U)
      dut.io.reqOut.bits.isWrite.expect(false.B)
      dut.io.reqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.reqOut.bits.isWrite.expect(false.B)
      dut.io.reqOut.bits.addrRequest.expect(4.U)
      dut.io.reqOut.bits.dataRequest.expect(0.U)

      dut.io.reqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.reqOut.bits.addrRequest.expect(8.U)
      dut.io.reqOut.bits.dataRequest.expect(0.U)
      dut.io.reqOut.bits.isWrite.expect(false.B)
      dut.io.reqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.reqOut.bits.addrRequest.expect(12.U)
      dut.io.reqOut.bits.dataRequest.expect(0.U)
      dut.io.reqOut.bits.isWrite.expect(false.B)
      dut.io.reqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.CPUMemIO.stall.expect(true.B) // hit after allocate, but stall since cache is busy
      dut.io.CPUMemIO.rdData.expect(0.U) // Reading before write
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.reqOut.bits.addrRequest.expect(2.U)
      dut.io.reqOut.bits.dataRequest.expect("hAAAAAAAA".U)
      dut.io.reqOut.bits.isWrite.expect(true.B)
      dut.io.reqOut.bits.activeByteLane.expect(4.U)
      step()
      dut.io.CPUMemIO.stall.expect(false.B)


    }
  }

}


