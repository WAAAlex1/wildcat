package extmemory

import extmemory.SPICommands._
import chisel3._
import chisel3.util.experimental.BoringUtils
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import wildcat.Util

class PSRAM_InstrModelTestTop(prescale: UInt) extends Module {
  val io = IO(new Bundle {
    val CS = Input(Bool())
    val IN = Input(UInt(4.W))
    val OUT = Output(UInt(4.W))

    // Debug outputs
    val command = Output(UInt(8.W))
    val address = Output(UInt(24.W))
    val mode = Output(UInt(2.W))
    val idle = Output(Bool())
    val state = Output(UInt(8.W))
    val readMemVal = Output(UInt(8.W))
    val val2Write = Output(UInt(8.W))
  })

  val clkReg = RegInit(false.B)
  val CNT_MAX = (1.U << prescale)
  val cntClk = RegInit(0.U(33.W))
  when (prescale === 0.U) {
    cntClk := cntClk + 1.U
    when (cntClk === CNT_MAX) {
      cntClk := 0.U
      clkReg := !clkReg
    }
  } .otherwise {
    clkReg := !clkReg
  }

  val (memory, start) = Util.getCode("risc-v-lab/tests/simple/addpos.bin")

  withClock(clkReg.asClock) {
    val model = Module(new PSRAM_InstrModel(1024,memory))


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
    BoringUtils.bore(model.command, Seq(io.command))
    BoringUtils.bore(model.address, Seq(io.address))
    BoringUtils.bore(model.mode, Seq(io.mode))
    BoringUtils.bore(model.stateReg, Seq(io.state))
    BoringUtils.bore(model.readMemVal, Seq(io.readMemVal))
    BoringUtils.bore(model.lastRead, Seq(io.val2Write))
  }
}

class PSRAM_InstrModelTest extends AnyFlatSpec with ChiselScalatestTester {
  val prescale = 1
  "PSRAM" should "change modes" in {

    test(new PSRAM_InstrModelTestTop(prescale.asUInt)).withAnnotations(Seq( WriteVcdAnnotation )) { dut =>
      def step(n: Int = 1) = {
        dut.clock.step(n << prescale)
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


      // Test wrap toggle
      step(3)
      enable()
      pokeInputQuad(WRAP_BOUNDARY_TOGGLE,2)
      step()
      disable()
      step()
      dut.io.mode.expect(3.U)
      dut.io.state.expect(0.U)


    }
  }

  "PSRAM" should "write and read" in {
    test(new PSRAM_InstrModelTestTop(prescale.asUInt)).withAnnotations(Seq( WriteVcdAnnotation ))  { dut =>
      def step(n: Int = 1) = {
        dut.clock.step(n << prescale)
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
          //println(f"Nibble: ${nibble}")
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


      // Test read
      step(3)
      enable()
      pokeInputQuad(QPI_FAST_QUAD_READ, 2)
      dut.io.command.expect(QPI_FAST_QUAD_READ)
      step()
      pokeInputQuad(0.U, 6)
      dut.io.state.expect(1.U) // get address state
      step(2)
      dut.io.state.expect(2.U) // read state
      step(6)
      dut.io.readMemVal.expect("h13".U)
      dut.io.OUT.expect(0x1.U)
      step()
      dut.io.readMemVal.expect("h13".U)
      dut.io.OUT.expect(0x3.U)
      dut.io.address.expect(1.U)
      step()
      dut.io.readMemVal.expect("h05".U)
      dut.io.OUT.expect(0x0.U)
      step()
      dut.io.readMemVal.expect("h05".U)
      dut.io.OUT.expect(0x5.U)
      dut.io.address.expect(2.U)
      step()
      dut.io.readMemVal.expect("h50".U)
      dut.io.OUT.expect(0x5.U)
      step()
      dut.io.readMemVal.expect("h50".U)
      dut.io.OUT.expect(0x0.U)
      disable()
      step()
      dut.io.state.expect(0.U)


      // Test write
      step(3)
      enable()
      pokeInputQuad(QPI_WRITE,2)
      dut.io.command.expect(QPI_WRITE)
      step()
      pokeInputQuad(64.U,6)
      dut.io.state.expect(1.U) // get address state

      step()
      pokeInputQuad("hAB".U,2)
      dut.io.state.expect(3.U) // write state

      step()
      dut.io.val2Write.expect("hAB".U)
      pokeInputQuad("hBA".U,2)

      dut.io.address.expect(65.U)
      step()
      dut.io.val2Write.expect("hBA".U)
      step()
      disable()
      step()
      dut.io.state.expect(0.U) // idle

      // Test read after write
      step(3)
      enable()
      pokeInputQuad(QPI_FAST_QUAD_READ, 2)
      dut.io.command.expect(QPI_FAST_QUAD_READ)
      step()
      pokeInputQuad(64.U, 6)
      dut.io.state.expect(1.U) // get address state

      step(2)
      dut.io.state.expect(2.U) // read state
      step(6)
      dut.io.readMemVal.expect("hAB".U)
      dut.io.OUT.expect(0xA.U)
      step()
      dut.io.readMemVal.expect("hAB".U)
      dut.io.OUT.expect(0xB.U)
      dut.io.address.expect(65.U)
      step()
      //dut.io.readMemVal.expect("hBA".U)
      //dut.io.OUT.expect(0xB.U)
      step()
      dut.io.readMemVal.expect("hBA".U)
      dut.io.OUT.expect(0xA.U)
      step()
      dut.io.OUT.expect(0.U)
      step()
      disable()
      step()
      dut.io.state.expect(0.U)

    }
  }


}
