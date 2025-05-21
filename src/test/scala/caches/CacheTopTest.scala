package caches.simple

import caches.simple.CacheFunctions._
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import caravan.bus.tilelink._
import chisel3.util.Decoupled
import chisel3.util.experimental.BoringUtils
import wildcat.pipeline.MemIO


class CacheTopTester(blockSize: Int)(implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    // Input from wildcat
    val CPUmemIO = Flipped(new MemIO())

    // IO to/from TL adapter

    val CacheReqOut = Decoupled((new TLRequest()))
    val CacheRspIn = Flipped(Decoupled((new TLResponse())))

    // Debugging
    val memReq = Output(UInt(2.W))
  })
  val Cache = Module(new CacheTop(blockSize))
  Cache.io.CPUmemIO <> io. CPUmemIO
  io.CacheReqOut <> Cache.io.CacheReqOut
  Cache.io.CacheRspIn <> io.CacheRspIn


  io.memReq := DontCare
  BoringUtils.bore(Cache.Controller.io.memReq , Seq(io.memReq))
}

class CacheTopTest extends AnyFlatSpec with ChiselScalatestTester {
  implicit val config = TilelinkConfig()

  val blockSize = 4

  "CacheTop" should "init" in {
    test(new CacheTopTester(blockSize)) { dut =>
      dut.io.CPUmemIO.stall.expect(false.B)

    }
  }
  "CacheTop" should "sw and lw" in {
    test(new CacheTopTester(blockSize)) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      dut.io.CacheRspIn.valid.poke(true.B)
      dut.io.CPUmemIO.stall.expect(false.B)
      dut.io.CPUmemIO.rdEnable.poke(false.B)
      dut.io.CPUmemIO.wrAddress.poke(0.U)
      pokeVecBool(dut.io.CPUmemIO.wrEnable, 15)
      dut.io.CPUmemIO.wrData.poke("hCAFEBABE".U)
      step(1)
      dut.io.CPUmemIO.stall.expect(true.B) // miss / invalid
      step()
      dut.io.memReq.expect(1.U) // Allocate
      dut.io.CacheReqOut.valid.expect(true.B)
      dut.io.CacheReqOut.bits.isWrite.expect(false.B)
      dut.io.CacheReqOut.bits.addrRequest.expect(0.U)
      dut.io.CacheReqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.memReq.expect(1.U) // Allocate
      dut.io.CacheReqOut.valid.expect(true.B)
      dut.io.CacheReqOut.bits.isWrite.expect(false.B)
      dut.io.CacheReqOut.bits.addrRequest.expect(4.U)
      dut.io.CacheReqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.memReq.expect(1.U) // Allocate
      dut.io.CacheReqOut.valid.expect(true.B)
      dut.io.CacheReqOut.bits.isWrite.expect(false.B)
      dut.io.CacheReqOut.bits.addrRequest.expect(8.U)
      dut.io.CacheReqOut.bits.activeByteLane.expect(15.U)
      step()
      dut.io.memReq.expect(1.U) // Allocate
      dut.io.CacheReqOut.valid.expect(true.B)
      dut.io.CacheReqOut.bits.isWrite.expect(false.B)
      dut.io.CacheReqOut.bits.addrRequest.expect(12.U)
      dut.io.CacheReqOut.bits.activeByteLane.expect(15.U)
      step(blockSize - 3)
      dut.io.CPUmemIO.stall.expect(true.B) // hit after allocate, but stall since cache is busy
      dut.io.CPUmemIO.rdData.expect(0.U) // Reading before write
      step()
      dut.io.memReq.expect(2.U) //Write through
      dut.io.CacheReqOut.valid.expect(true.B)
      dut.io.CacheReqOut.bits.isWrite.expect(true.B)
      dut.io.CacheReqOut.bits.addrRequest.expect(0.U)
      dut.io.CacheReqOut.bits.dataRequest.expect("hCAFEBABE".U)
      dut.io.CacheReqOut.bits.activeByteLane.expect(15.U)
      step(2)
      dut.io.CPUmemIO.stall.expect(false.B)

      // Try to read written word
      dut.io.CPUmemIO.rdAddress.poke(0.U)
      pokeVecBool(dut.io.CPUmemIO.wrEnable, 0)
      dut.io.CPUmemIO.rdEnable.poke(true.B)
      step()
      dut.io.CPUmemIO.stall.expect(false.B)
      dut.io.CPUmemIO.rdData.expect("hCAFEBABE".U)
      step()

      // Try to read next word (non modified)
      dut.io.CPUmemIO.rdAddress.poke(4.U)
      pokeVecBool(dut.io.CPUmemIO.wrEnable, 0)
      dut.io.CPUmemIO.rdEnable.poke(true.B)
      step()
      dut.io.CPUmemIO.stall.expect(false.B)
      dut.io.CPUmemIO.rdData.expect(0.U)
    }
  }

  "CacheTop" should "sh and lh" in {
    test(new CacheTopTester(blockSize)) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      dut.io.CacheRspIn.valid.poke(true.B)
      dut.io.CPUmemIO.stall.expect(false.B)
      dut.io.CPUmemIO.rdEnable.poke(false.B)
      dut.io.CPUmemIO.wrAddress.poke(2.U)
      pokeVecBool(dut.io.CPUmemIO.wrEnable, 12)
      expectVec(dut.io.CPUmemIO.wrEnable, Seq(true, true,false, false))
      dut.io.CPUmemIO.wrData.poke("hBABEBABE".U)
      step()
      dut.io.CPUmemIO.stall.expect(true.B) // miss / invalid
      step()
      dut.io.memReq.expect(1.U) //Allocate
      step(blockSize)
      dut.io.CPUmemIO.stall.expect(true.B) // hit after allocate, but stall since cache is busy
      dut.io.CPUmemIO.rdData.expect(0.U) // Reading before write
      step()
      dut.io.memReq.expect(2.U) //Write through
      dut.io.CacheReqOut.valid.expect(true.B)
      dut.io.CacheReqOut.bits.isWrite.expect(true.B)
      dut.io.CacheReqOut.bits.addrRequest.expect(2.U)
      dut.io.CacheReqOut.bits.dataRequest.expect("hBABEBABE".U)
      dut.io.CacheReqOut.bits.activeByteLane.expect(12.U)
      step(2) // cachetop should be idle after writing
      dut.io.CPUmemIO.stall.expect(false.B)

      // Try to read written word
      dut.io.CPUmemIO.rdAddress.poke(0.U)
      pokeVecBool(dut.io.CPUmemIO.wrEnable, 0)
      dut.io.CPUmemIO.rdEnable.poke(true.B)
      step()
      dut.io.CPUmemIO.stall.expect(false.B)
      dut.io.CPUmemIO.rdData.expect("hBABE0000".U)


      // Try to read next word (non modified)
      dut.io.CPUmemIO.rdAddress.poke(4.U)
      pokeVecBool(dut.io.CPUmemIO.wrEnable, 0)
      dut.io.CPUmemIO.rdEnable.poke(true.B)
      step()
      dut.io.CPUmemIO.stall.expect(false.B)
      dut.io.CPUmemIO.rdData.expect(0.U)
    }
  }

  "CacheTop" should "sb and lb" in {
    test(new CacheTopTester(blockSize)) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      dut.io.CacheRspIn.valid.poke(true.B)
      dut.io.CPUmemIO.stall.expect(false.B)
      dut.io.CPUmemIO.rdEnable.poke(false.B)
      dut.io.CPUmemIO.wrAddress.poke(2.U)
      pokeVecBool(dut.io.CPUmemIO.wrEnable,4)
      dut.io.CPUmemIO.wrData.poke("hAAAAAAAA".U)
      step()
      dut.io.CPUmemIO.stall.expect(true.B) // miss / invalid
      step(blockSize + 1)
      dut.io.CPUmemIO.stall.expect(true.B) // hit after allocate, but stall since cache is busy
      dut.io.CPUmemIO.rdData.expect(0.U) // Reading before write
      step()
      dut.io.memReq.expect(2.U) //Write through
      dut.io.CacheReqOut.valid.expect(true.B)
      dut.io.CacheReqOut.bits.isWrite.expect(true.B)
      dut.io.CacheReqOut.bits.addrRequest.expect(2.U)
      dut.io.CacheReqOut.bits.dataRequest.expect("hAAAAAAAA".U)
      dut.io.CacheReqOut.bits.activeByteLane.expect(4.U)
      step(2) // cachetop should be idle after writing
      dut.io.CPUmemIO.stall.expect(false.B)

      // Try to read written word
      dut.io.CPUmemIO.rdAddress.poke(0.U)
      pokeVecBool(dut.io.CPUmemIO.wrEnable,0)
      dut.io.CPUmemIO.rdEnable.poke(true.B)
      step()
      dut.io.CPUmemIO.stall.expect(false.B)
      step()
      dut.io.CPUmemIO.rdData.expect("hAA0000".U)

      // Try to read next word (non modified)
      dut.io.CPUmemIO.rdAddress.poke(4.U)
      pokeVecBool(dut.io.CPUmemIO.wrEnable, 0)
      dut.io.CPUmemIO.rdEnable.poke(true.B)
      step()
      dut.io.CPUmemIO.stall.expect(false.B)
      step()
      dut.io.CPUmemIO.rdData.expect(0.U)
    }
  }
}