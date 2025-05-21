package extmemory

import SPICommands._
import chisel3._
import chisel3.util._

/**
 * Hardware model to mimic Flash: 25Q128JVSM
 *
 * Implemented as FSM with same timing behaviour as target module
 *
 * TODO: finish reading and writing og registers + data
 *
 * Author: Gustav Junker
 */


class Flash_Model (nbytes: Int) extends Module{
  val io = IO(new Bundle {
    val CS = Input(Bool())
    val IN = Input(UInt(4.W))
    val OUT = Output(UInt(4.W))
    val dir = Output(Bool()) // Direction control for each IO line
  })


  val mem = SyncReadMem(nbytes, UInt(8.W))
  val command = WireInit(0.U(8.W))
  val address = RegInit(0.U(24.W))
  val mode = RegInit(0.U(1.W)) // mode register: 0 = SPI, 1 = QPI
  val idx = RegInit(0.U(3.W))
  val lastRead = RegInit(0.U(24.W))
  val rw = RegInit(true.B) // read/write mode register
  val readMemVal = WireInit(0.U(8.W))
  val waitDone = RegInit(false.B)
  val val2Write = WireInit(0.U(8.W))
  val lastCommand = RegInit(0.U(8.W))
  val writeEnable = RegInit(false.B)
  val status1 = RegInit(0.U(8.W))
  val status2 = RegInit(0.U(8.W))
  val writeRegVal = WireInit(0.U(8.W))

  lastRead := io.IN
  io.dir := DontCare
  io.OUT := 0.U

  object State extends ChiselEnum {
    val idle, getAddress, readData, writeData,readRegister1, writeRegister2  = Value
  }

  import State._
  val stateReg = RegInit(idle)

  switch(stateReg){
    is(idle){
      when(!io.CS){
        lastRead := lastRead ## io.IN(0)
        command := lastRead ## io.IN(0)

        when(idx === 7.U) {
          lastRead := 0.U
          idx := 0.U
          lastCommand := command
          switch(command) {
            is(READ_STATUS_REGISTER_1){
              stateReg := readRegister1
            }
            is(WRITE_STATUS_REGISTER_2){
              when(status1(1)){
                status1(0) := true.B
                stateReg := writeRegister2
              }
            }
            is(FAST_READ_QUAD_IO){
              when(status2(1)){
                rw := true.B
                address := 0.U
                stateReg := getAddress
              }
            }
            is(QUAD_INPUT_PAGE_PROGRAM){
              when(status2(1)){
                status1(0) := true.B
                rw := false.B
                address := 0.U
                stateReg := getAddress
              }
            }
          }
        }.otherwise {
          idx := idx + 1.U
        }
      }.otherwise{
        switch(lastCommand){
          is(WRITE_ENABLE){ status1(1) := true.B }
          is(WRITE_DISABLE){ status1(1) := false.B }
        }
      }
    }
    is(readRegister1){
      when(!io.CS){
        io.OUT := status1(7.U-idx)

        when(idx === 7.U) {
          lastRead := 0.U
          idx := 0.U
          stateReg := idle
        }.otherwise{
          idx := idx + 1.U
        }
      }.otherwise{
        stateReg := idle
      }
    }
    is(writeRegister2){
      when(!io.CS){
        status2(7.U-idx) := io.IN(0)

        when(idx === 7.U) {
          lastRead := 0.U
          idx := 0.U
          status1(0) := false.B // no longer busy
          status1(1) := false.B // WEL low
          stateReg := idle
        }.otherwise{
          idx := idx + 1.U
        }
      }.otherwise{
        stateReg := idle
      }
    }

    is(getAddress){
      when(!io.CS) {
        address := address ## io.IN

        when(idx === 5.U) {
          idx := 0.U
          when(rw){
            stateReg := readData
            waitDone := false.B
          }.otherwise{
            stateReg := writeData
          }
        }.otherwise{
          idx := idx + 1.U
        }
      }.otherwise {
        stateReg := idle
      }
    }
    is(readData){
      when(!io.CS) {
        readMemVal := mem.read(address)
        when(!waitDone) {
          when(idx === 7.U) { // Wait cycles
            waitDone := true.B

            idx := 0.U
          }.otherwise {
            idx := idx + 1.U
          }
        }.otherwise{ // Read continuesly
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
    is(writeData){
      when(!io.CS) {
        lastRead := lastRead ## io.IN
        val2Write := lastRead ## io.IN
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

