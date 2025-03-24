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

class CacheController() extends Module {
  val io = IO(new Bundle {
    val validReq = Input(Bool())
    val rw = Input(Bool())
    val memAdd = Input(UInt(32.W))
    val DI = Input(UInt(32.W))
    val DO = Output(UInt(32.W))
    val ready = Output(Bool())
    val memReady = Input(Bool())
    val cacheMiss = Output(Bool())
    val cacheInvalid = Output(Bool())
    val wrEnable = Input(Vec (4, Bool()))
    val modData = Output(UInt(32.W))
  })

  val blockSize = 4
  val cacheSize = 1024
  val blockCount = cacheSize / blockSize

  val lastRead = RegInit(0.U(32.W)) // Register to remember last read value
  val tagStore = Module(new SRAM(cacheSize/2,32))
  val cache = Module(new SRAM(cacheSize,32))
  val extMem = Module(new SRAM(4*cacheSize,32)) // temporary model of external memory




  val blockOffset = io.memAdd(1 + log2Down(blockSize), 2)
  val index = io.memAdd(1 + log2Down(blockSize) + log2Down(blockCount), 2 + log2Down(blockSize))
  val targetTag = io.memAdd(31, 2 + log2Down(blockSize) + log2Down(blockCount))
  val targetTagWord = WireInit(0.U(32.W))
  val actualTag = tagStore.io.DO(31, 2 + log2Down(blockSize) + log2Down(blockCount))
  val cacheValid = tagStore.io.DO(1 + log2Down(blockSize) + log2Down(blockCount))
  val writeIndex = RegInit(0.U(3.W)) // Tracks the index during write-through
  val updatedTag = RegInit(0.U(32.W))
  val cacheWriteAdd = WireInit(0.U(log2Down(cacheSize).W))
  val cacheReadAdd = WireInit(0.U(log2Down(cacheSize).W))
  val memDataIn = WireInit(0.U(32.W))
  val cacheAdd = WireInit(0.U(log2Down(cacheSize).W))
  val memWordAdd = io.memAdd(31, 2)
  val modifiedData = WireInit(0.U(32.W))

  io.modData := modifiedData

  // Default connections
  tagStore.io.rw := true.B
  tagStore.io.EN := false.B
  cache.io.rw := true.B
  cache.io.EN := false.B
  cache.io.DI := io.DI
  extMem.io.rw:= true.B
  extMem.io.EN := false.B
  extMem.io.ad := memWordAdd
  io.cacheMiss := false.B


  extMem.io.DI := memDataIn
  cacheReadAdd := index ## blockOffset
  cacheWriteAdd := index ## writeIndex

  cache.io.ad := cacheAdd
  targetTagWord := targetTag << 12

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
      setIdle(extMem)
      io.DO := lastRead
      when(io.validReq) {
        // Start to read tag
        cacheAdd := cacheReadAdd
        startRead(tagStore)
        stateReg := compareTag
        startRead(cache)

        /*
        when(io.rw) {
          // start Read stuff
          startRead(cache)

        }.otherwise {
          // write stuff
          writeRAM(cache)
          cache.io.DI := io.DI
        } */

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
        startRead(extMem)
        stateReg := allocate
      }.elsewhen(actualTag === targetTag) { // cache hit
        cacheAdd := cacheReadAdd
        cache.io.EN := true.B // keep enable high for read



        when(io.rw) {
          // Read stuff
          lastRead := cache.io.DO
          io.DO := cache.io.DO
          stateReg := idle
        }.otherwise {
          // write stuff
          writeRAM(cache)
          modifiedData := maskedWriteData(cache.io.DO,io.DI,io.wrEnable)
          cache.io.DI := modifiedData
          stateReg := writethrough
        }
      }.otherwise { // cache miss
        cacheAdd := cacheWriteAdd
        io.cacheMiss := true.B

        stateReg := allocate

        startRead(extMem)
      }

    }
    is(writethrough) {
      cacheAdd := cacheReadAdd
      extMem.io.rw := false.B
      extMem.io.EN := true.B
      memDataIn := io.DI

      when(io.memReady) {
        stateReg := idle
      }
    }
    is(allocate) {
      io.cacheMiss := true.B
      // Fetch memory
      writeRAM(cache)
      cacheAdd := cacheWriteAdd
      extMem.io.EN := true.B // keep enable high for read
      extMem.io.ad := memWordAdd + writeIndex + 1.U // +1 since reading lags 1 cycle behind
      cache.io.DI := extMem.io.DO

      updatedTag := targetTagWord | "h800".U // Setting valid bit to 1

      when(io.memReady && writeIndex === (blockSize - 1).asUInt) {
        //Update tag store
        writeRAM(tagStore)
        stateReg := compareTag
        writeIndex := 0.U
      }.elsewhen(!io.memReady && writeIndex === (blockSize - 1).asUInt) {
        writeIndex := (blockSize - 1).asUInt
      }.otherwise {
        writeIndex := writeIndex + 1.U
      }
    }
  }


  // Output

  io.ready := stateReg === idle
  io.cacheInvalid := !cacheValid
  tagStore.io.DI := updatedTag
  io.DO := lastRead


}



