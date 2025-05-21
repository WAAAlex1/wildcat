package caches

import caravan.bus.tilelink._
import chisel3._
import chisel3.util.Decoupled
import wildcat.pipeline.MemIO

/**
 * This file is part of the bus between the cache and memory controller
 *
 * This is a collection of two caches with bus adapters.
 * To be the link between wildcat and memory controller.
 *
 * Author: Gustav Junker
 *
 */

class BusInterconnect (implicit val config:TilelinkConfig) extends Module{
  val io = IO(new Bundle{
    val CPUdCacheMemIO = Flipped(new MemIO())
    val CPUiCacheMemIO = Flipped(new MemIO())

    val dCacheReqOut = Decoupled(new TLRequest)
    val dCacheRspIn = Flipped(Decoupled(new TLResponse))

    val iCacheReqOut = Decoupled(new TLRequest)
    val iCacheRspIn = Flipped(Decoupled(new TLResponse))

  })

  val dCacheAdapter = Module(new CacheBusAdapter())
  val iCacheAdapter = Module(new CacheBusAdapter())

  dCacheAdapter.io.CPUMemIO <> io.CPUdCacheMemIO
  iCacheAdapter.io.CPUMemIO <> io.CPUiCacheMemIO


  io.dCacheReqOut <> dCacheAdapter.io.reqOut
  dCacheAdapter.io.rspIn <> io.dCacheRspIn
  io.iCacheReqOut <> iCacheAdapter.io.reqOut
  iCacheAdapter.io.rspIn <> io.iCacheRspIn

}
