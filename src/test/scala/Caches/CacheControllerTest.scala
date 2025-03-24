package Caches.SimpleCache

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class CacheControllerTest extends AnyFlatSpec with ChiselScalatestTester {
  def pokeVecBool(vec: Vec[Bool], value: Int): Unit = {
    for (i <- 0 until vec.length) {
      vec(i).poke(((value >> i) & 1).B)
    }
  }

  "Controller" should "init" in {
    test(new CacheController) { dut =>
      dut.io.ready.expect(true.B)

    }
  }
  "Controller" should "miss" in {
    test(new CacheController){ dut =>
      dut.io.memAdd.poke(0.U)
      dut.io.validReq.poke(true.B)
      dut.clock.step()
      dut.io.ready.expect(false.B)
      dut.io.cacheMiss.expect(true.B)
    }
  }
  "Controller" should "be invalid" in {
    test(new CacheController) { dut =>
      dut.io.memAdd.poke(0.U)
      dut.io.DI.poke(42.U)
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
    test(new CacheController) { dut =>
      dut.io.memAdd.poke(0.U)
      dut.io.DI.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.cacheMiss.expect(true.B)
      dut.io.memReady.poke(true.B)
      dut.clock.step(5)
      dut.io.cacheInvalid.expect(false.B)
    }
  }
  "Controller" should "hit" in {
    test(new CacheController) { dut =>
      dut.io.memAdd.poke(0.U)
      dut.io.DI.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.clock.step()

      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.cacheMiss.expect(true.B)
      dut.io.cacheInvalid.expect(true.B)
      dut.io.memReady.poke(true.B)
      dut.clock.step(5)
      dut.io.cacheInvalid.expect(false.B)
      dut.io.cacheMiss.expect(false.B)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)

    }
  }
  "Controller" should "write" in {
    test(new CacheController) { dut =>
      dut.io.memAdd.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.DI.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.cacheMiss.expect(true.B)
      dut.io.cacheInvalid.expect(true.B)
      dut.io.memReady.poke(true.B)
      dut.clock.step(5)
      dut.io.cacheInvalid.expect(false.B)
      dut.io.cacheMiss.expect(false.B)
      dut.io.modData.expect(42.U)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)
    }
  }
  "Controller" should "read" in {
    test(new CacheController) { dut =>
      dut.io.memAdd.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.DI.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.cacheMiss.expect(true.B)
      dut.io.cacheInvalid.expect(true.B)
      dut.io.memReady.poke(true.B)
      dut.clock.step(5)
      dut.io.cacheInvalid.expect(false.B)
      dut.io.cacheMiss.expect(false.B)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.rw.poke(true.B)
      dut.io.validReq.poke(true.B)
      dut.clock.step()
      dut.io.cacheInvalid.expect(false.B)
      dut.io.cacheMiss.expect(false.B)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.DO.expect(42.U)

    }
  }
  "Controller" should "read (other word in block)" in {
    test(new CacheController) { dut =>
      dut.io.memAdd.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.DI.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)

      dut.clock.step()

      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.cacheMiss.expect(true.B)
      dut.io.cacheInvalid.expect(true.B)
      dut.io.memReady.poke(true.B)

      dut.clock.step(5)

      dut.io.cacheInvalid.expect(false.B)
      dut.io.cacheMiss.expect(false.B)

      dut.clock.step(3)
      dut.io.ready.expect(true.B)

      dut.io.DI.poke(2.U)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memAdd.poke("b1000".U)
      dut.io.validReq.poke(true.B)
      dut.clock.step()

      dut.io.cacheInvalid.expect(false.B)
      dut.io.cacheMiss.expect(false.B)

      dut.clock.step(2)
      dut.io.ready.expect(true.B)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(true.B)

      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.DO.expect(2.U)
      dut.io.memAdd.poke("b0000".U)
      dut.io.validReq.poke(true.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.DO.expect(42.U)
      dut.io.memAdd.poke("b100".U)
      dut.io.validReq.poke(true.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.DO.expect(0.U)
    }
  }

  "Controller" should "be invalid (new block)" in {
    test(new CacheController) { dut =>
      dut.io.memAdd.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.DI.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(false.B)
      dut.clock.step()
      dut.io.validReq.poke(false.B)
      dut.io.ready.expect(false.B)
      dut.io.cacheMiss.expect(true.B)
      dut.io.cacheInvalid.expect(true.B)
      dut.io.memReady.poke(true.B)

      dut.clock.step(5)

      dut.io.cacheInvalid.expect(false.B)
      dut.io.cacheMiss.expect(false.B)

      dut.clock.step(2)
      dut.io.ready.expect(true.B)

      dut.clock.step()
      dut.io.ready.expect(true.B)
      dut.io.rw.poke(true.B)
      dut.io.memAdd.poke("b10000".U)
      dut.io.validReq.poke(true.B)
      dut.clock.step()
      dut.io.cacheInvalid.expect(true.B)
    }
  }

  "Controller" should "allocate" in {
    test(new CacheController) { dut =>
      dut.io.memAdd.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.DI.poke(42.U)
      dut.io.validReq.poke(true.B)
      dut.io.rw.poke(false.B)
      dut.io.memReady.poke(true.B)

      dut.clock.step(8)

      dut.io.ready.expect(true.B)
      dut.io.DI.poke(21.U)
      dut.io.memAdd.poke("b100".U)
      dut.clock.step()

      dut.clock.step()

      dut.clock.step()
      dut.io.ready.expect(true.B)

      dut.io.DI.poke(2.U)
      dut.io.memAdd.poke("h1000".U) // New memory, same index (should overwrite current index)
      dut.clock.step(8)
      dut.io.ready.expect(true.B)
      dut.io.rw.poke(true.B)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)
      dut.io.DO.expect(2.U)

      dut.io.memAdd.poke(0.U)
      dut.io.validReq.poke(true.B)
      dut.clock.step(7)

      dut.io.ready.expect(true.B)
      dut.io.DO.expect(42.U)
      dut.io.memAdd.poke("b100".U)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)
      dut.io.DO.expect(21.U)
      dut.io.memAdd.poke("b1000".U)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)
      dut.io.DO.expect(0.U)
      dut.io.memAdd.poke("h1000".U)
      dut.clock.step(7)
      dut.io.ready.expect(true.B)
      dut.io.DO.expect(2.U)
      dut.io.memAdd.poke("h1004".U)
      dut.clock.step(2)
      dut.io.ready.expect(true.B)
      dut.io.DO.expect(0.U)

    }
  }
}
