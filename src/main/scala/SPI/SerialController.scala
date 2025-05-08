package SPI

import chisel3._
import chisel3.util._

class SerialController extends Module {
    val io = IO(new Bundle {
        val txData = Input(UInt(64.W))
        val rxData = Output(UInt(32.W))

        val enable = Input(Bool())

        val sendLength = Input(UInt(9.W))
        val numWaitCycles = Input(UInt(9.W))
        val receiveLength = Input(UInt(9.W))

        val spiMiso = Input(Bool())
        val spiMosi = Output(Bool())
        val spiCs = Output(Bool())
        val spiClk = Output(Bool())

        val ready = Output(Bool())
        val done = Output(Bool())

        val prescale = Input(UInt(5.W))
        val dir = Output(Bool())
    })

    object State extends ChiselEnum {
        val idle, loadData, read, write, deassertCS = Value
    }

    import State._
    val stateReg = RegInit(idle)

    val spiDataOut = RegInit(0.U(32.W))
    io.rxData := spiDataOut

    val txShiftReg = RegInit(0.U(64.W))
    val rxShiftReg = RegInit(0.U(32.W))
    val bitCounter = RegInit(0.U(8.W))

    val csReg = RegInit(true.B)
    io.spiCs := csReg

    io.spiMosi := txShiftReg(63)

    val clockEnable = RegInit(false.B)
    val cntMax = (1.U << io.prescale) - 1.U
    val cntClk = RegInit(0.U(33.W))
    val spiClkReg = RegInit(false.B)

    /*when (clockEnable) {
        when (io.prescale =/= 0.U) {
            cntClk := cntClk + 1.U
            when (cntClk === CNT_MAX) {
                cntClk := 0.U
                spiClkReg := !spiClkReg
            }
        } .otherwise {
            spiClkReg := false.B
        }
    }*/

    when (clockEnable) {
        when (io.prescale =/= 1.U) {
            cntClk := cntClk + 1.U

            when (cntClk === cntMax) {
                cntClk := 0.U
                spiClkReg := ~spiClkReg  // toggle the SPI clock
            }
        } .otherwise {
            spiClkReg := !spiClkReg  // direct pass-through (always high)
        }
    }

    io.spiClk := spiClkReg

    val spiClkRegPrev = RegNext(spiClkReg)
    val fallingEdge = !spiClkReg && spiClkRegPrev
    val risingEdge = spiClkReg && !spiClkRegPrev

    val totalCycles = Wire(UInt(10.W))
    totalCycles := io.sendLength + io.receiveLength + io.numWaitCycles

    val writeCycles = Wire(UInt(8.W))
    writeCycles := io.sendLength

    val waitReadCycles = Wire(UInt(8.W))
    waitReadCycles := io.numWaitCycles + io.receiveLength    

    io.rxData := spiDataOut

    switch (stateReg) {
        is (idle) {
            when (io.enable) {
                stateReg := loadData
            }
        }
        is (loadData) {
            csReg := false.B
            clockEnable := true.B
            txShiftReg := io.txData
            bitCounter := totalCycles - 1.U
            stateReg := write
        }
        is (write) {

            when (risingEdge) {
                txShiftReg := txShiftReg << 1
                bitCounter := bitCounter - 1.U
                when (bitCounter === 0.U) {
                    bitCounter := waitReadCycles
                    when (io.receiveLength === 0.U) {
                        clockEnable := false.B
                        stateReg := deassertCS
                    } .otherwise {
                        stateReg := read
                    }
                } 
            }

        }
        is (read) {
            when (fallingEdge) {
                rxShiftReg := (rxShiftReg << 1) | io.spiMiso
                bitCounter := bitCounter - 1.U
            }

            when (risingEdge) {
                when (bitCounter === 0.U) {
                    stateReg := deassertCS
                }
            }
        }
        is (deassertCS) {
            spiDataOut := rxShiftReg
            clockEnable := false.B
            csReg := true.B
            stateReg := idle
        }
    }


    when (stateReg === idle) {
        io.ready := true.B
    } .otherwise {
        io.ready := false.B
    }

    when (stateReg === deassertCS) {
        io.done := true.B
    } .otherwise {
        io.done := false.B
    }

    io.dir := Mux(stateReg === read, false.B, true.B)
}
