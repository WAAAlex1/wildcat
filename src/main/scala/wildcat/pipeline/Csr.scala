// In src/main/scala/wildcat/pipeline/Csr.scala
package wildcat.pipeline

import chisel3._
import chisel3.util._
import wildcat.CSR

/**
 * Control and Status Registers File.
 * Handles CSR access, exception state saving (mepc, mcause, mtval, mtvec),
 * generic CSR storage, and interfaces with TimerCounter and InterruptController modules.
 * Includes forwarding logic and passes MRET signal to InterruptController.
 */
class Csr(freqHz: Int = 100000000) extends Module {
  val io = IO(new Bundle {
    // === INPUTS ===
    val readAddress    = Input(UInt(12.W))  // Address for read operation
    val writeAddress   = Input(UInt(12.W))  // Address for write operation
    val readEnable     = Input(Bool())      // Enable CSR read
    val writeEnable    = Input(Bool())      // Enable CSR write
    val writeData      = Input(UInt(32.W))  // Data to write
    val instrComplete  = Input(Bool())      // Signal instruction completion (for counters)

    // Exception/Trap Info from Pipeline
    val exceptionCause   = Input(UInt(32.W))  // The non-interrupt cause code
    val takeTrap         = Input(Bool())      // Trap (exception OR interrupt) is being taken this cycle
    val trapIsInterrupt  = Input(Bool())      // Indicates if the trap is an interrupt
    val trapPC           = Input(UInt(32.W))  // PC of trapped instruction
    val trapInstruction  = Input(UInt(32.W))  // The trapped instruction (for mtval on exception)
    val mtimecmpVal      = Input(UInt(64.W))  // From CLINT module
    val mret_executing   = Input(Bool())

    // === OUTPUTS ===
    val data         = Output(UInt(32.W)) // Data read from CSR (after forwarding)
    val mretTarget   = Output(UInt(32.W)) // MEPC value for MRET jump
    val trapVector   = Output(UInt(32.W)) // MTVEC value for trap handler jump
    val timerCounter = Output(UInt(64.W)) // TimerCounter to CLINT (TIMERCOUNTER->CSR->CPU->TOPLEVEL->CLINT)

    // Interrupt Request to Pipeline
    val interruptRequest = Output(Bool())   // An interrupt is pending and enabled
    val interruptCause   = Output(UInt(32.W)) // The specific interrupt cause
    val globalInterruptEnabled = Output(Bool())
    val timerInterruptEnabled = Output(Bool())
  })

  //----------------------------------------------------------------------------
  // Module Instantiations
  //----------------------------------------------------------------------------

  // Timer/Counter Module (Handles TIME, CYCLE, INSTRET CSRs)
  val timerCounter = Module(new TimerCounter(freqHz))
  timerCounter.io.instrComplete   := io.instrComplete
  timerCounter.io.csrAddr         := io.readAddress
  timerCounter.io.csrWriteEnable  := io.writeEnable && isCounterCSR(io.writeAddress) // Qualify write enable
  timerCounter.io.csrWriteData    := io.writeData
  timerCounter.io.mtimecmpValue   := io.mtimecmpVal
  io.timerCounter                 := timerCounter.io.currentTime

  // Interrupt Controller Module (Handles MSTATUS, MIE, MIP)
  val interruptController = Module(new InterruptController())
  interruptController.io.timerInterruptPendingIn := timerCounter.io.timerInterruptPending
  interruptController.io.csrReadAddr    := io.readAddress // Pass raw read address
  interruptController.io.csrWriteAddr   := io.writeAddress// Pass raw write address
  interruptController.io.csrWriteEnable := io.writeEnable && isInterruptCSR(io.writeAddress) // Qualify write enable
  interruptController.io.csrWriteData   := io.writeData
  interruptController.io.takeTrap       := io.takeTrap
  interruptController.io.mret_executing := io.mret_executing

  // Get interrupt request signals from InterruptController
  io.interruptRequest := interruptController.io.interruptRequest
  io.interruptCause   := interruptController.io.interruptCause

  //----------------------------------------------------------------------------
  // Register Definitions
  //----------------------------------------------------------------------------
  // Registers for Exception/Trap Handling & State
  val mepcReg   = RegInit(0.U(32.W))
  val mcauseReg = RegInit(0.U(32.W))
  val mtvalReg  = RegInit(0.U(32.W))
  val mtvecReg  = RegInit(0.U(32.W))

  // Standard read-only ID registers
  val marchidReg  = RegInit(CSR.WILDCAT_MARCHID.U(32.W))
  val mvendoridReg= RegInit(CSR.WILDCAT_VENDORID.U(32.W))
  val misaReg     = RegInit(CSR.WILDCAT_MISA.U(32.W))
  val hartidReg   = RegInit(0.U(32.W))

  //----------------------------------------------------------------------------
  // CSR Read Operation
  //----------------------------------------------------------------------------
  when(isInterruptCSR(io.readAddress))          { io.data := interruptController.io.csrReadData}
  .elsewhen(isCounterCSR(io.readAddress))       { io.data := timerCounter.io.csrReadData}
  // Read specific registers handled directly here
  .elsewhen(io.readAddress === CSR.MEPC.U)      { io.data := mepcReg }
  .elsewhen(io.readAddress === CSR.MCAUSE.U)    { io.data := mcauseReg }
  .elsewhen(io.readAddress === CSR.MTVAL.U)     { io.data := mtvalReg }
  .elsewhen(io.readAddress === CSR.MTVEC.U)     { io.data := mtvecReg }
  // Standard read-only ID registers
  .elsewhen(io.readAddress === CSR.MARCHID.U)   { io.data := marchidReg }
  .elsewhen(io.readAddress === CSR.MVENDORID.U) { io.data := mvendoridReg }
  .elsewhen(io.readAddress === CSR.MISA.U)      { io.data := misaReg }
  .elsewhen(io.readAddress === CSR.HARTID.U)    { io.data := hartidReg } // Assuming Hart ID 0
  // Default to reading 0
  .otherwise                                    { io.data := 0.U}

  //----------------------------------------------------------------------------
  // CSR Write Operation
  //
  // # Writes delegated to specialized modules. Only handled here for special regs.
  //
  //----------------------------------------------------------------------------
  when(io.writeEnable) {
    // Delegate writes to specialized modules
    when(isInterruptCSR(io.writeAddress))       { } // Write handled by InterruptController module
    .elsewhen(isCounterCSR(io.writeAddress))    { } // Write handled by TimerCounter module
    // Handle writes to specific registers directly
    .elsewhen(io.writeAddress === CSR.MEPC.U)   { mepcReg  := io.writeData & (~3.U(32.W)).asUInt } //alligned 4 byte
    .elsewhen(io.writeAddress === CSR.MCAUSE.U) { mcauseReg:= io.writeData }
    .elsewhen(io.writeAddress === CSR.MTVAL.U)  { mtvalReg := io.writeData }
    .elsewhen(io.writeAddress === CSR.MTVEC.U)  { mtvecReg := io.writeData & (~3.U(32.W)).asUInt } //alligned 4 byte
    // Default to not writing anything
    .otherwise {}
  }

  //----------------------------------------------------------------------------
  // Trap Handling Logic
  //
  // # When Trap taken update mcause, mtval, and mepc
  // # Traps are both exceptions and interrupts.
  //----------------------------------------------------------------------------
  when(io.takeTrap) {
    mepcReg := io.trapPC // Save PC of trapped instruction
    when(io.trapIsInterrupt) {
      mcauseReg := io.interruptCause // Cause comes from InterruptController
      mtvalReg  := 0.U               // mtval is zero for interrupts
    }.otherwise {
      // Exception Trap (use pipeline-provided cause)
      mcauseReg := io.exceptionCause // MSB should be 0 for exceptions
      mtvalReg  := io.trapInstruction // Save faulting instruction/address
    }
    printf("[Csr] Trap Taken: PC=0x%x, Cause=0x%x, isInterrupt=%b, mtval=0x%x\n", io.trapPC, Mux(io.trapIsInterrupt, io.interruptCause, io.exceptionCause), io.trapIsInterrupt, Mux(io.trapIsInterrupt, 0.U, io.trapInstruction))
  }

  //----------------------------------------------------------------------------
  // Other Outputs
  //----------------------------------------------------------------------------
  io.mretTarget := mepcReg // MRET jumps to mepc
  io.trapVector := mtvecReg // Exceptions and Interrupts jump to mtvec
  io.globalInterruptEnabled := interruptController.io.mstatusInterruptEnable
  io.timerInterruptEnabled := interruptController.io.timerInterruptEnabled

  //----------------------------------------------------------------------------
  // Helper Functions
  //----------------------------------------------------------------------------
  def isReadOnly(addr: UInt): Bool = {
    addr(11, 10) === "b11".U
  }

  def isCounterCSR(addr: UInt): Bool = {
    (addr === CSR.CYCLE.U)    ||  (addr === CSR.CYCLEH.U)   ||
    (addr === CSR.TIME.U)     ||  (addr === CSR.TIMEH.U)    ||
    (addr === CSR.INSTRET.U)  ||  (addr === CSR.INSTRETH.U) ||
    (addr === CSR.MCYCLE.U)   ||  (addr === CSR.MCYCLEH.U)  ||
    (addr === CSR.MINSTRET.U) ||  (addr === CSR.MINSTRETH.U)
  }

  def isInterruptCSR(addr: UInt): Bool = {
    (addr === CSR.MSTATUS.U) || (addr === CSR.MIE.U) || (addr === CSR.MIP.U)
  }

}