package Caches.SimpleCache

import chisel3._
import chisel3.util.experimental.BoringUtils
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class CacheControllerTester(blockSize: Int) extends Module {
  val io = IO(new Bundle {
    // Input/output to/from Wildcat
    val validReq = Input(Bool())
    val rw = Input(Bool())
    val memAdd = Input(UInt(32.W))
    val CPUdataIn = Input(UInt(32.W))
    val CPUdataOut = Output(UInt(32.W))
    val stall = Output(Bool())
    val cacheInvalid = Output(Bool())
    val ready = Output(Bool())
    val wrEnable = Input(Vec(4, Bool()))

    // Input/output to/from external memory via bus
    val memDataIn = Input(UInt(32.W))
    val memReady = Input(Bool())
    val alloAddr = Output(UInt(32.W))
    val memReq = Output(UInt(2.W)) // 0: no request, 1: allocation request, 2: write-through

    //Debugging
    val cacheDO = Output(UInt(32.W))
    val state = Output(UInt(2.W))
    val actualTag = Output(UInt(32.W))
    val targetTag = Output(UInt(32.W))
  })
  val controller = Module(new CacheController(blockSize))
  controller.io.validReq := io.validReq
  controller.io.rw := io.rw
  controller.io.memAdd := io.memAdd
  controller.io.CPUdataIn := io.CPUdataIn
  io.CPUdataOut := controller.io.CPUdataOut
  io.stall := controller.io.stall
  io.cacheInvalid := DontCare
  io.ready := controller.io.ready
  controller.io.wrEnable := io.wrEnable
  controller.io.memDataIn := io.memDataIn
  controller.io.memReady := io.memReady
  io.alloAddr := controller.io.alloAddr
  io.memReq := controller.io.memReq

  io.cacheDO := DontCare
  io.state := DontCare
  io.targetTag := DontCare
  io.actualTag := DontCare

  BoringUtils.bore(controller.cache.io.DO,Seq(io.cacheDO))
  BoringUtils.bore(controller.stateReg,Seq(io.state))
  BoringUtils.bore(controller.cacheInvalid,Seq(io.cacheInvalid))
  BoringUtils.bore(controller.targetTag, Seq(io.targetTag))
  BoringUtils.bore(controller.actualTag, Seq(io.actualTag))
}

class CacheControllerTest extends AnyFlatSpec with ChiselScalatestTester {
  def pokeVecBool(vec: Vec[Bool], value: Int): Unit = {
    for (i <- 0 until vec.length) {
      vec(i).poke(((value >> i) & 1).B)
    }
  }


  val blockSize = 4


  "Controller" should "init" in {
    test(new CacheControllerTester(blockSize)) { dut =>
      dut.io.ready.expect(true.B)

    }
  }
  "Controller" should "miss" in {
    test(new CacheControllerTester(blockSize)){ dut =>
      dut.io.memAdd.poke(0.U)
      dut.io.validReq.poke(true.B)
      dut.clock.step()
      dut.io.ready.expect(false.B)
      dut.io.stall.expect(true.B)
    }
  }
  "Controller" should "be invalid" in {
    test(new CacheControllerTester(blockSize)) { dut =>
      dut.io.memAdd.poke(0.U)
      dut.io.CPUdataIn.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.cacheInvalid.expect(true.B)

    }
  }
  "Controller" should "be valid" in {
    test(new CacheControllerTester(blockSize)) { dut =>
      dut.io.memAdd.poke(0.U)
      dut.io.CPUdataIn.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.stall.expect(true.B)
      dut.io.memReady.poke(true.B)
      dut.clock.step(blockSize + 1)
      dut.io.cacheInvalid.expect(false.B)
    }
  }
  "Controller" should "hit" in {
    test(new CacheControllerTester(blockSize)) { dut =>
      dut.io.memAdd.poke(0.U)
      dut.io.CPUdataIn.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.clock.step()

      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.stall.expect(true.B)
      dut.io.cacheInvalid.expect(true.B)
      dut.io.memReady.poke(true.B)
      dut.clock.step(blockSize + 1)
      dut.io.cacheInvalid.expect(false.B)
      dut.io.stall.expect(false.B)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)

    }
  }
  "Controller" should "write" in {
    test(new CacheControllerTester(blockSize)) { dut =>
      dut.io.memAdd.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.CPUdataIn.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.stall.expect(true.B)
      dut.io.cacheInvalid.expect(true.B)
      dut.io.memReady.poke(true.B)
      dut.clock.step(blockSize + 1)
      dut.io.cacheInvalid.expect(false.B)
      dut.io.stall.expect(false.B)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)
    }
  }
  "Controller" should "read" in {
    test(new CacheControllerTester(blockSize)) { dut =>
      dut.io.memAdd.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.CPUdataIn.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.stall.expect(true.B)
      dut.io.cacheInvalid.expect(true.B)
      dut.io.memReady.poke(true.B)
      dut.clock.step(blockSize + 1)
      dut.io.cacheInvalid.expect(false.B)
      dut.io.stall.expect(false.B)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.rw.poke(true.B)
      dut.io.validReq.poke(true.B)
      dut.clock.step()
      dut.io.cacheInvalid.expect(false.B)
      dut.io.stall.expect(false.B)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.CPUdataOut.expect(42.U)

    }
  }
  "Controller" should "read (other word in block)" in {
    test(new CacheControllerTester(blockSize)) { dut =>
      dut.io.memDataIn.poke(0.U)
      dut.io.memAdd.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.CPUdataIn.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)

      dut.clock.step()

      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.stall.expect(true.B)
      dut.io.cacheInvalid.expect(true.B)
      dut.io.memReady.poke(true.B)

      dut.clock.step(blockSize + 1)

      dut.io.cacheInvalid.expect(false.B)
      dut.io.stall.expect(false.B)

      dut.clock.step(3)
      dut.io.ready.expect(true.B)
      dut.clock.step()

      dut.io.ready.expect(true.B)
      dut.io.CPUdataIn.poke(2.U)
      dut.io.rw.poke(false.B)
      dut.io.memAdd.poke("b1000".U)
      dut.io.validReq.poke(true.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.io.cacheInvalid.expect(false.B)
      dut.io.stall.expect(false.B)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)

      // Read new values in every cycle
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(true.B)
      dut.io.memAdd.poke("b0000".U)
      dut.clock.step()
      dut.io.stall.expect(false.B)
      dut.io.memAdd.poke("b1000".U)
      dut.io.CPUdataOut.expect(42.U)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.CPUdataOut.expect(2.U)
      dut.io.memAdd.poke("b100".U)
      dut.clock.step()
      dut.io.state.expect(1.U)
      dut.io.stall.expect(false.B)
      dut.io.CPUdataOut.expect(0.U)
      dut.io.memAdd.poke("h10000000".U)
      dut.io.stall.expect(true.B)
      dut.clock.step()
      dut.io.stall.expect(false.B)
      dut.io.CPUdataOut.expect(0.U)


    }
  }

  "Controller" should "be invalid (new block)" in {
    test(new CacheControllerTester(blockSize)) { dut =>

      dut.io.memAdd.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.CPUdataIn.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.stall.expect(true.B)
      dut.io.cacheInvalid.expect(true.B)
      dut.io.memReady.poke(true.B)

      dut.clock.step(blockSize + 1)

      dut.io.cacheInvalid.expect(false.B)
      dut.io.stall.expect(false.B)

      dut.clock.step(2)
      dut.io.ready.expect(true.B)

      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.rw.poke(true.B)
      dut.io.memAdd.poke(blockSize << 2)
      dut.io.validReq.poke(true.B)
      dut.clock.step()
      dut.io.cacheInvalid.expect(true.B)
    }
  }

  "Controller" should "allocate" in {
    test(new CacheControllerTester(blockSize)) { dut =>
      // Write 42, 21, 0, 0 to first block in cache
      // physical addresses 0, 4, 8, 12 (hex: 0, 4, 8, C)
      // Binary (0000, 0100, 1000, 1100)
      dut.io.memDataIn.poke(0.U)
      dut.io.memAdd.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.CPUdataIn.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(true.B)

      dut.clock.step(blockSize + 4)

      dut.io.ready.expect(true.B)
      dut.io.CPUdataIn.poke(21.U)
      dut.io.memAdd.poke("b100".U)
      dut.clock.step(3)
      dut.io.ready.expect(true.B)

      // Write 2,0,0,0 to first block (same index should overwrite current index in cache)
      // Physical addresses 256, 260, 264, 268 (hex: 100, 104, 108, 10C)
      // (bin: 0001_0000_0000, 0001_0000_0100, 0001_0000_1000, 0001_0000_1100)
      dut.io.CPUdataIn.poke(2.U)
      dut.io.memAdd.poke("h1000".U)
      dut.clock.step()
      dut.io.state.expect(1.U) //Compare tag State
      dut.io.cacheInvalid.expect(false.B) // Cache valid because of current block
      dut.io.targetTag.expect(1.U)
      dut.io.actualTag.expect(0.U)
      dut.io.stall.expect(true.B) // cache miss => overwrite block
      dut.clock.step(blockSize + 3)
      dut.io.ready.expect(true.B)
      dut.io.rw.poke(true.B)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)
      dut.io.CPUdataOut.expect(2.U)

      // Read original address again => overwrite block
      dut.io.memDataIn.poke(42.U) // simulate allocation
      dut.io.memAdd.poke(0.U)
      dut.io.validReq.poke(true.B)
      dut.clock.step(3)
      dut.io.memDataIn.poke(21.U)
      dut.clock.step()
      dut.io.memDataIn.poke(0.U)
      dut.clock.step(blockSize - 1)
      dut.io.ready.expect(true.B)
      dut.io.CPUdataOut.expect(42.U)

      // Read second and third word in block
      dut.io.memAdd.poke("b100".U)
      dut.clock.step()
      dut.io.CPUdataOut.expect(21.U)
      dut.io.memAdd.poke("b1000".U)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.CPUdataOut.expect(0.U)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)
      dut.io.CPUdataOut.expect(0.U)


      // Allocate, overwrites yet index again
      dut.io.memDataIn.poke(2.U)
      dut.io.memAdd.poke("h1000".U)
      dut.clock.step(3)
      dut.io.memDataIn.poke(0.U)
      dut.clock.step(blockSize)
      dut.io.ready.expect(true.B)
      dut.io.CPUdataOut.expect(2.U)

      // Read second word in block
      dut.io.memAdd.poke("h1004".U)
      dut.clock.step()
      dut.io.CPUdataOut.expect(0.U)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.CPUdataOut.expect(0.U)

    }
  }
}
