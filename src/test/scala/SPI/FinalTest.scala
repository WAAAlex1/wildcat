import org.scalatest.flatspec.AnyFlatSpec
import chisel3._
import chiseltest._

class FinalTest extends AnyFlatSpec with ChiselScalatestTester {
    "SPI Controller" should "pass" in {
        test(new FinalTop).withAnnotations(Seq(WriteVcdAnnotation)) {dut =>
            dut.clock.setTimeout(0)
            dut.clock.step(100)
            
            // write something
            dut.io.rw.poke(true.B)
            dut.io.addrIn.poke(0xABCDEF.U)
            dut.io.dataIn.poke(0x12345678.U)
            dut.clock.step()
            dut.io.enable.poke(true.B)
            dut.clock.step(5)
            dut.io.enable.poke(false.B)
            dut.clock.step(100)

            // read
            dut.io.rw.poke(false.B)
            dut.io.addrIn.poke(0xFEDCBA.U)
            dut.io.readSize.poke(4.U)
            dut.clock.step()
            dut.io.enable.poke(true.B)
            dut.clock.step()
            dut.io.enable.poke(false.B)
            dut.clock.step(300)
        }
    }
}