package Caches.SimpleCache

import Caches.SimpleCache.CacheFunctions._
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec



class CacheTopTest extends AnyFlatSpec with ChiselScalatestTester {

  "CacheTop" should "init" in {
    test(new CacheTop) { dut =>
      dut.io.stall.expect(false.B)

    }
  }
  "CacheTop" should "sw and lw" in {
    test(new CacheTop) { dut =>
      dut.io.stall.expect(false.B)
      dut.io.rdEnable.poke(false.B)
      dut.io.wrAddress.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 15)
      dut.io.wrData.poke("hCAFEBABE".U)
      dut.clock.step(1)
      dut.io.stall.expect(true.B) // miss / invalid
      dut.clock.step(5)
      dut.io.stall.expect(false.B) // hit after allocate
      dut.io.rdData.expect(0.U) // Reading before write
      dut.clock.step(2) // Controller should be idle after writing
      dut.io.stall.expect(false.B)

      // Try to read written word
      dut.io.rdAddress.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 0)
      dut.io.rdEnable.poke(true.B)
      dut.clock.step()
      dut.io.stall.expect(false.B)
      dut.clock.step()
      dut.io.rdData.expect("hCAFEBABE".U)

      // Try to read next word (non modified)
      dut.io.rdAddress.poke(4.U)
      pokeVecBool(dut.io.wrEnable, 0)
      dut.io.rdEnable.poke(true.B)
      dut.clock.step()
      dut.io.stall.expect(false.B)
      dut.clock.step()
      dut.io.rdData.expect(0.U)
    }
  }

  "CacheTop" should "sh and lh" in {
    test(new CacheTop) { dut =>
      dut.io.stall.expect(false.B)
      dut.io.rdEnable.poke(false.B)
      dut.io.wrAddress.poke(2.U)
      pokeVecBool(dut.io.wrEnable, 12)
      dut.io.wrData.poke("hBABEBABE".U)
      dut.clock.step()
      dut.io.stall.expect(true.B) // miss / invalid
      dut.clock.step(5)
      dut.io.stall.expect(false.B) // hit after allocate
      dut.io.rdData.expect(0.U) // Reading before write
      dut.clock.step(2) // cachetop should be idle after writing
      dut.io.stall.expect(false.B)

      // Try to read written word
      dut.io.rdAddress.poke(0.U)
      pokeVecBool(dut.io.wrEnable, 0)
      dut.io.rdEnable.poke(true.B)
      dut.clock.step()
      dut.io.stall.expect(false.B)
      dut.clock.step()
      dut.io.rdData.expect("hBABE0000".U)

      // Try to read next word (non modified)
      dut.io.rdAddress.poke(4.U)
      pokeVecBool(dut.io.wrEnable, 0)
      dut.io.rdEnable.poke(true.B)
      dut.clock.step()
      dut.io.stall.expect(false.B)
      dut.clock.step()
      dut.io.rdData.expect(0.U)
    }
  }

  "CacheTop" should "sb and lb" in {
    test(new CacheTop) { dut =>
      dut.io.stall.expect(false.B)
      dut.io.rdEnable.poke(false.B)
      dut.io.wrAddress.poke(0.U)
      pokeVecBool(dut.io.wrEnable,4)
      dut.io.wrData.poke("hAAAAAAAA".U)
      dut.clock.step(1)
      dut.io.stall.expect(true.B) // miss / invalid
      dut.clock.step(5)
      dut.io.stall.expect(false.B) // hit after allocate
      dut.io.rdData.expect(0.U) // Reading before write
      dut.clock.step(2) // cachetop should be idle after writing
      dut.io.stall.expect(false.B)

      // Try to read written word
      dut.io.rdAddress.poke(0.U)
      pokeVecBool(dut.io.wrEnable,0)
      dut.io.rdEnable.poke(true.B)
      dut.clock.step()
      dut.io.stall.expect(false.B)
      dut.clock.step()
      dut.io.rdData.expect("hAA0000".U)

      // Try to read next word (non modified)
      dut.io.rdAddress.poke(4.U)
      pokeVecBool(dut.io.wrEnable, 0)
      dut.io.rdEnable.poke(true.B)
      dut.clock.step()
      dut.io.stall.expect(false.B)
      dut.clock.step()
      dut.io.rdData.expect(0.U)
    }
  }
}