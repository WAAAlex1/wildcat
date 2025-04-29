package ExtMemory

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import chisel3.util.experimental.BoringUtils
import SPICommands._

class PSRAM_ModelTestTop extends Module {
  val io = IO(new Bundle {
    val CS = Input(Bool())
    val IN = Input(UInt(4.W))
    val OUT = Output(UInt(4.W))

    // Debug outputs
    val command = Output(UInt(8.W))
    val address = Output(UInt(24.W))
    val mode = Output(UInt(1.W))
    val idle = Output(Bool())
    val state = Output(UInt(8.W))
    val readMemVal = Output(UInt(8.W))
    val val2Write = Output(UInt(8.W))
  })
  val model = Module(new PSRAM_Model(1024))
  io.OUT := model.io.OUT
  //io.dir := model.io.dir
  model.io.IN := io.IN
  model.io.CS := io.CS
  io.command := DontCare
  io.address := DontCare
  io.mode := DontCare
  io.idle := DontCare
  io.state := DontCare
  io.readMemVal := DontCare
  io.val2Write := DontCare
  BoringUtils.bore(model.command , Seq(io.command))
  BoringUtils.bore(model.address, Seq(io.address))
  BoringUtils.bore(model.mode, Seq(io.mode))
  BoringUtils.bore(model.stateReg, Seq(io.state))
  BoringUtils.bore(model.readMemVal, Seq(io.readMemVal))
  BoringUtils.bore(model.val2Write, Seq(io.val2Write))
}

class PSRAM_ModelTest extends AnyFlatSpec with ChiselScalatestTester {

  "PSRAM" should "change modes" in {
    test(new PSRAM_ModelTestTop).withAnnotations(Seq( WriteVcdAnnotation )) { dut =>
      def step(n: Int = 1) = {
        dut.clock.step(n)
      }
      def enable() = {
        dut.io.CS.poke(false.B)
      }
      def disable() = {
        dut.io.CS.poke(true.B)
      }

      def pokeInputSerial(value: UInt, bits: Int): Unit = {
        for (i <- 0 until bits - 1) {
          val bit = value(bits - 1 - i)
          dut.io.IN.poke(bit)
          step()
        }
        val bit = value(0)
        dut.io.IN.poke(bit)
      }

      def pokeInputQuad(value: UInt, nNibbles: Int): Unit = {
        for (i <- 0 until nNibbles-1) {
          val nibble = value(4*nNibbles - 1 - 4*i, 4*nNibbles - 4 - 4*i)
          dut.io.IN.poke(nibble)
          //println(f"Nibble: ${nibble}")
          step()
        }
        val nibble = value(3,0)
        //println(f"Nibble: ${nibble}")
        dut.io.IN.poke(nibble)
      }
      // Test enter quad mode
      disable()
      step(3)
      dut.io.state.expect(0.U) // idle
      enable()
      dut.io.mode.expect(0.U) // SPI mode
      pokeInputSerial(QUAD_MODE_ENABLE,8)
      dut.io.command.expect(QUAD_MODE_ENABLE)
      step()
      disable()
      step()
      dut.io.mode.expect(1.U) // QPI mode
      dut.io.state.expect(0.U) // idle


      // Test return to SPI mode
      step(3)
      enable()
      pokeInputQuad(QUAD_MODE_EXIT,2)
      step()
      disable()
      step()
      dut.io.mode.expect(0.U)
      dut.io.state.expect(0.U)


    }
  }

  "PSRAM" should "write and read" in {
    test(new PSRAM_ModelTestTop).withAnnotations(Seq( WriteVcdAnnotation ))  { dut =>
      def step(n: Int = 1) = {
        dut.clock.step(n)
      }

      def enable() = {
        dut.io.CS.poke(false.B)
      }

      def disable() = {
        dut.io.CS.poke(true.B)
      }

      def pokeInputSerial(value: UInt, bits: Int): Unit = {
        for (i <- 0 until bits - 1) {
          val bit = value(bits - 1 - i)
          dut.io.IN.poke(bit)
          step()
        }
        val bit = value(0)
        dut.io.IN.poke(bit)
      }

      def pokeInputQuad(value: UInt, nNibbles: Int): Unit = {
        for (i <- 0 until nNibbles - 1) {
          val nibble = value(4 * nNibbles - 1 - 4 * i, 4 * nNibbles - 4 - 4 * i)
          dut.io.IN.poke(nibble)
          println(f"Nibble: ${nibble}")
          step()
        }
        val nibble = value(3, 0)
        println(f"Nibble: ${nibble}")
        dut.io.IN.poke(nibble)
      }
      // Enter quad mode
      disable()
      step(3)
      dut.io.state.expect(0.U) // idle
      enable()
      dut.io.mode.expect(0.U) // SPI mode
      pokeInputSerial(QUAD_MODE_ENABLE, 8)
      dut.io.command.expect(QUAD_MODE_ENABLE)
      step()
      disable()
      step()
      dut.io.mode.expect(1.U) // QPI mode
      dut.io.state.expect(0.U) // idle

      // Test write
      step(3)
      enable()
      pokeInputQuad(QPI_WRITE,2)
      dut.io.command.expect(QPI_WRITE)
      step()
      dut.io.state.expect(1.U) // get address state
      pokeInputQuad(64.U,6)
      step()
      dut.io.state.expect(3.U) // write state
      dut.io.address.expect(64.U)
      pokeInputQuad("hAB".U,2)
      dut.io.val2Write.expect("hAB".U)
      step()
      dut.io.address.expect(65.U)
      pokeInputQuad("hBA".U,2)
      dut.io.val2Write.expect("hBA".U)
      step()
      disable()
      step()
      dut.io.state.expect(0.U) // idle

      // Test read
      step(3)
      enable()
      pokeInputQuad(QPI_FAST_QUAD_READ, 2)
      dut.io.command.expect(QPI_FAST_QUAD_READ)
      step()
      dut.io.state.expect(1.U) // get address state
      pokeInputQuad(64.U, 6)
      step()
      dut.io.state.expect(2.U) // read state
      step(8)
      dut.io.readMemVal.expect("hAB".U)
      dut.io.OUT.expect(10.U)
      step()
      dut.io.readMemVal.expect("hAB".U)
      dut.io.OUT.expect(11.U)
      dut.io.address.expect(65.U)
      step()
      dut.io.readMemVal.expect("hBA".U)
      dut.io.OUT.expect(11.U)
      step()
      dut.io.readMemVal.expect("hBA".U)
      dut.io.OUT.expect(10.U)
      step()
      dut.io.OUT.expect(0.U)
      step()
      disable()
      step()
      dut.io.state.expect(0.U)

    }
  }
}
