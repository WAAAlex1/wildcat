package SPI

import chisel3._
import chisel3.util._

class QuadController extends Module {
    val io = IO(new Bundle {
        val txData = Input(UInt(64.W))
        val rxData = Output(UInt(32.W))

        val enable = Input(Bool())

        val sendLength = Input(UInt(7.W))
        val numWaitCycles = Input(UInt(7.W))
        val receiveLength = Input(UInt(7.W))

        val inSio = Input(UInt(4.W))
        val outSio = Output(UInt(4.W))
        val spiCs = Output(Bool())
        val spiClk = Output(Bool())

        val ready = Output(Bool())
        val done = Output(Bool())

        val prescale = Input(UInt(4.W))
        
        val dir = Output(Bool())
    })

    object State extends ChiselEnum {
        val idle, loadData, write, read, deassertCS = Value
    }
    import State._
    val stateReg = RegInit(idle)

    val spiDataOut = RegInit(0.U(32.W))
    io.rxData := spiDataOut

    val csReg = RegInit(true.B)
    io.spiCs := csReg

    val txShiftReg = RegInit(0.U(64.W))
    val rxShiftReg = RegInit(0.U(32.W))
    val bitCounter = RegInit(0.U(8.W))

    io.outSio := txShiftReg(63, 60)

    val clockEnable = RegInit(false.B)
    //val CNT_MAX = io.prescale
    val cntMax = (1.U << io.prescale).asUInt - 1.U
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
    } .otherwise {
        spiClkReg := false.B
    }
    io.spiClk := spiClkReg

    val spiClkRegPrev = RegNext(spiClkReg)
    val fallingEdge = !spiClkReg && spiClkRegPrev
    val risingEdge = spiClkReg && !spiClkRegPrev

    val totalCycles = Wire(UInt(10.W))
    totalCycles := io.sendLength + io.numWaitCycles + io.receiveLength

    val writeCycles = Wire(UInt(8.W))
    writeCycles := io.sendLength

    val waitReadCycles = Wire(UInt(8.W))
    waitReadCycles := io.numWaitCycles + io.receiveLength

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
            bitCounter := writeCycles - 1.U
            stateReg := write
        }
        is (write) {
            when (risingEdge) {
                txShiftReg := txShiftReg << 4
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
                bitCounter := bitCounter - 1.U
                rxShiftReg := (rxShiftReg >> 4).asUInt | (io.inSio << 28).asUInt
            }

            when (risingEdge) {
                when (bitCounter === 0.U) {
                    clockEnable := false.B
                    stateReg := deassertCS
                }
            }
        }
        is (deassertCS) {
            /*
            val reordered = Cat(
                rxShiftReg(31, 28), // n7
                rxShiftReg(3, 0),    // n0
                rxShiftReg(23, 20), // n4
                rxShiftReg(27, 24), // n6
                rxShiftReg(15, 12), // n2
                rxShiftReg(19, 16), // n5
                rxShiftReg(7, 4),   // n1
                rxShiftReg(11, 8),  // n3
            )
            //rxShiftReg := reordered | (io.inSio << 24).asUInt
            spiDataOut := reordered | (io.inSio << 24).asUInt
            io.rxData := reordered | (io.inSio << 24).asUInt
             */
            val reordered = Cat(
                rxShiftReg(27, 24), // n7
                rxShiftReg(31, 28), // n6
                rxShiftReg(19, 16), // n5
                rxShiftReg(23, 20), // n4
                rxShiftReg(11, 8),  // n3
                rxShiftReg(15, 12), // n2
                rxShiftReg(3, 0),   // n1
                rxShiftReg(7, 4)    // n0
            )
            spiDataOut := (reordered >> (32.U - io.receiveLength*4.U))

            csReg := true.B
            clockEnable := false.B
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
