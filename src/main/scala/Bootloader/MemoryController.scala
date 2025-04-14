package Bootloader

import SPI.SpiMemController
import caravan.bus.tilelink.{TLRequest, TLResponse, TilelinkConfig}
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum


/**
 * First draft of memory controller module for the Wildcat.
 *
 * Address space:
 * [0xf000_0000] is the IO space for the Wildcat
 * [23,0] is the real address space of the memory
 * [23] is the toggling bit between instr and data mem. So far they are equal in size but it can change.
 * [27,24] are so far unused control signal bits we might need later
 * [0x1000_0000 etc.] is also unused so far.
 * By Georg Brink Dyvad, @GeorgBD
 */

class MemoryController(implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle {
    val memIO = IO(Flipped(new TestMemIO()))
    val stall = Output(Bool())
    val bootloading = Input(Bool())

    // To/From caches via bus
    val dCacheReqOut = Flipped(Decoupled(new TLRequest))
    val dCacheRspIn = Decoupled(new TLResponse)

    val iCacheReqOut = Flipped(Decoupled(new TLRequest))
    val iCacheRspIn = Decoupled(new TLResponse)
  })

  val memory = Module(new TestMem(4096))
  io.memIO <> memory.io

  //Address mapping
  when(io.memIO.rdAddress(31,28) === "hf".U){
    //Do nothing cause memory mapped IO defined in Wildcattop?
  }.elsewhen(io.memIO.rdAddress(23) === 1.U){
    //DataMem.read addresser (23,0)
  }.elsewhen(true.B){
    //instrMem.read addresser (23,0)
  }

  //I assume stalling will also be enabled by the caches and slower mem so the OR is for that.
  io.stall := io.bootloading || false.B



  // Arbitration on ready for requests. Data cache has priority
  io.dCacheReqOut.ready := Mux(io.dCacheReqOut.valid, true.B, false.B)
  io.iCacheReqOut.ready := Mux(!io.dCacheReqOut.valid && io.iCacheReqOut.valid, true.B, false.B)

  // Default Responses
  io.dCacheRspIn.bits.dataResponse := readData
  io.iCacheRspIn.bits.dataResponse := readData
  io.dCacheRspIn.bits.error := false.B // dummy
  io.iCacheRspIn.bits.error := false.B // dummy
  io.dCacheRspIn.valid := false.B
  io.iCacheRspIn.valid := false.B


  val dReqAck = io.dCacheReqOut.valid && io.dCacheReqOut.ready // Request acknowledged
  val iReqAck = io.iCacheReqOut.valid && io.iCacheReqOut.ready
  val currentReq = Reg(new TLRequest())
  val writeSize = WireInit(UInt(3.W)) // Number of bytes to write
  val rspPending = WireInit(false.B)
  val data2write = Wire(UInt(32.W))
  val readData = WireInit(0.U(32.W))
  val SPI0 = Module(new SpiMemController)
  val SPI1 = Module(new SpiMemController)
  val masterID = RegInit(false.B) // Master (cache) identifier
  val rspValid = WireInit(false.B)

  // Default settings for SPI controllers
  SPI0.io.en := false.B
  SPI0.io.rw := currentReq.isWrite
  SPI0.io.rst := false.B
  SPI0.io.addr := currentReq.addrRequest(23, 0)
  SPI0.io.dataIn := data2write
  SPI0.io.so := DontCare
  SPI0.io.sioOut := DontCare
  SPI1.io.en := false.B
  SPI1.io.rw := currentReq.isWrite
  SPI1.io.rst := false.B
  SPI1.io.addr := currentReq.addrRequest(23,0)
  SPI1.io.dataIn := data2write
  SPI1.io.so := DontCare
  SPI1.io.sioOut := DontCare


  // Process requests
  when(dReqAck){
    currentReq := io.dCacheReqOut.bits
    rspPending := true.B
    masterID := 0.U
  }.elsewhen(iReqAck){
    currentReq := io.iCacheReqOut.bits
    rspPending := true.B
    masterID := 1.U
  }

  // Modify data to write (
  when(currentReq.isWrite){
      switch(currentReq.activeByteLane){
        // Store word
        is(15.U){
          data2write := currentReq.dataRequest
          writeSize := 4.U
        }

        // Store half-word
        is(12.U){
          data2write := currentReq.dataRequest(31,16)
          writeSize := 2.U
        }
        is(3.U){
          data2write := currentReq.dataRequest(15,0)
          writeSize := 2.U
        }

        //Store Byte
        is(8.U){
          data2write := currentReq.dataRequest(31,24)
          writeSize := 1.U
        }
        is(4.U){
          data2write := currentReq.dataRequest(23,16)
          writeSize := 1.U
        }
        is(2.U){
          data2write := currentReq.dataRequest(15,8)
          writeSize := 1.U
        }
        is(1.U){
          data2write := currentReq.dataRequest(7,0)
          writeSize := 1.U
        }
      }
  }

  when(rspPending){
    //Address mapping
    when(currentReq.addrRequest(31, 28) === "hf".U) {
      //Do nothing cause memory mapped IO defined in Wildcattop?
    }.elsewhen(currentReq.addrRequest(24)) {
      // RAM 1 read/write
      SPI1.io.en := true.B

    }.elsewhen(!currentReq.addrRequest(24)) {
      // RAM 0 read/ write
      SPI0.io.en := true.B

    }.otherwise{
      // Flash read=?
    }
  }

  // Process responses
  when(SPI0.io.done){
    rspPending := false.B
    when(!currentReq.isWrite){
      readData := SPI0.io.dataOut
    }
    rspValid := true.B
  }.elsewhen(SPI1.io.done){
    rspPending := false.B
    when(!currentReq.isWrite) {
      readData := SPI1.io.dataOut
    }
    rspValid := true.B
  }

  when(rspValid){
    when(masterID){ // iCache requested
      io.iCacheRspIn.valid := true.B
    }.otherwise{ // dCache requested
      io.dCacheRspIn.valid := true.B
    }
  }

}
