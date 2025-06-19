package wildcat

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import wildcat.pipeline.WildcatTopPhysical

class WildcatTopPhysicalDataTest() extends AnyFlatSpec with
  ChiselScalatestTester {
  "Wildcat" should "Write Word to Memory" in {
    test(new WildcatTopPhysical(5000000))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
        val BIT_CNT = ((5000000 + 115200 / 2) / 115200 - 1)

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

        //Send to memory mapped address for sleep
        val bootSleepAddr = "hF1000000".U

//        send32bit("h00000000".U) //First send address
//        send32bit("h00108093".U) //Then send the instruction (addi x1, x1, 1)
//        //dut.io.led.expect(0.U) // should fail always
//
//        send32bit("h00000004".U) //First send address
//        send32bit("hffdff06f".U) //Then send the instruction (jal x0, -4)
//        //dut.io.led.expect(0.U) // should fail always


        //Send the ZSBL_demo.bin file:
        send32bit("h00000000".U) //First send address
        send32bit("hf00102b7".U)

        send32bit("h00000004".U) //First send address
        send32bit("h03300313".U)

        send32bit("h00000008".U) //First send address
        send32bit("h00628023".U)

        send32bit("h0000000c".U) //First send address
        send32bit("h00ff0137".U)

        send32bit("h00000010".U) //First send address
        send32bit("h003002b7".U)

        send32bit("h00000014".U) //First send address
        send32bit("h30529073".U)

        send32bit("h00000018".U) //First send address
        send32bit("h10000293".U)

        send32bit("h0000001c".U) //First send address
        send32bit("h00028067".U)

        send32bit("h00000020".U) //First send address
        send32bit("h00000013".U)

        send32bit("h00000024".U) //First send address
        send32bit("h00000013".U)

        send32bit("h00000028".U) //First send address
        send32bit("h00000013".U)

        send32bit("h0000002c".U) //First send address
        send32bit("h00000013".U)

        send32bit("h00000030".U) //First send address
        send32bit("hf00102b7".U)

        send32bit("h00000034".U) //First send address
        send32bit("h08800313".U)

        send32bit("h00000038".U) //First send address
        send32bit("h00628023".U)

        //Now send memory mapped IO for setting bootloader to sleep
        send32bit(bootSleepAddr)
        send32bit("h00000001".U) //Sleep command data
        //dut.io.led.expect(0.U) // should fail always
        //Should be asleep now

        dut.clock.step(1000)
        //dut.io.led.expect(1.U) // should fail always

        // Investigate X1 after test has run.

        // Test will never show any instructions being ran as SPI controller not connected to mem
        // Hence no instructions can later be read.
      }
  }
}
