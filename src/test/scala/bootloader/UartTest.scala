package bootloader

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import wildcat.explore.UartTop

/**
 * Quick UART test when no ready is asserted from the module
 */
class UartTest extends AnyFlatSpec with
  ChiselScalatestTester {
  "Uart" should "create vcd for insight" in {
    test(new UartTop())
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val BIT_CNT = ((10000000 + 115200 / 2) / 115200 - 1)

        def preByteProtocol() = {
          dut.io.rx.poke(1.U)
          dut.clock.step(BIT_CNT)
          dut.io.rx.poke(0.U)
          dut.clock.step(BIT_CNT)
        }

        def sendByte(n: UInt) = {
          preByteProtocol()

          for (j <- 0 until 8) { //0 until 8 means it runs from 0 to and with 7
            dut.io.rx.poke(n(j))
            dut.clock.step(BIT_CNT)
          }
        }

        def send32bit(n: UInt) = {
          sendByte(n(7, 0))
          sendByte(n(15, 8))
          sendByte(n(23, 16))
          sendByte(n(31, 24))
        }

        send32bit("h12345678".U)


    }
  }
}