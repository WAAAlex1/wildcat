package ExtMemory


import chisel3._
import chisel3.experimental._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec


class IOBufferTestWrapper extends Module {
  val io = IO(new Bundle {
    val dataIn  = Input(UInt(1.W))  // Direct UInt input (test poke)
    val dataOut = Output(UInt(1.W)) // Direct UInt output (test peek)
    val dir     = Input(Bool())     // Direction control
  })

  val iobuf = Module(new IOBuffer)

  val analogWire = Wire(Analog(1.W))
  attach(iobuf.io.data, analogWire)

  iobuf.io.dir := io.dir
  iobuf.io.out := io.dataIn

  // Read the value from the Analog line
  io.dataOut := analogWire.asUInt
}


class IOBufferTest extends AnyFlatSpec with ChiselScalatestTester {
  "Buffer" should "write and read" in {
    test(new IOBufferTestWrapper) { dut =>
      // Test as Output
      dut.io.dir.poke(1.B)
      dut.io.dataIn.poke(1.U)
      dut.clock.step()
      dut.io.dataOut.expect(1.U)

      // Test as Input
      dut.io.dir.poke(0.B)
      dut.clock.step(1)
      dut.io.dataOut.expect(0.U)

    }
  }
}
