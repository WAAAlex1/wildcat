package Caches.SimpleCache

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class RAMTest extends AnyFlatSpec with ChiselScalatestTester {
  "Ram" should "pass" in {
    test(new SRAM(64,32)) { dut =>
      dut.io.EN.poke(true.B)
      dut.io.ad.poke(0.U)
      dut.io.rw.poke(true.B)
      dut.io.DO.expect(0.U)
      dut.clock.step()
      dut.io.DO.expect(0.U)
      dut.io.rw.poke(false.B)
      dut.io.DO.expect(0.U)
      dut.io.DI.poke(2.U)
      dut.clock.step()
      dut.io.ad.poke(1.U)
      dut.io.DI.poke(4.U)
      dut.clock.step()
      dut.io.EN.poke(false.B)
      dut.io.rw.poke(true.B)
      dut.io.ad.poke(0.U)
      dut.clock.step ()
      dut.io.DO.expect(0.U) // enable disabled = lastRead
      dut.io.EN.poke(true.B)
      dut.clock.step()
      dut.io.DO.expect(2.U)
      dut.io.ad.poke(1.U)
      dut.clock.step()
      dut.io.DO.expect(4.U)
    }
  }

}
