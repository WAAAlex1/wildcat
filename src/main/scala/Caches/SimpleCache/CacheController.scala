package Caches.SimpleCache

import chisel3._
import chisel3.util._
import wildcat.pipeline._
import Caches.SimpleCache.CacheFunctions._


/**
 * Simple cache for the Wildcat
 *
 * Current version is simple with direct mapping and write-through. Needs top layer that communicates
 * with wildcat
 *
 * Author: Gustav Junker
 */

class CacheController(blockSize: Int) extends Module {
  val io = IO(new Bundle {
    // Input/output to/from Wildcat
    val validReq = Input(Bool())
    val rw = Input(Bool())
    val memAdd = Input(UInt(32.W))
    val CPUdataIn = Input(UInt(32.W))
    val CPUdataOut = Output(UInt(32.W))
    val cacheMiss = Output(Bool())
    val ready = Output(Bool())
    val wrEnable = Input(Vec (4, Bool()))

    // Input/output to/from external memory via bus
    val memDataIn = Input(UInt(32.W))
    val memReady = Input(Bool())
    val alloAddr = Output(UInt(32.W))
    val memReq = Output(UInt(2.W)) // 0: no request, 1: allocation request, 2: write-through
  })

  val cacheSize = 1024
  val blockCount = cacheSize / blockSize

  val n = log2Down(blockCount) // Number of bits for index
  val m = log2Down(blockSize) // Number of bits for locating word in block
  val tagSize = 32 - (n + m + 2)
  val lastRead = RegInit(0.U(32.W)) // Register to remember last read value
  val tagStore = Module(new SRAM(cacheSize/blockSize,tagSize + 1))
  val cache = Module(new SRAM(cacheSize,32))



  val blockOffset = io.memAdd(1 + m, 2)
  val index = io.memAdd(1 + m + n, 2 + m)
  val targetTag = io.memAdd(31, 32 - tagSize)
  val actualTag = tagStore.io.DO(tagSize, 1)
  val cacheValid = tagStore.io.DO(0)
  val rwIndex = RegInit(0.U(3.W)) // Tracks the index during write-through
  val updatedTag = targetTag ## 1.U // Setting valid bit to 1

  val cacheWriteAdd = WireInit(0.U(log2Down(cacheSize).W))
  val cacheReadAdd = WireInit(0.U(log2Down(cacheSize).W))

  val cacheAdd = WireInit(0.U(log2Down(cacheSize).W))
  val memWordAdd = io.memAdd(31, 2)
  val modifiedData = WireInit(0.U(32.W))



  // Default connections
  tagStore.io.rw := true.B
  tagStore.io.EN := false.B
  tagStore.io.DI := updatedTag
  cache.io.rw := true.B
  cache.io.EN := false.B
  cache.io.DI := io.CPUdataIn
  io.cacheMiss := false.B
  io.memReq := 0.U

  cacheReadAdd := index ## blockOffset
  cacheWriteAdd := index ## rwIndex

  cache.io.ad := cacheAdd

  // Address lines
  tagStore.io.ad := index


  object State extends ChiselEnum {
    val idle, compareTag, allocate, writethrough = Value
  }

  import State._
  // The state register
  val stateReg = RegInit(idle)



  switch(stateReg) {
    is(idle) {

      when(io.validReq) {
        // Start to read tag
        startRead(tagStore)
        stateReg := compareTag

        // Start to read cache
        cacheAdd := cacheReadAdd
        startRead(cache)


      }.otherwise {
        setIdle(tagStore)
        setIdle(cache)
      }
    }
    is(compareTag) {
      tagStore.io.EN := true.B // Keep enable high for read
      when(!cacheValid) {
        cacheAdd := cacheWriteAdd
        io.cacheMiss := true.B

        stateReg := allocate
      }.elsewhen(actualTag === targetTag) { // cache hit
        cacheAdd := cacheReadAdd
        cache.io.EN := true.B // keep enable high for read


        when(io.rw) {
          // Read stuff

          lastRead := cache.io.DO

          stateReg := idle
        }.otherwise {
          // write stuff
          writeRAM(cache)
          modifiedData := maskedWriteData(cache.io.DO,io.CPUdataIn,io.wrEnable)
          cache.io.DI := modifiedData
          stateReg := writethrough
        }
      }.otherwise { // cache miss
        cacheAdd := cacheWriteAdd
        io.cacheMiss := true.B
        stateReg := allocate

      }
    }
    is(writethrough) {
      io.memReq := 2.U
      cacheAdd := cacheReadAdd

      when(io.memReady) {
        stateReg := idle
      }
    }
    is(allocate) {
      io.memReq := 1.U
      io.cacheMiss := true.B

      // Fetch memory
      cacheAdd := cacheWriteAdd
      cache.io.DI := io.memDataIn

      when(io.memReady) {
        writeRAM(cache)

        when(rwIndex === (blockSize - 1).asUInt) {
          //Update tag store
          writeRAM(tagStore)
          stateReg := compareTag
          rwIndex := 0.U
        }.otherwise {
          rwIndex := rwIndex + 1.U
        }
      }
    }
  }


  // Output

  io.ready := stateReg === idle
  io.CPUdataOut := Mux(io.ready,lastRead,cache.io.DO)
  //io.alloAddr := (memWordAdd ## 0.U(2.W)) + rwIndex*4.U
  io.alloAddr := (memWordAdd << 2).asUInt + rwIndex*4.U
}



