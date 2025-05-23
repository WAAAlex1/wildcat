package spi

import chisel3._
import chisel3.util._

class FinalTop extends Module {
    val io = IO(new Bundle {
        val inSio = Input(UInt(4.W))
        val outSio = Output(UInt(4.W))
        val spiClk = Output(Bool())

        val CS0 = Output(Bool())
        val CS1 = Output(Bool())
        val CS2 = Output(Bool())
        
        //val seg = Output(UInt(7.W))
        //val an = Output(UInt(4.W))

        val moduleSel = Input(UInt(2.W)) //0 for flash, 1 for psram a, 2 for psram b, (flash not working)

        val addrIn = Input(UInt(24.W))
        val dataIn = Input(UInt(32.W))
        val dataOut = Output(UInt(32.W))
        val dataLength = Input(UInt(6.W))

        val rw = Input(Bool()) // 0 for read, 1 for write
        //val switch = Input(Bool())
        val enable = Input(Bool())
        val ready = Output(Bool())
        val valid = Output(Bool())
        val done = Output(Bool())
        val dir = Output(Bool())
    })

    object State extends ChiselEnum {
        val startUp0, startUp1, startUp2, startUp3, sIdle, sActive, sWait, sDone = Value
    }
    import State._
    val state = RegInit(startUp0)

    val SController = Module(new SerialController)
    val QController = Module(new QuadController)

    val quadReg = RegInit(false.B)
    val txDataReg = RegInit(0.U(64.W))
    val dataRead = RegInit(0.U(32.W))
    val cmdReg = RegInit(0.U(8.W))
    val addrReg = RegInit(0.U(24.W))
    val dataReg = RegInit(0.U(32.W))
    val sendLengthReg = RegInit(0.U(7.W))
    val waitCyclesReg = RegInit(0.U(7.W))
    val receiveLengthReg = RegInit(0.U(7.W))
    val delayCounter = RegInit(0.U(32.W))

    val dataOutReg = RegInit(0.U(32.W))
    io.dataOut := dataOutReg

    when (quadReg) {
        io.outSio := QController.io.outSio
        QController.io.inSio := io.inSio
        io.spiClk := QController.io.spiClk
        dataRead := QController.io.rxData
        io.dir := QController.io.dir
        SController.io.spiMiso := 0.U
    } .otherwise {
        io.outSio := Cat(0.U(3.W), SController.io.spiMosi)
        SController.io.spiMiso := io.inSio(1)
        io.spiClk := SController.io.spiClk
        dataRead := SController.io.rxData
        io.dir := SController.io.dir
        QController.io.inSio := 0.U
    }

    when (io.moduleSel === 0.U) {
        io.CS0 := Mux(quadReg, QController.io.spiCs, SController.io.spiCs)
        io.CS1 := true.B
        io.CS2 := true.B       
    } .elsewhen (io.moduleSel === 1.U) {
        io.CS0 := true.B
        io.CS1 := Mux(quadReg, QController.io.spiCs, SController.io.spiCs)
        io.CS2 := true.B
    } .elsewhen (io.moduleSel === 2.U) {
        io.CS0 := true.B
        io.CS1 := true.B
        io.CS2 := Mux(quadReg, QController.io.spiCs, SController.io.spiCs)        
    } .otherwise {
        io.CS0 := true.B
        io.CS1 := true.B
        io.CS2 := true.B       
    }

    txDataReg := Cat(cmdReg, addrReg, dataReg)

    SController.io.txData := Cat(cmdReg, addrReg, dataReg)
    SController.io.sendLength := sendLengthReg
    SController.io.numWaitCycles := waitCyclesReg
    SController.io.receiveLength := receiveLengthReg
    SController.io.prescale := 1.U

    QController.io.txData := Cat(cmdReg, addrReg, dataReg)
    QController.io.sendLength := sendLengthReg
    QController.io.numWaitCycles := waitCyclesReg
    QController.io.receiveLength := receiveLengthReg
    QController.io.prescale := 1.U

    SController.io.enable := false.B
    QController.io.enable := false.B

    // display connection
    /*val display = Module(new SevenSegmentDisplay)
    io.seg := display.io.seg
    io.an := display.io.an

    when (io.switch) {
        display.io.hexDigits := VecInit(dataRead(19, 16), dataRead(23, 20), dataRead(27, 24), dataRead(31, 28))
    } .otherwise {
        display.io.hexDigits := VecInit(dataRead(3,0), dataRead(7,4), dataRead(11,8), dataRead(15,12))
    }*/

    switch (state) {
        is (startUp0) {
            delayCounter := delayCounter + 1.U
            when (delayCounter === 0xF.U) {
                cmdReg := 0x35.U
                addrReg := 0.U
                dataReg := 0.U
                sendLengthReg := 8.U
                waitCyclesReg := 0.U
                receiveLengthReg := 0.U
                state := startUp1
            }
        }
        is (startUp1) {
            delayCounter := 0.U
            SController.io.enable := true.B
            state := startUp2
        }
        is (startUp2) {
            when (SController.io.done) {
                quadReg := true.B
            }
            delayCounter := delayCounter + 1.U
            when (delayCounter === 0x35.U) {
                cmdReg := 0xC0.U
                addrReg := 0.U
                dataReg := 0.U
                sendLengthReg := 2.U
                waitCyclesReg := 0.U
                receiveLengthReg := 0.U
                state := startUp3
            }
        }
        is (startUp3) {
            delayCounter := 0.U
            QController.io.enable := true.B
            state := sWait
        }
        is (sIdle) {
            when (io.enable && !io.rw) {
                cmdReg := 0xEB.U
                addrReg := io.addrIn
                dataReg := 0.U
                sendLengthReg := 8.U
                waitCyclesReg := 6.U
                receiveLengthReg := 8.U
                state := sActive
            }
            .elsewhen (io.enable && io.rw) {
                cmdReg := 0x38.U
                addrReg := io.addrIn
                dataReg := io.dataIn
                sendLengthReg := 16.U
                waitCyclesReg := 0.U
                receiveLengthReg := 0.U
                state := sActive
            }
        }
        is (sActive) {
            QController.io.enable := true.B
            state := sWait
        }
        is (sWait) {
            when (QController.io.done) {
                state := sDone
            }
        }
        is (sDone) {
            dataOutReg := dataRead
            state := sIdle
        }
    }

    when (state === sIdle) {
        io.ready := true.B
    } .otherwise {
        io.ready := false.B
    }
    when (state === sDone) {
        io.done := true.B
    } .otherwise {
        io.done := false.B
    }
    when (state === sIdle || state === sDone) {
        io.valid := true.B
    } .otherwise {
        io.valid := false.B
    }
    
}

object FinalTop extends App {
    (new chisel3.stage.ChiselStage).emitVerilog(new FinalTop())
}