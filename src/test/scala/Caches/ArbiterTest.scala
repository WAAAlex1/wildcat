package Caches

import chisel3._
import chiseltest._
import chiseltest.{ChiselScalatestTester, testableBool}
import org.scalatest.flatspec.AnyFlatSpec
import caravan.bus.tilelink.TilelinkConfig


class ArbiterTest extends AnyFlatSpec with ChiselScalatestTester{
  implicit val config = TilelinkConfig()

  "Bus" should "work" in {
    test(new Arbiter()) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }
      // No valid requests
      dut.io.reqOut.valid.expect(false.B)
      dut.io.source.expect(0.U)
      step()

      // Dmem valid request => should choose Dmem
      dut.io.DmemReqOut.valid.poke(true.B)
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.source.expect(0.U)
      step()


      // Both valid request => should choose Dmem
      dut.io.DmemReqOut.valid.poke(true.B)
      dut.io.ImemReqOut.valid.poke(true.B)
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.source.expect(0.U)
      step()


      // Imem vlaid request => should choose Imem
      dut.io.DmemReqOut.valid.poke(false.B)
      dut.io.ImemReqOut.valid.poke(true.B)
      step()
      dut.io.reqOut.valid.expect(true.B)
      dut.io.source.expect(1.U)
      step()

    }
  }
}
