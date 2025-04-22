package Bootloader

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
    val memIO = Flipped(new TestMemIO())
    val stall = Output(Bool())
    val bootloading = Input(Bool())

    // To/From caches via bus
    val dCacheReqOut = Flipped(Decoupled(new TLRequest))
    val dCacheRspIn = Decoupled(new TLResponse)

    val iCacheReqOut = Flipped(Decoupled(new TLRequest))
    val iCacheRspIn = Decoupled(new TLResponse)

    // To/Form SPI controllers
    val SPIctrl = Vec(2, Flipped(new SpiCTRLIO)) // SPI0 is RAM0, SPI1 is RAM1, SPI2 is Flash
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




  val dReqAck = io.dCacheReqOut.valid && io.dCacheReqOut.ready // Request acknowledged
  val iReqAck = io.iCacheReqOut.valid && io.iCacheReqOut.ready
  val currentReq = Reg(new TLRequest()) // TileLink request format
  val dataSize = WireInit(4.U(3.W)) // Number of bytes to transfer
  val rspPending = RegInit(false.B)
  val data2write = WireInit(0.U(32.W))
  val readData = WireInit(0.U(32.W))
  val masterID = RegInit(false.B) // Master (cache) identifier
  val rspValid = WireInit(false.B)



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


  // Default settings for SPI controllers
  for (i <- 0 until 2) {
    io.SPIctrl(i).en := false.B
    io.SPIctrl(i).rw := currentReq.isWrite
    io.SPIctrl(i).rst := false.B
    io.SPIctrl(i).addr := currentReq.addrRequest(23, 0)
    io.SPIctrl(i).dataIn := data2write
    io.SPIctrl(i).size := dataSize
  }



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

  // Modify data to write
  when(currentReq.isWrite){
    // Compute dataSize based on number of active bits in the lane mask
    dataSize := MuxLookup(currentReq.activeByteLane, 1.U, Seq(
      15.U -> 4.U,
      12.U -> 2.U,
      3.U -> 2.U
    ))

    // Compute data2write based on the lowest set bit
    val shiftAmount = PriorityEncoder(currentReq.activeByteLane)
    data2write := (currentReq.dataRequest >> (shiftAmount * 8.U))

  }.otherwise{
    dataSize := 4.U // Standard for read
  }

  // Address decoding on response
  when(rspPending){
    when(currentReq.addrRequest(31, 28) === "hf".U) {
      //Do nothing cause memory mapped IO defined in Wildcattop?
    }.elsewhen(currentReq.addrRequest(24)) {
      // RAM 1 read/write
      io.SPIctrl(1).en := true.B

    }.elsewhen(!currentReq.addrRequest(24)) {
      // RAM 0 read/ write
      io.SPIctrl(0).en := true.B

    }.otherwise{
      // Flash read=?
    }
  }

  // Process responses
  for(i <- 0 until 2) {
    when(io.SPIctrl(i).done) {
      rspPending := false.B
      when(!currentReq.isWrite) {
        readData := io.SPIctrl(i).dataOut
      }
      rspValid := true.B
    }
  }


  when(rspValid){
    when(masterID){ // iCache requested
      io.iCacheRspIn.valid := true.B
    }.otherwise{ // dCache requested
      io.dCacheRspIn.valid := true.B
    }
  }

}
