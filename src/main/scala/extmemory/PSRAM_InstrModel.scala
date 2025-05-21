package extmemory

import extmemory.SPICommands._
import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFileInline

/**
 * Hardware model to mimic PSRAM: APS6404L-3SQR
 *
 * Implemented as FSM with same timing behaviour as target module
 *
 * This version is preloaded with instructions.
 *
 * Author: Gustav Junker
 */


class PSRAM_InstrModel(nbytes: Int, code: Array[Int]) extends Module{
  val io = IO(new Bundle {
    val CS = Input(Bool())
    val IN = Input(UInt(4.W))
    val OUT = Output(UInt(4.W))
  })

  // code: Seq[Int] or Seq[BigInt] where each element is a 32-bit instruction
  val hexLines = code.flatMap { instr =>
    // Split the 32-bit instruction into 4 bytes, little-endian order
    val b0 = (instr & 0xff).toByte
    val b1 = ((instr >> 8) & 0xff).toByte
    val b2 = ((instr >> 16) & 0xff).toByte
    val b3 = ((instr >> 24) & 0xff).toByte
    Seq(b0, b1, b2, b3)
  }.map(b => f"${b & 0xff}%02x") // toUnsigned and format as two-digit hex
  val file = new java.io. PrintWriter ("code.hex")
  hexLines.foreach(line => file.println(line))
  file.close ()

   val mem = SyncReadMem(nbytes, UInt(8.W))
   loadMemoryFromFileInline(mem , "code.hex",firrtl. annotations . MemoryLoadFileType .Hex)

   val command = WireInit(0.U(8.W))
   val address = RegInit(0.U(24.W))
   val mode = RegInit(0.U(2.W)) // mode(0): 0 = SPI, 1 = QPI, mode(1): 0 = LINEAR BURST, 1 = WRAP
   val idx = RegInit(0.U(3.W))
   val lastRead = RegInit(0.U(8.W))
   val lastAddress = RegInit(0.U(24.W))
   val currentAddress = WireInit(0.U(24.W))
   val rw = RegInit(true.B) // read/write mode register
   val readMemVal = WireInit(0.U(8.W))
   val waitDone = RegInit(false.B)
   val val2Write = WireInit(0.U(8.W))
   val lastCommand = RegInit(0.U(8.W))



   lastRead := io.IN
   io.OUT := 0.U

   object State extends ChiselEnum {
     val idle, getAddress, read, write  = Value
   }

   import State._
   val stateReg = RegInit(idle)

   switch(stateReg){
     is(idle) {
       when(!io.CS) {
         when(!mode(0)) { // SPI mode
           lastRead := lastRead(6, 0) ## io.IN(0)
           command := lastRead(6, 0) ## io.IN(0)


         }.otherwise { // QPI mode
           lastRead := lastRead(3, 0) ## io.IN
           command := lastRead(3, 0) ## io.IN

           switch(lastCommand) {
             is(QPI_WRITE) {
               rw := false.B
               address := 0.U
               stateReg := getAddress
             }
             is(QPI_FAST_QUAD_READ) {
               rw := true.B
               address := 0.U
               stateReg := getAddress
             }
           }
         }
         lastCommand := command

       }
       switch(lastCommand) {
         is(QUAD_MODE_ENABLE) {
           mode := mode | 1.U
         }
         is(QUAD_MODE_EXIT) {
           mode := mode & 0.U
         }
         is(WRAP_BOUNDARY_TOGGLE) {
           mode := mode | 2.U
         }

     }

     }
     is(getAddress){
       when(!io.CS) {
         lastAddress := lastAddress(19,0) ## io.IN
         currentAddress := lastAddress(19,0) ## io.IN

         when(idx === 5.U) {
           address := lastAddress
           idx := 0.U
           lastAddress := 0.U
           when(rw){
             stateReg := read
             waitDone := false.B
           }.otherwise{
             stateReg := write
           }
         }.otherwise{
           idx := idx + 1.U
         }
       }.otherwise {
         stateReg := idle
       }
     }
     is(read){
       when(!io.CS) {
         readMemVal := mem.read(address)
         when(!waitDone) {
           when(idx === 5.U) { // Wait cycles
             waitDone := true.B

             idx := 0.U
           }.otherwise {
             idx := idx + 1.U
           }
         }.otherwise{ // Read after waiting 7 cycles

           when(idx === 1.U){
             io.OUT := readMemVal(3,0)
             idx := 0.U
           }.otherwise{
             io.OUT := readMemVal(7,4)
             idx := idx + 1.U
             address := address + 1.U
           }
         }


       }.otherwise {
         idx := 0.U
         stateReg := idle
       }
     }
     is(write){
       when(!io.CS) {
         lastRead := lastRead(3,0) ## io.IN
         val2Write := lastRead(3,0) ## io.IN
         when(idx === 1.U) {
           mem.write(address,lastRead)
           idx := 0.U
           address := address + 1.U
           lastRead := io.IN
         }.otherwise {
           idx := idx + 1.U
         }

       }.otherwise {
         stateReg := idle
       }
     }
   }

}
