package Caches.SimpleCache

import chisel3._
import chisel3.util._


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
  })

  val blockSize = 4
  val cacheSize = 1024
  val blockCount = cacheSize / blockSize

  val lastRead = RegInit(0.U(32.W)) // Register to remember last read value
  val tagStore = Module(new RAM(cacheSize/2,32))
  val cache = Module(new RAM(cacheSize,32))
  val extMem = Module(new RAM(4*cacheSize,32))




  val byteOffset = io.memAdd(1, 0)
  val blockOffset = io.memAdd(1 + log2Down(blockSize), 2)
  val index = io.memAdd(1 + log2Down(blockSize) + log2Down(blockCount), 2 + log2Down(blockSize))
  val targetTag = io.memAdd(31, 2 + log2Down(blockSize) + log2Down(blockCount))
  val targetTagWord = WireInit(0.U(32.W))
  val actualTag = tagStore.io.DO(31, 2 + log2Down(blockSize) + log2Down(blockCount))
  val cacheValid = tagStore.io.DO(1 + log2Down(blockSize) + log2Down(blockCount))
  val writeIndex = RegInit(0.U(3.W)) // Tracks the index during write-through
  val updatedTag = RegInit(0.U(32.W))
  val cacheHit = RegInit(false.B)
  val cacheWriteAdd = WireInit(0.U(log2Down(cacheSize).W))
  val cacheReadAdd = WireInit(0.U(log2Down(cacheSize).W))
  val memDataIn = WireInit(0.U(32.W))
  val cacheAdd = WireInit(0.U(log2Down(cacheSize).W))
  val memWordAdd = io.memAdd(31, 2)


  // Default connections
  tagStore.io.rw := true.B
  tagStore.io.EN := false.B
  cache.io.rw := true.B
  cache.io.EN := false.B
  cache.io.DI := io.DI
  extMem.io.rw:=true.B
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


  def startRead(M: RAM) = {
    M.io.EN := true.B
    M.io.rw := true.B
  }
  def writeRAM(M: RAM): Unit = {
    M.io.EN := true.B
    M.io.rw := false.B
  }
  def setIdle(M: RAM): Unit = {
    M.io.EN := false.B
    M.io.rw := true.B
  }

  switch(stateReg) {
    is(idle) {
      setIdle(extMem)
      when(io.validReq) {
        // Start to read tag
        cacheAdd := cacheReadAdd
        startRead(tagStore)
        stateReg := compareTag

        when(io.rw) {
          // start Read stuff
          startRead(cache)

        }.otherwise {
          // write stuff
          writeRAM(cache)
          cache.io.DI := io.DI
        }

      }.otherwise {
        setIdle(tagStore)
        setIdle(cache)
      }
    }
    is(compareTag) {
      tagStore.io.EN := true.B // Keep enable high for read
      when(!cacheValid) {
        cacheAdd := cacheWriteAdd

        startRead(extMem)
        stateReg := allocate
      }.elsewhen(actualTag === targetTag) { // cache hit
        cacheAdd := cacheReadAdd

        when(io.rw) {
          // Read stuff
          cache.io.EN := true.B // keep enable high for read
          lastRead := cache.io.DO
          stateReg := idle
        }.otherwise {
          // write stuff
          writeRAM(cache)
          cache.io.DI := io.DI
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
      // Fetch memory
      writeRAM(cache)
      cacheAdd := cacheWriteAdd
      extMem.io.EN := true.B // keep enable high for read
      extMem.io.ad := memWordAdd + writeIndex + 1.U // +1 since reading lags 1 cycle behind
      cache.io.DI := extMem.io.DO

      updatedTag := targetTagWord | "h800".U // Setting valid bit to 1

      when(io.memReady && writeIndex === 3.U) {
        //Update tag store
        writeRAM(tagStore)
        stateReg := compareTag
        writeIndex := 0.U
      }.elsewhen(!io.memReady && writeIndex === 3.U) {
        writeIndex := 3.U
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

object CacheController extends App {
  println("I will now generate the Verilog file")
  emitVerilog(new CacheController())
}

