package Caches.SimpleCache


import chisel3._
import chisel3.util._
import wildcat.pipeline._
import Caches.SimpleCache.CacheFunctions._
import caravan.bus.tilelink._


/**
 * This file is part of caches for wildcat
 *
 * This is the top-level for the simple cache
 *
 * Author: Gustav Junker
 *
 */




class CacheTop(blockSize: Int)(implicit val config:TilelinkConfig) extends Module {
  val io = IO(new Bundle{
    // Input from wildcat
    val CPUmemIO = Flipped(new MemIO())

    // IO to/from TL adapter
    val CacheReqOut = Decoupled((new TLRequest()))
    val CacheRspIn = Flipped(Decoupled((new TLResponse())))
  })


  val Controller = Module(new CacheController(blockSize))

  Controller.io.memReady := io.CacheRspIn.valid && !io.CacheRspIn.bits.error

  Controller.io.validReq := false.B
  Controller.io.rw := true.B
  Controller.io.memAdd := io.CPUmemIO.rdAddress
  Controller.io.wrEnable := io.CPUmemIO.wrEnable
  Controller.io.CPUdataIn := io.CPUmemIO.wrData
  Controller.io.memDataIn := io.CacheRspIn.bits.dataResponse
  io.CPUmemIO.rdData := Controller.io.CPUdataOut

  //Default TL Req/Rsp
  io.CacheReqOut.valid := false.B
  io.CacheReqOut.bits.dataRequest := 0.U
  io.CacheReqOut.bits.addrRequest := 0.U
  io.CacheReqOut.bits.isWrite := false.B
  io.CacheReqOut.bits.activeByteLane := 0.U
  io.CacheRspIn.ready := true.B // Always ready for response


  // Stall  processor on miss
  io.CPUmemIO.stall := Controller.io.stall


  // Drive controller on read
  when(io.CPUmemIO.rdEnable){ // lb, lh or lw
    Controller.io.validReq := true.B
    Controller.io.rw := true.B
    Controller.io.memAdd := io.CPUmemIO.rdAddress

    when(Controller.io.memReq =/= 0.U){ // When busy allocating or write through
      io.CPUmemIO.stall := true.B
    }
  }


  // Drive controller on write
  when(io.CPUmemIO.wrEnable.asUInt > 0.U){ // sb, sh or sw
    Controller.io.validReq := true.B
    Controller.io.rw := false.B
    Controller.io.memAdd := io.CPUmemIO.wrAddress

    when(!Controller.io.ready){ // Ensure stalling when busy allocating or writing
      io.CPUmemIO.stall := true.B
    }
  }


  // Controller sends request on bus depending on action
  when(Controller.io.memReq === 1.U){ //allocation

    io.CacheReqOut.valid := true.B
    io.CacheReqOut.bits.addrRequest := Controller.io.alloAddr
    io.CacheReqOut.bits.activeByteLane := 15.U

  }.elsewhen(Controller.io.memReq === 2.U){ // write through

    io.CacheReqOut.valid := true.B
    io.CacheReqOut.bits.dataRequest := io.CPUmemIO.wrData
    io.CacheReqOut.bits.addrRequest := io.CPUmemIO.wrAddress
    io.CacheReqOut.bits.isWrite := true.B
    io.CacheReqOut.bits.activeByteLane := io.CPUmemIO.wrEnable.asUInt

  }


}

