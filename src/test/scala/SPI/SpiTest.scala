/*
 * Description: Testbench for Memory SPI controller
 * 
 * Author: Sofus Hammelsø
 */

package SPI

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class SpiTest extends AnyFlatSpec with ChiselScalatestTester {
  "SpiController" should "pass" in {
    test(new SpiMemController).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      dut.io.rst.poke(false.B)
      dut.io.rw.poke(false.B)
      dut.io.en.poke(false.B)
      dut.io.addr.poke(0.U)
      dut.io.dataIn.poke(0.U)
      dut.io.so.poke(0.U)
      dut.io.sioOut.poke(0.U)

      dut.clock.step(10)

      dut.io.rw.poke(true.B)
      dut.io.en.poke(true.B)
      dut.io.addr.poke(0xABCDEF.U)
      dut.io.dataIn.poke(0x12345678)
      dut.io.sioOut.poke(0xA.U)
      dut.clock.step(34)

      dut.io.rst.poke(false.B)
      dut.io.rw.poke(false.B)
      dut.io.en.poke(false.B)
      dut.io.addr.poke(0.U)
      dut.io.dataIn.poke(0.U)
      dut.io.so.poke(0.U)
      dut.io.sioOut.poke(0.U)
      dut.clock.step(3)

      dut.io.en.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.addr.poke(0x123456.U)
      dut.clock.step()
      dut.io.en.poke(false.B)

      dut.clock.step(20)
    }
  }
}