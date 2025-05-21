package caches.simple

import chisel3._
import chisel3.util._
import wildcat.pipeline._
import caches.simple.CacheFunctions._


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
    val memAddr = Input(UInt(32.W))
    val CPUdataIn = Input(UInt(32.W))
    val CPUdataOut = Output(UInt(32.W))
    val stall = Output(Bool())
    val ready = Output(Bool())
    val wrEnable = Input(Vec (4, Bool()))
    val busy = Output(Bool())

    // Input/output to/from external memory via bus
    val memDataIn = Input(UInt(32.W))
    val WTData = Output(UInt(32.W))
    val WTaddr = Output(UInt(32.W))
    val WTwre = Output(Vec(4,Bool()))
    val memReady = Input(Bool())
    val alloAddr = Output(UInt(32.W))
    val memReq = Output(UInt(2.W)) // 0: no request, 1: allocation request, 2: write-through
  })

  val cacheSize = 1024
  val blockCount = cacheSize / blockSize

  val n = log2Down(blockCount) // Number of bits for index
  val m = log2Down(blockSize) // Number of bits for locating word in block
  val tagSize = 32 - (n + m + 2)
  val lastRead = RegInit(0x13.U(32.W)) // Register to remember last read value (initially NOP)
  val tagStore = Module(new SRAM(cacheSize/blockSize,tagSize + 1))
  val cache = Module(new SRAM(cacheSize,32))



  val blockOffset = io.memAddr(1 + m, 2)
  val index = io.memAddr(1 + m + n, 2 + m)
  val targetTag = RegNext(io.memAddr(31, 32 - tagSize))
  val actualTag = tagStore.io.DO(tagSize, 1)
  val cacheInvalid = !tagStore.io.DO(0)
  val rwIndex = RegInit(0.U(3.W)) // Tracks the index during write-through and allocation
  val updatedTag = targetTag ## 1.U // Setting valid bit to 1

  val cacheWriteAdd = WireInit(0.U(log2Down(cacheSize).W))
  val cacheNewAddr = WireInit(0.U(log2Down(cacheSize).W))
  val cacheAddrReg = RegInit(0.U(log2Down(cacheSize).W))
  val cacheAllocationAddr = WireInit(0.U(log2Down(cacheSize).W))

  val cacheAddr = WireInit(0.U(log2Down(cacheSize).W))
  val memWordAdd = io.memAddr(31, 2)
  val modifiedData = WireInit(0.U(32.W))
  val memReq = RegInit(0.U(2.W))

  val rwReg = RegInit(true.B)
  val memAddReg = RegInit(0.U(32.W))
  val blockOffsetReg = memAddReg(1 + m, 2)
  val indexReg = memAddReg(1 + m + n, 2 + m)
  val dataInReg = RegInit(0.U(32.W))
  val wreReg = Reg(Vec(4,Bool()))





  // Default connections
  io.stall := false.B
  tagStore.io.rw := true.B
  tagStore.io.EN := false.B
  tagStore.io.DI := updatedTag
  cache.io.rw := true.B
  cache.io.EN := false.B
  cache.io.DI := io.CPUdataIn
  io.memReq := memReq

  cacheAddrReg := indexReg ## blockOffsetReg
  cacheNewAddr := index ## blockOffset
  cacheWriteAdd := indexReg ## rwIndex(m - 1,0)
  cacheAllocationAddr := indexReg ## rwIndex(m - 1,0)

  cache.io.ad := cacheAddr

  // Address lines
  tagStore.io.ad := indexReg


  object State extends ChiselEnum {
    val idle, compareTag1, compareTag2, allocate, writethrough = Value
  }

  import State._
  // The state register
  val stateReg = RegInit(idle)



  switch(stateReg) {
    is(idle) {

      when(io.validReq) {
        // Start to read tag
        tagStore.io.ad := index
        startRead(tagStore)
        stateReg := compareTag1

        // Start to read cache
        cacheAddr := cacheNewAddr
        startRead(cache)


        rwReg := io.rw
        memAddReg := io.memAddr
        dataInReg := io.CPUdataIn
        wreReg := io.wrEnable

      }.otherwise {
        setIdle(tagStore)
        setIdle(cache)
      }
    }
    is(compareTag1) {
      tagStore.io.EN := true.B // Keep enable high for read
      when(cacheInvalid) {
        cacheAddr := cacheAllocationAddr
        io.stall := true.B
        memReq := 1.U
        stateReg := allocate
      }.elsewhen(actualTag === targetTag) { // cache hit
        cacheAddr := cacheAddrReg
        cache.io.EN := true.B // keep enable high for read
        lastRead := cache.io.DO

        when(rwReg) {
          // Read stuff
          memReq := 0.U



          when(io.validReq){
            tagStore.io.ad := index
            cacheAddr := cacheNewAddr
            rwReg := io.rw
            memAddReg := io.memAddr
            dataInReg := io.CPUdataIn
            wreReg := io.wrEnable

            stateReg := compareTag2
          }.otherwise{
            stateReg := idle
          }

        }.otherwise {
          // write stuff
          memReq := 2.U


          stateReg := writethrough
        }
      }.otherwise { // cache miss
        cacheAddr := cacheAllocationAddr
        io.stall := true.B
        memReq := 1.U
        stateReg := allocate

      }
    }
    is(compareTag2) {
      tagStore.io.EN := true.B // Keep enable high for read
      when(cacheInvalid) {
        cacheAddr := cacheAllocationAddr
        io.stall := true.B
        memReq := 1.U
        stateReg := allocate
      }.elsewhen(actualTag === targetTag) { // cache hit
        cacheAddr := cacheAddrReg
        cache.io.EN := true.B // keep enable high for read
        lastRead := cache.io.DO

        when(rwReg) {
          // Read stuff
          memReq := 0.U

          when(io.validReq){
            tagStore.io.ad := index
            cacheAddr := cacheNewAddr
            rwReg := io.rw
            memAddReg := io.memAddr
            dataInReg := io.CPUdataIn
            wreReg := io.wrEnable

            stateReg := compareTag1
          }.otherwise{
            stateReg := idle
          }
        }.otherwise {
          // write stuff
          memReq := 2.U

          stateReg := writethrough
        }
      }.otherwise { // cache miss
        cacheAddr := cacheAllocationAddr
        io.stall := true.B
        memReq := 1.U
        stateReg := allocate

      }
    }
    is(writethrough) {



      when(io.memReady) {
        cacheAddr := cacheAddrReg
        modifiedData := maskedWriteData(lastRead,dataInReg,wreReg)
        writeRAM(cache)
        cache.io.DI := modifiedData



        memReq := 0.U
        stateReg := idle
      }
    }
    is(allocate) {
      when(rwReg){
        io.stall := true.B
      }

      // Fetch memory
      cacheAddr := cacheAllocationAddr
      cache.io.DI := io.memDataIn

      when(io.memReady) {
        writeRAM(cache)

        when(rwIndex === (blockSize - 1).asUInt) {
          //Update tag store
          writeRAM(tagStore)
          rwIndex := rwIndex + 1.U
          when(!rwReg){
            memReq := 2.U
          }.otherwise{
            memReq := 0.U
          }




        }.otherwise {
          rwIndex := rwIndex + 1.U
        }
      }
      when(rwIndex === (blockSize).asUInt){


        rwIndex := 0.U
        startRead(cache)
        cacheAddr := cacheAddrReg
        stateReg := compareTag1
      }
    }
  }


  // Output

  io.ready := stateReg === idle
  io.CPUdataOut := Mux(io.ready,lastRead,cache.io.DO)
  io.WTData := dataInReg
  io.WTaddr := memAddReg
  io.WTwre := wreReg
  //io.CPUdataOut := lastRead
  io.busy := (!io.ready && !rwReg) || (io.rw && memReq =/= 0.U)

  //io.alloAddr := (memWordAdd ## 0.U(2.W)) + rwIndex*4.U
  io.alloAddr := memAddReg(31,2 + m) ## rwIndex(m - 1, 0)*4.U
}



