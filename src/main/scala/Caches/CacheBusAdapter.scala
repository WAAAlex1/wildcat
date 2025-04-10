package Caches


import chisel3._
import chisel3.util._
import wildcat.pipeline._
import caravan.bus.tilelink._
import Caches.SimpleCache.CacheTop

/**
 * This file is part of the bus between the cache and memory controller
 *
 * This is the adapter between cache (the host/master) to the bus
 *
 * Author: Gustav Junker
 *
 */

class CacheBusAdapter(implicit val config:TilelinkConfig) extends Module{
  val io = IO(new Bundle {
    // Input/output to/from CPU
    val CPUMemIO = Flipped(new MemIO())


    // Input/Output to memory controller
    val reqOut = Decoupled(new TLRequest)
    val rspIn = Flipped(Decoupled(new TLResponse))
  })

  val TL_Adapter = Module(new TilelinkAdapter())


  val Cache = Module(new CacheTop(4))
  Cache.io.CPUmemIO <> io.CPUMemIO


  TL_Adapter.io.reqIn <> Cache.io.CacheReqOut
  Cache.io.CacheRspIn <> TL_Adapter.io.rspOut
  io.reqOut <> TL_Adapter.io.reqOut
  TL_Adapter.io.rspIn <> io.rspIn



}
