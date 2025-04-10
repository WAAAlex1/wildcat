/*
 * Description: SPI controller for the memory part of pmod
 *  
 * Autor: Sofus Hammelsø
 */

package SPI

import chisel3._
import chisel3.util._

class SpiMemController extends Module {
    val io = IO(new Bundle{
        val rst = Input(Bool())
        val rw = Input(Bool())
        val en = Input(Bool())
        val addr = Input(UInt(24.W))
        val dataIn = Input(UInt(32.W))
        val dataOut = Output(UInt(32.W))
        val done = Output(Bool())      

        val ce = Output(Bool())
        val sclk = Output(Bool())
        val si = Output(Bool())
        val so = Input(Bool())
        val sioIn = Output(UInt(4.W))
        val sioOut = Input(UInt(4.W))        
    })

    object State extends ChiselEnum {
        val idle, enterQuadMode, read, write, doneState, rstEn, rst, deassertCS, assertCS, receiveData = Value
    }

    def delayCycles(n: Int) = {
        val counter = RegInit(0.U(log2Ceil(n + 1).W))
        val end = RegInit(false.B)

        when (!end) {
                counter := counter + 1.U
                when (counter === (n - 1).U) {
                    end := true.B
                }
            }
    }

    import State._
    val stateReg = RegInit(idle)

    val shiftRegIn = RegInit(0.U(32.W))
    val shiftRegOut = RegInit(0.U(32.W))
    val bitCounter = RegInit(0.U(6.W))
    val sclkReg = RegInit(false.B)
    val ceReg = RegInit(false.B)
    val dataInReg = RegInit(0.U(32.W))
    val quadReg = RegInit(false.B)

    val RST_CNT_MAX = 1.U
    val rstCnt = RegInit(0.U(1.W))
    when (stateReg === rst && ceReg) {
        rstCnt := rstCnt + 1.U
        when (rstCnt === RST_CNT_MAX) {
            rstCnt := 0.U
        }
    }

    io.sclk := sclkReg
    io.ce := ceReg
    
    io.si := shiftRegOut(31)
    io.sioIn := shiftRegOut(31, 28)
    shiftRegIn := shiftRegIn & Cat(0x0000000.U, io.sioOut)
    
    dataInReg := io.dataIn
    io.done := (stateReg === doneState)

    val shiftRstReg = RegInit(0.U(8.W))

    io.dataOut := 0.U

    switch (stateReg) {
        is (idle) {
            when (!quadReg) {
                // send cmd to enter quad mode
                // SI -> h35
                quadReg := true.B
                ceReg := false.B
                shiftRegOut := 0x35000000.U
                bitCounter := 7.U
                stateReg := enterQuadMode
                io.sioIn := shiftRegOut(31)
            }
            .elsewhen (io.rst) {
                ceReg := false.B
                shiftRegOut := 0x66000000.U
                bitCounter := 1.U
                stateReg := rstEn
            }
            .elsewhen (io.en) {
                ceReg := false.B
                when (io.rw) {
                    shiftRegOut := Cat(0x02.U, io.addr)
                    bitCounter := 15.U
                    stateReg := write
                } .otherwise {
                    shiftRegOut := Cat(0xEB.U, io.addr)
                    bitCounter := 7.U
                    stateReg := read
                }
            }
        }
        is (enterQuadMode) {
            io.sioIn := shiftRegOut(31)
            shiftRegOut := shiftRegOut << 1
            bitCounter := bitCounter - 1.U
            when (bitCounter === 0.U) {
                shiftRegOut := 0.U
                ceReg := true.B
                stateReg := doneState
            }
            

            
        }
        is (read) {
            // command 0xEB, 24 bit addr, wait 7 cycles for output
            
            shiftRegOut := shiftRegOut << 4
            bitCounter := bitCounter - 1.U
            when (bitCounter === 0.U) {
                delayCycles(6)
                bitCounter := 7.U
                stateReg := receiveData
            }
            
        }
        is (receiveData) {
 
            shiftRegIn := shiftRegIn << 4
            bitCounter := bitCounter - 1.U
            when (bitCounter === 0.U) {
                stateReg := doneState
            }
            
        }
        is (write) {

            shiftRegOut := shiftRegOut << 4
            bitCounter := bitCounter - 1.U
            when (bitCounter === 8.U) {
                //bitCounter := bitCounter + 1.U
                shiftRegOut := io.dataIn
            }
            when (bitCounter === 0.U) {
                ceReg := true.B
                stateReg := doneState
            }
            
        }
        is (doneState) {
            ceReg := true.B
            stateReg := idle
        }
        is (rstEn) {

            shiftRegOut := shiftRegOut << 4
            bitCounter := bitCounter - 1.U
            when (bitCounter === 0.U) {
                stateReg := deassertCS
                ceReg := true.B
            }
            
        }
        is (rst) {
            io.sioIn := shiftRstReg(7,4)

            shiftRstReg := shiftRstReg << 4
            bitCounter := bitCounter - 1.U
            when (bitCounter === 0.U) {
                stateReg := doneState
            }
            
        }
        is (deassertCS) {
            ceReg := false.B
            shiftRstReg := 0x99.U
            io.sioIn := shiftRstReg(7,4)
            bitCounter := 1.U
            stateReg := rst
        }
    }
}

object SpiMemController extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(new SpiMemController())
}