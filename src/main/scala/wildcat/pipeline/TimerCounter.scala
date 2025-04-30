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
class TimerCounter extends Module {
  val io = IO(new Bundle {
    // --- Inputs ---
    val instrComplete = Input(Bool())           // From pipeline
    val mtimecmpValue = Input(UInt(64.W))       // Value of mtimecmp read from the memory-mapped location (e.g., CLINT)


    // --- Outputs ---
    val cycle = Output(UInt(64.W))
    val time = Output(UInt(64.W))               // This acts as MTIME
    val instret = Output(UInt(64.W))
    val currentTime = Output(UInt(64.W))        // Current mtime value, provided to the memory-mapped interface (e.g., CLINT)

    // Interrupt signal to InterruptController (via Csr)
    val timerInterruptPending = Output(Bool())

    // --- MODIFIED: CSR Interface ---
    val csrAddr        = Input(UInt(12.W))
    val csrWriteEnable = Input(Bool())
    val csrWriteData   = Input(UInt(32.W))
    val csrReadData    = Output(UInt(32.W))     // For cycle, instret, time CSRs
  })

  // 64-bit counters
  val cycleReg   = RegInit(0.U(64.W))
  val timeReg    = RegInit(0.U(64.W)) // MTIME source
  val instretReg = RegInit(0.U(64.W))

  // Clock division logic (Existing)
  val cyclesPerTimeIncrement = 1000000 // Assuming 100MHz clock for 100Hz timer
  val timeCounter = RegInit(0.U(log2Ceil(cyclesPerTimeIncrement).W))

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

  // --- Timer Interrupt Comparison ---
  io.timerInterruptPending := (timeReg >= io.mtimecmpValue) && (io.mtimecmpValue =/= 0.U)

  // Output counter values
  io.cycle := cycleReg
  io.time := timeReg         // Provide mtime value
  io.instret := instretReg
  io.currentTime := timeReg  // Explicitly output current time for CLINT module

  // CSR Read logic (Handles only counters/timers)
  val readDataWire = WireDefault(0.U(32.W))
  switch(io.csrAddr) {
    // Existing counter reads... (TIME/TIMEH CSRs provide read-only view of timeReg)
    is(CSR.CYCLE.U)      { readDataWire := cycleReg(31, 0) }
    is(CSR.CYCLEH.U)     { readDataWire := cycleReg(63, 32) }
    is(CSR.TIME.U)       { readDataWire := timeReg(31, 0) }
    is(CSR.TIMEH.U)      { readDataWire := timeReg(63, 32) }
    is(CSR.INSTRET.U)    { readDataWire := instretReg(31, 0) }
    is(CSR.INSTRETH.U)   { readDataWire := instretReg(63, 32) }
    is(CSR.MCYCLE.U)     { readDataWire := cycleReg(31, 0) }
    is(CSR.MCYCLEH.U)    { readDataWire := cycleReg(63, 32) }
    is(CSR.MINSTRET.U)   { readDataWire := instretReg(31, 0) }
    is(CSR.MINSTRETH.U)  { readDataWire := instretReg(63, 32) }
  }
  io.csrReadData := readDataWire

  // CSR Write logic (Handles only writable counters/timers)
  when(io.csrWriteEnable) {
    switch(io.csrAddr) {
      // Existing writable counters...
      is(CSR.MCYCLE.U)     { cycleReg := Cat(cycleReg(63, 32), io.csrWriteData) }
      is(CSR.MCYCLEH.U)    { cycleReg := Cat(io.csrWriteData, cycleReg(31, 0)) }
      is(CSR.MINSTRET.U)   { instretReg := Cat(instretReg(63, 32), io.csrWriteData) }
      is(CSR.MINSTRETH.U)  { instretReg := Cat(io.csrWriteData, instretReg(31, 0)) }
    }
  }
}