import chisel3._
import chisel3.util._

class CacheController() extends Module {
  val io = IO(new Bundle {
    val validReq = Input(Bool())
    val rw = Input(Bool())
    val memAdd = Input(UInt(32.W))
    val DI = Input(UInt(32.W))
    val DO = Output(UInt(32.W))
    val ready = Output(Bool())
    val memReady = Input(Bool())
    //val tagOut = Output(UInt(32.W))
    //val tagIn = Input(UInt(32.W))
    val cacheMiss = Output(Bool())
    //val cacheValid = Output(Bool())
    //val writeIdx = Output(UInt(3.W))
    //val stateAllocate = Output(Bool())
    //val stateCompare = Output(Bool())
    //val stateWait = Output(Bool())
    //val stateWriteT = Output(Bool())
    //val readTag = Output(UInt(32.W))
    //val cacheAdd = Output(UInt(10.W))
    //val memDI = Output(UInt(32.W))
    //val memDO = Output(UInt(32.W))
    //val cacheDI = Output(UInt(32.W))
    //val cacheDO = Output(UInt(32.W))
    //val cacheEN = Output(Bool())
    //val extMemAdd = Output(UInt(13.W))
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
  val writeDone = RegInit(true.B) // signals that the write (incl. write-through) is done
  val allocateDone = RegInit(true.B)
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
  //io.cacheValid := true.B
  io.cacheMiss := false.B
  //io.cacheDI := cache.io.DI
  //io.cacheDO := cache.io.DO
  //io.memDI := extMem.io.DI
  //io.memDO := extMem.io.DO




  extMem.io.DI := memDataIn
  cacheReadAdd := index ## blockOffset
  cacheWriteAdd := index ## writeIndex

  cache.io.ad := cacheAdd
  targetTagWord := targetTag << 12

  // Address lines
  tagStore.io.ad := index

  //actualTag := tagStore.io.DO(31, 12)
  //cacheValid := tagStore.io.DO(11)

  object State extends ChiselEnum {
    val idle, compareTag, allocate, writewait, writethrough = Value
  }

  import State._
  // The state register
  val stateReg = RegInit(idle)

  // Next state logic
  /*switch(stateReg){
    is (idle) {
      extMem.io.EN := false.B
      extMem.io.rw := true.B
      when(io.validReq){
        // Start to read tag
        cacheAdd := cacheReadAdd
        tagStore.io.rw := true.B
        tagStore.io.EN := true.B
        stateReg := compareTag

        when(io.rw) {
          // start Read stuff
          cache.io.rw := true.B
          cache.io.EN := true.B
          //io.DO := cache.io.DO

        }.otherwise {
          // write stuff
          cache.io.rw := false.B
          cache.io.DI := io.DI
        }

      }.otherwise{
        tagStore.io.EN := false.B // Stop reading tag
        cache.io.rw := true.B
        cache.io.EN := false.B


      }
    }
    is(compareTag){
      tagStore.io.EN := true.B
      when(!cacheValid){
        cacheAdd := cacheWriteAdd
        allocateDone := false.B
        cache.io.rw := false.B
        extMem.io.rw :=true.B
        extMem.io.EN := true.B
        stateReg := allocate
      }.elsewhen(actualTag === targetTag) { // cache hit
        cacheAdd := cacheReadAdd
        io.cacheHit := true.B
        cache.io.EN := true.B
        when(io.rw) {
          // Read stuff
          cache.io.rw := true.B
          //io.DO := cache.io.DO
          lastRead := cache.io.DO
          stateReg := idle
        }.otherwise {
          // write stuff
          writeDone := false.B
          cache.io.rw := false.B
          cache.io.DI := io.DI
          stateReg := writewait
        }
      }.otherwise { // cache miss
        cacheAdd := cacheWriteAdd
        io.cacheHit := false.B
        allocateDone := false.B
        stateReg := allocate
        cache.io.rw := false.B
        extMem.io.rw :=true.B
        extMem.io.EN := true.B
      }

    }
    is(writewait){
      extMem.io.EN := true.B
      cache.io.EN := true.B
      when(!writeDone && allocateDone) {
        cacheAdd := cacheReadAdd
        cache.io.rw := true.B
        stateReg := writethrough
      }.elsewhen(writeDone && allocateDone) {
        cacheAdd := cacheReadAdd
        memDataIn := cache.io.DO
        cache.io.rw := true.B
        //extMem.io.rw := false.B
        stateReg := idle
      }.elsewhen(!allocateDone){
        cacheAdd := cacheWriteAdd
        cache.io.DI := extMem.io.DO
        cache.io.rw := false.B
        extMem.io.rw := true.B
        writeIndex := 0.U
        allocateDone := true.B
        // begin to read tag
        tagStore.io.rw := true.B
        stateReg := compareTag

      }

    }
    is(writethrough){
      cache.io.rw := true.B
      cache.io.EN := true.B
      cacheAdd := cacheReadAdd
      extMem.io.rw := false.B
      extMem.io.EN := true.B
      //extMem.io.ad := io.memAdd
      memDataIn := cache.io.DO

      when(io.memReady){
        writeDone := true.B
        stateReg := writewait
      }
    }
    is(allocate){
      tagStore.io.EN := true.B
      // Fetch memory
      allocateDone := false.B
      cache.io.rw := false.B
      cache.io.EN := true.B
      cacheAdd := cacheWriteAdd
      extMem.io.rw := true.B
      extMem.io.EN := true.B
      extMem.io.ad := memWordAdd + writeIndex + 1.U // +1 since reading lags 1 cycle behind
      cache.io.DI := extMem.io.DO


      updatedTag := targetTagWord | "h800".U // Setting valid bit to 1

      when(io.memReady && writeIndex === 3.U){
        //Update tag store
        tagStore.io.rw := false.B
        stateReg := writewait
      }.elsewhen(!io.memReady && writeIndex === 3.U) {
        writeIndex := 3.U
      }.otherwise{
        writeIndex := writeIndex + 1.U
      }
    }
  }*/

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
          //io.DO := cache.io.DO

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
        //io.cacheHit := true.B

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
  //io.cacheValid := cacheValid
  //io.writeIdx := writeIndex
  //io.tagOut := updatedTag
  //tagStore.io.DI := io.tagOut
  tagStore.io.DI := updatedTag

  //io.stateWait := stateReg === writewait
  //io.stateCompare := stateReg === compareTag
  //io.stateAllocate := stateReg === allocate
  //io.stateWriteT := stateReg === writethrough
  //io.readTag := actualTag ## (cacheValid << 11)
  //io.cacheEN := cache.io.EN
  //io.cacheAdd := cache.io.ad

  io.DO := lastRead


  //io.extMemAdd := extMem.io.ad

}

object CacheController extends App {
  println("I will now generate the Verilog file")
  emitVerilog(new CacheController())
}

