package spi

import Bootloader.SpiCTRLIO
import chisel3._
import chisel3.util._

class SpiControllerTop(prescale: UInt) extends Module {
    val io = IO(new Bundle {
        val inSio = Input(UInt(4.W))
        val outSio = Output(UInt(4.W))
        val spiClk = Output(Bool())

        val CS0 = Output(Bool())
        val CS1 = Output(Bool())
        val CS2 = Output(Bool())

        val moduleSel = Input(Vec(3, Bool())) // 0 for flash, 1 for psram a, 2 for psram b, (flash not working)

        // To/Form SPI top controller
        val SPIctrl = new SpiCTRLIO
        val startup = Output(Bool())

        val valid = Output(Bool())
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
    val dataRead = WireInit(0.U(32.W))
    val cmdReg = RegInit(0.U(8.W))
    val addrReg = RegInit(0.U(24.W))
    val dataReg = RegInit(0.U(32.W))
    val sendLengthReg = RegInit(0.U(7.W))
    val waitCyclesReg = RegInit(0.U(7.W))
    val receiveLengthReg = RegInit(0.U(7.W))
    val delayCounter = RegInit(0.U(32.W))
    val startupDone = RegInit(false.B)
    val dataOutReg = RegInit(0.U(32.W))
    io.SPIctrl.dataOut := dataOutReg

    // Flipping input data
    val dataInReg = RegInit(0.U(32.W))
    dataInReg := io.SPIctrl.dataIn

    val flippedDataIn = Wire(UInt(32.W))
    flippedDataIn := Cat((0 until 4).map(i => dataInReg(8 * (i + 1) - 1, 8 * i)))

    dataReg := Mux(io.SPIctrl.rw,flippedDataIn,0.U)

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

    io.CS0 := Mux(io.moduleSel(0),Mux(quadReg, QController.io.spiCs, SController.io.spiCs), true.B)
    io.CS1 := Mux(io.moduleSel(1),Mux(quadReg, QController.io.spiCs, SController.io.spiCs), true.B)
    io.CS2 := Mux(io.moduleSel(2),Mux(quadReg, QController.io.spiCs, SController.io.spiCs), true.B)

    txDataReg := Cat(cmdReg, addrReg, dataReg)

    SController.io.txData := Cat(cmdReg, addrReg, dataReg)
    SController.io.sendLength := sendLengthReg
    SController.io.numWaitCycles := waitCyclesReg
    SController.io.receiveLength := receiveLengthReg
    SController.io.prescale := prescale

    QController.io.txData := Cat(cmdReg, addrReg, dataReg)
    QController.io.sendLength := sendLengthReg
    QController.io.numWaitCycles := waitCyclesReg
    QController.io.receiveLength := receiveLengthReg
    QController.io.prescale := prescale

    SController.io.enable := false.B
    QController.io.enable := false.B

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
            when (delayCounter === 2.U + (16.U << prescale)) {
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
            when (io.SPIctrl.en && !io.SPIctrl.rw) {
                cmdReg := 0xEB.U
                addrReg := io.SPIctrl.addr
                sendLengthReg := 8.U
                waitCyclesReg := 7.U
                receiveLengthReg := io.SPIctrl.size * 2.U
                state := sActive
            }
            .elsewhen (io.SPIctrl.en && io.SPIctrl.rw) {
                cmdReg := 0x38.U
                addrReg := io.SPIctrl.addr
                sendLengthReg := 8.U + (io.SPIctrl.size * 2.U)
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
                startupDone := true.B
            }
        }
        is (sDone) {
            dataOutReg := dataRead
            io.SPIctrl.dataOut := dataRead
            state := sIdle
        }
    }

    io.SPIctrl.done := state === sDone
    io.valid := state === sIdle || state === sDone
    io.startup := !startupDone
}
