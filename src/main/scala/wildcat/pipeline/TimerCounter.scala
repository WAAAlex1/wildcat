// In src/main/scala/wildcat/pipeline/TimerCounter.scala
package wildcat.pipeline

import chisel3._
import chisel3.util._
import wildcat.CSR // Import CSR definitions

/**
 * Timer and Counter module for the Wildcat processor.
 * Implements standard counters. mtimecmp is now handled externally
 * via memory-mapped access (e.g., through a CLINT module).
 */
class TimerCounter(freqHz: Int = 100000000, timerFreqHz: Int = 100) extends Module {
  require(freqHz >= timerFreqHz, "freqHz must be greater or equal to timerFreqHz to avoid division issues in TimerCounter")
  val io = IO(new Bundle {
    // --- Inputs ---
    val instrComplete = Input(Bool())           // From pipeline

    // --- Outputs ---
    val cycle = Output(UInt(64.W))
    val instret = Output(UInt(64.W))
    val currentTime = Output(UInt(64.W))        // Current mtime value, provided to the memory-mapped interface (e.g., CLINT)

    // --- CSR Interface ---
    val csrAddr        = Input(UInt(12.W))
    val csrWriteEnable = Input(Bool())
    val csrWriteData   = Input(UInt(32.W))
    val csrReadData    = Output(UInt(32.W))     // For cycle, instret, time CSRs
  })

  // 64-bit counters
  val cycleReg   = RegInit(0.U(64.W))
  val timeReg    = RegInit(0.U(64.W)) // MTIME source
  val instretReg = RegInit(0.U(64.W))

  // Clock division logic for TIME/MTIME
  val cyclesPerTimeIncrement = freqHz / timerFreqHz // Assuming 100MHz clock for 100Hz timer
  val timeCounter = RegInit(0.U(log2Ceil(cyclesPerTimeIncrement).W))

  // Update Counters
  cycleReg := cycleReg + 1.U
  when(timeCounter === (cyclesPerTimeIncrement - 1).U) {
    timeCounter := 0.U
    timeReg := timeReg + 1.U
  }.otherwise {
    timeCounter := timeCounter + 1.U
  }
  when(io.instrComplete) {
    instretReg := instretReg + 1.U
  }

  // Output assignments
  io.cycle := cycleReg
  io.instret := instretReg
  io.currentTime := timeReg  // Explicitly output current time for CLINT module

  // CSR Read Logic
  val readDataWire = WireDefault(0.U(32.W))
  switch(io.csrAddr) {
    // CYCLE and MCYCLE (same counter)
    is(CSR.CYCLE.U)    { readDataWire := cycleReg(31, 0) }
    is(CSR.CYCLEH.U)   { readDataWire := cycleReg(63, 32) }
    is(CSR.MCYCLE.U)   { readDataWire := cycleReg(31, 0) }
    is(CSR.MCYCLEH.U)  { readDataWire := cycleReg(63, 32) }

    // TIME (read-only, no machine mode equivalent for writing)
    is(CSR.TIME.U)     { readDataWire := timeReg(31, 0) }
    is(CSR.TIMEH.U)    { readDataWire := timeReg(63, 32) }

    // INSTRET and MINSTRET (same counter)
    is(CSR.INSTRET.U)  { readDataWire := instretReg(31, 0) }
    is(CSR.INSTRETH.U) { readDataWire := instretReg(63, 32) }
    is(CSR.MINSTRET.U) { readDataWire := instretReg(31, 0) }
    is(CSR.MINSTRETH.U){ readDataWire := instretReg(63, 32) }
  }
  io.csrReadData := readDataWire

  // CSR Write Logic (only machine mode counters are writable)
  when(io.csrWriteEnable) {
    switch(io.csrAddr) {
      // MCYCLE write (low and high)
      is(CSR.MCYCLE.U)   { cycleReg := Cat(cycleReg(63, 32), io.csrWriteData) }
      is(CSR.MCYCLEH.U)  { cycleReg := Cat(io.csrWriteData, cycleReg(31, 0)) }

      // MINSTRET write (low and high)
      is(CSR.MINSTRET.U) { instretReg := Cat(instretReg(63, 32), io.csrWriteData) }
      is(CSR.MINSTRETH.U){ instretReg := Cat(io.csrWriteData, instretReg(31, 0)) }

      // TIME/TIMEH are read-only (no writes allowed)
      // CYCLE/CYCLEH and INSTRET/INSTRETH are read-only user mode aliases
    }
  }

}