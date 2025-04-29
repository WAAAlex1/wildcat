package Caches


import chisel3._
import chiseltest._
import chiseltest.{ChiselScalatestTester, testableBool}
import org.scalatest.flatspec.AnyFlatSpec
import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import Caches.SimpleCache.CacheFunctions._
import Caches.SimpleCache.SRAM
import chisel3.util.Decoupled
import wildcat.pipeline.MemIO


class BusInterconnectTester (implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    val CPUdCacheMemIO = Flipped(new MemIO())
    val CPUiCacheMemIO = Flipped(new MemIO())

    val dReqAck = Output(Bool())
    val dReqOut = Decoupled(new TLRequest)
    val iReqAck = Output(Bool())
    val iReqOut = Decoupled(new TLRequest)

  })
  val interconnect = Module(new BusInterconnect())
  interconnect.io.CPUdCacheMemIO <> io.CPUdCacheMemIO
  interconnect.io.CPUiCacheMemIO <> io.CPUiCacheMemIO


  interconnect.io.dCacheRspIn.bits.error := false.B
  interconnect.io.dCacheRspIn.bits.dataResponse := 0.U
  interconnect.io.dCacheRspIn.valid := true.B
  interconnect.io.iCacheRspIn.bits.error := false.B
  interconnect.io.iCacheRspIn.bits.dataResponse := 0.U
  interconnect.io.iCacheRspIn.valid := true.B

  interconnect.io.dCacheReqOut.ready := Mux(interconnect.io.dCacheReqOut.valid, true.B, false.B)
  interconnect.io.iCacheReqOut.ready := Mux(!interconnect.io.dCacheReqOut.valid && interconnect.io.iCacheReqOut.valid, true.B, false.B)


  io.dReqAck := interconnect.io.dCacheReqOut.valid && interconnect.io.dCacheReqOut.ready
  io.iReqAck := interconnect.io.iCacheReqOut.valid && interconnect.io.iCacheReqOut.ready


  io.dReqOut.bits.addrRequest :=   interconnect.io.dCacheReqOut.bits.addrRequest
  io.dReqOut.bits.isWrite :=   interconnect.io.dCacheReqOut.bits.isWrite
  io.dReqOut.bits.dataRequest :=   interconnect.io.dCacheReqOut.bits.dataRequest
  io.dReqOut.bits.activeByteLane :=   interconnect.io.dCacheReqOut.bits.activeByteLane

  io.iReqOut.bits.addrRequest := interconnect.io.iCacheReqOut.bits.addrRequest
  io.iReqOut.bits.isWrite := interconnect.io.iCacheReqOut.bits.isWrite
  io.iReqOut.bits.dataRequest := interconnect.io.iCacheReqOut.bits.dataRequest
  io.iReqOut.bits.activeByteLane := interconnect.io.iCacheReqOut.bits.activeByteLane

  io.dReqOut.valid := true.B
  io.iReqOut.valid := true.B


  // Test memory
  val mem = Module(new SRAM(2048,32))
  mem.io.ad := 0.U
  mem.io.rw := true.B
  mem.io.DI := 0.U
  mem.io.EN := false.B

  val DmemRspRdy = RegInit(false.B)
  val ImemRspRdy = RegInit(false.B)

  when(io.dReqAck){
    mem.io.ad := interconnect.io.dCacheReqOut.bits.addrRequest
    mem.io.rw := !interconnect.io.dCacheReqOut.bits.isWrite
    mem.io.DI := interconnect.io.dCacheReqOut.bits.dataRequest
    mem.io.EN := true.B
    DmemRspRdy := true.B

  }.elsewhen(io.iReqAck){
    mem.io.ad := interconnect.io.iCacheReqOut.bits.addrRequest
    mem.io.rw := !interconnect.io.iCacheReqOut.bits.isWrite
    mem.io.DI := interconnect.io.iCacheReqOut.bits.dataRequest
    mem.io.EN := true.B
    DmemRspRdy := true.B

  }

  when(DmemRspRdy){
    mem.io.ad := interconnect.io.dCacheReqOut.bits.addrRequest
    mem.io.rw := !interconnect.io.dCacheReqOut.bits.isWrite
    mem.io.DI := interconnect.io.dCacheReqOut.bits.dataRequest
    mem.io.EN := true.B
    interconnect.io.dCacheRspIn.bits.dataResponse := mem.io.DO
    interconnect.io.dCacheRspIn.valid := true.B
    DmemRspRdy := false.B
  }.elsewhen(ImemRspRdy){
    mem.io.ad := interconnect.io.iCacheReqOut.bits.addrRequest
    mem.io.rw := !interconnect.io.iCacheReqOut.bits.isWrite
    mem.io.DI := interconnect.io.iCacheReqOut.bits.dataRequest
    mem.io.EN := true.B
    interconnect.io.iCacheRspIn.bits.dataResponse := mem.io.DO
    interconnect.io.iCacheRspIn.valid := true.B
    ImemRspRdy := false.B
  }
}


class BusInterconnectTest extends AnyFlatSpec with ChiselScalatestTester {
  implicit val config = TilelinkConfig()

  "Bus" should "init" in {
    test(new BusInterconnectTester()) { dut =>
      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(false.B)

    }
  }

  "Bus" should "SW from Data Cache" in {
    test(new BusInterconnectTester()) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }

      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(false.B)


      // Both caches request => Data cache has priority
      dut.io.CPUiCacheMemIO.stall.expect(false.B)
      dut.io.CPUiCacheMemIO.rdEnable.poke(false.B)
      dut.io.CPUiCacheMemIO.wrAddress.poke(0.U)
      pokeVecBool(dut.io.CPUiCacheMemIO.wrEnable, 15)
      dut.io.CPUiCacheMemIO.wrData.poke("hBABEFACE".U)

      dut.io.CPUdCacheMemIO.stall.expect(false.B)
      dut.io.CPUdCacheMemIO.rdEnable.poke(false.B)
      dut.io.CPUdCacheMemIO.wrAddress.poke(0.U)
      pokeVecBool(dut.io.CPUdCacheMemIO.wrEnable, 15)
      dut.io.CPUdCacheMemIO.wrData.poke("hCAFEBABE".U)

      step()
      dut.io.CPUdCacheMemIO.stall.expect(true.B) // miss / invalid
      step()
      dut.io.iReqAck.expect(false.B)
      dut.io.dReqAck.expect(true.B)
      dut.io.dReqOut.bits.isWrite.expect(false.B)
      dut.io.dReqOut.bits.activeByteLane.expect(15.U)
      dut.io.dReqOut.bits.addrRequest.expect(0.U)
      step()
      dut.io.iReqAck.expect(false.B)
      dut.io.dReqAck.expect(true.B)
      step()
      dut.io.iReqAck.expect(false.B)
      dut.io.dReqAck.expect(true.B)
      step()
      dut.io.iReqAck.expect(false.B)
      dut.io.dReqAck.expect(true.B)
      step()
      dut.io.CPUdCacheMemIO.stall.expect(true.B) // hit after allocate, but stall since cache is busy
      dut.io.CPUdCacheMemIO.rdData.expect(0.U) // Reading before write
      step()
      dut.io.iReqAck.expect(false.B)
      dut.io.dReqAck.expect(true.B)
      dut.io.dReqOut.bits.isWrite.expect(true.B)
      dut.io.dReqOut.bits.activeByteLane.expect(15.U)
      dut.io.dReqOut.bits.addrRequest.expect(0.U)
      dut.io.dReqOut.bits.dataRequest.expect("hCAFEBABE".U)
      step()
      dut.io.CPUdCacheMemIO.stall.expect(false.B)

      // Try to read written word from cache
      dut.io.CPUdCacheMemIO.rdEnable.poke(true.B)
      dut.io.CPUdCacheMemIO.rdAddress.poke(0.U)
      pokeVecBool(dut.io.CPUdCacheMemIO.wrEnable, 0)
      step()
      dut.io.CPUdCacheMemIO.stall.expect(false.B)
      dut.io.CPUdCacheMemIO.rdData.expect("hCAFEBABE".U)
      step()

      // Try to read next word in cache block (should be 0)
      dut.io.CPUdCacheMemIO.rdEnable.poke(true.B)
      dut.io.CPUdCacheMemIO.rdAddress.poke(4.U)
      pokeVecBool(dut.io.CPUdCacheMemIO.wrEnable, 0)
      step()
      dut.io.CPUdCacheMemIO.stall.expect(false.B)
      dut.io.CPUdCacheMemIO.rdData.expect(0.U)


    }
  }
  "Bus" should "SB from Instruction Cache" in {
    test(new BusInterconnectTester()) { dut =>
      def step(n: Int = 1): Unit = {
        dut.clock.step(n)
      }
      // Only instruction cache request
      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(false.B)

      dut.io.CPUiCacheMemIO.stall.expect(false.B)
      dut.io.CPUiCacheMemIO.rdEnable.poke(false.B)
      dut.io.CPUiCacheMemIO.wrAddress.poke(3.U)
      pokeVecBool(dut.io.CPUiCacheMemIO.wrEnable, 8)
      dut.io.CPUiCacheMemIO.wrData.poke("hABABABAB".U)

      step()
      dut.io.CPUiCacheMemIO.stall.expect(true.B) // miss / invalid
      step()
      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(true.B)
      dut.io.iReqOut.bits.isWrite.expect(false.B)
      dut.io.iReqOut.bits.activeByteLane.expect(15.U)
      dut.io.iReqOut.bits.addrRequest.expect(0.U)
      step()
      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(true.B)
      step()
      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(true.B)
      step()
      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(true.B)
      step()
      dut.io.CPUiCacheMemIO.stall.expect(true.B) // hit after allocate, but stall since cache is busy
      dut.io.CPUiCacheMemIO.rdData.expect(0.U) // Reading before write
      step()
      dut.io.dReqAck.expect(false.B)
      dut.io.iReqAck.expect(true.B)
      dut.io.iReqOut.bits.isWrite.expect(true.B)
      dut.io.iReqOut.bits.activeByteLane.expect(8.U)
      dut.io.iReqOut.bits.addrRequest.expect(3.U)
      dut.io.iReqOut.bits.dataRequest.expect("hABABABAB".U)
      step()
      dut.io.CPUiCacheMemIO.stall.expect(false.B)

    }
  }

}


