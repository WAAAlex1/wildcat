package wildcat

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import wildcat.pipeline.WildcatTopPhysical

/**
 * Test of the bootloader in the physical wildcat top
 */
class WildcatTopPhysicalTest(Ignore: String) extends AnyFlatSpec with
  ChiselScalatestTester {
  "Wildcat" should "Set LED's high and unstall" in {
    test(new WildcatTopPhysical(10000000))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
        val BIT_CNT = ((10000000 + 115200 / 2) / 115200 - 1)

        //Start protocol
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

        //Little endian
        def send32bit(n: UInt) = {
          sendByte(n(7, 0))
          sendByte(n(15, 8))
          sendByte(n(23, 16))
          sendByte(n(31, 24))
        }


        //Send to memory mapped address for LED
        val ledAddr = "hF0010000".U
        val bootSleepAddr = "hF1000000".U

        send32bit(ledAddr) //First send address
        send32bit("h000000FF".U) //Then send the LED data
        dut.io.led.expect("h80FF".U) //The first byte is constant, lsb byte is our LED data

        //Now send memory mapped IO for setting bootloader to sleep
        send32bit(bootSleepAddr)
        send32bit("h00000001".U) //Sleep command data
        //Should be asleep now

        //Try to change LED io now but nothing should happen:
        send32bit(ledAddr) //First send address
        send32bit("h00000000".U) //Then send the LED data
        dut.io.led.expect("h80FF".U) //The first byte is constant, lsb byte is our LED data
    }
  }
}


