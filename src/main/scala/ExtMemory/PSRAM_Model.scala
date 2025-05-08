package ExtMemory

import SPICommands._
import chisel3._
import chisel3.util._

/**
 * Hardware model to mimic PSRAM: APS6404L-3SQR
 *
 * Implemented as FSM with same timing behaviour as target module
 *
 * TODO:
 *
 * Author: Gustav Junker
 */


class PSRAM_Model (nbytes: Int) extends Module{
  val io = IO(new Bundle {
    val CS = Input(Bool())
    val IN = Input(UInt(4.W))
    val OUT = Output(UInt(4.W))
  })



   val mem = SyncReadMem(nbytes, UInt(8.W))
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

           switch(command) {
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
           address := currentAddress
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
           when(idx === 7.U) { // Wait cycles
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
         stateReg := idle
       }
     }
     is(write){
       when(!io.CS) {
         lastRead := lastRead(3,0) ## io.IN
         val2Write := lastRead(3,0) ## io.IN
         when(idx === 1.U) {
           mem.write(address,val2Write)
           idx := 0.U
           address := address + 1.U
           lastRead := 0.U
         }.otherwise {
           idx := idx + 1.U
         }

       }.otherwise {
         stateReg := idle
       }
     }
   }

}
