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
    val externalInterrupt = Input(Bool())

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
  // Register Definitions
  //----------------------------------------------------------------------------
  // MSTATUS Register (32-bit, we manage MSTATUS here, not in InterruptController)
  val mstatusReg = RegInit(0x1800.U(32.W))  // Initialize with MPIE=1, MIE=0, MPP=11 (machine mode)

  // Registers for Exception/Trap Handling & State
  val mepcReg   = RegInit(0.U(32.W))
  val mcauseReg = RegInit(0.U(32.W))
  val mtvalReg  = RegInit(0.U(32.W))
  val mtvecReg  = RegInit(0.U(32.W))

  // Machine mode registers
  val mscratchReg = RegInit(0.U(32.W))          // Machine scratch register
  val satpReg     = RegInit(0.U(32.W))          // Supervisor address translation (implemented as simple register)

  // Standard read-only ID registers
  val marchidReg  = RegInit(CSR.WILDCAT_MARCHID.U(32.W))
  val mvendoridReg= RegInit(CSR.WILDCAT_VENDORID.U(32.W))
  val misaReg     = RegInit(CSR.WILDCAT_MISA.U(32.W))

  // Hardwired read-only registers (always return 0)
  val hartidReg   = RegInit(0.U(32.W))          // Hartid (for single hart processors hardwired to 0)
  val mimpidReg   = 0.U(32.W)                   // Implementation ID (hardwired to 0)
  val mconfigptrReg = 0.U(32.W)                 // Configuration pointer (hardwired to 0)

  //----------------------------------------------------------------------------
  // Module Instantiations
  //----------------------------------------------------------------------------
  // Timer/Counter Module (Handles TIME, CYCLE, INSTRET CSRs)
  val timerCounter = Module(new TimerCounter(freqHz))
  timerCounter.io.instrComplete   := io.instrComplete
  timerCounter.io.csrAddr         := io.readAddress
  timerCounter.io.csrWriteEnable  := io.writeEnable && isCounterCSR(io.writeAddress)
  timerCounter.io.csrWriteData    := io.writeData
  io.timerCounter                 := timerCounter.io.currentTime

  // Interrupt Controller Module (Handles MIE, MIP, interrupt generation)
  val interruptController = Module(new InterruptController())
  interruptController.io.mtime              := timerCounter.io.currentTime
  interruptController.io.mtimecmp           := io.mtimecmpVal
  interruptController.io.externalInterrupt := io.externalInterrupt
  interruptController.io.softwareInterrupt  := false.B // For future expansion
  interruptController.io.globalInterruptEnable := mstatusReg(3) // MSTATUS.MIE bit
  interruptController.io.mieWrite           := io.writeEnable && (io.writeAddress === CSR.MIE.U)
  interruptController.io.mieWriteData       := io.writeData
  interruptController.io.trapTaken          := io.takeTrap
  interruptController.io.mretExecuting      := io.mret_executing

  // Get interrupt request signals from InterruptController
  io.interruptRequest := interruptController.io.interruptRequest
  io.interruptCause   := interruptController.io.interruptCause

  //----------------------------------------------------------------------------
  // CSR Read Operation
  //----------------------------------------------------------------------------
  when(io.readEnable) {
    when(io.readAddress === CSR.MSTATUS.U)    { io.data := mstatusReg }
      .elsewhen(io.readAddress === CSR.MIE.U)   { io.data := interruptController.io.mieReadData }
      .elsewhen(io.readAddress === CSR.MIP.U)   { io.data := interruptController.io.mipReadData }
      .elsewhen(isCounterCSR(io.readAddress))   { io.data := timerCounter.io.csrReadData }
      // Read specific registers handled directly here
      .elsewhen(io.readAddress === CSR.MEPC.U)  { io.data := mepcReg }
      .elsewhen(io.readAddress === CSR.MCAUSE.U){ io.data := mcauseReg }
      .elsewhen(io.readAddress === CSR.MTVAL.U) { io.data := mtvalReg }
      .elsewhen(io.readAddress === CSR.MTVEC.U) { io.data := mtvecReg }
      .elsewhen(io.readAddress === CSR.MSCRATCH.U) { io.data := mscratchReg }
      .elsewhen(io.readAddress === CSR.SATP.U)  { io.data := satpReg }
      // Standard read-only ID registers
      .elsewhen(io.readAddress === CSR.MARCHID.U)   { io.data := marchidReg }
      .elsewhen(io.readAddress === CSR.MVENDORID.U) { io.data := mvendoridReg }
      .elsewhen(io.readAddress === CSR.MISA.U)      { io.data := misaReg }
      .elsewhen(io.readAddress === CSR.HARTID.U)    { io.data := hartidReg }
      .elsewhen(io.readAddress === CSR.MIMPID.U)    { io.data := mimpidReg }
      .elsewhen(io.readAddress === CSR.MCONFIGPTR.U){ io.data := mconfigptrReg }
      // Default to reading 0
      .otherwise                                    { io.data := 0.U}
  }.otherwise {
    io.data := 0.U  // When read is disabled, output 0
  }

  //----------------------------------------------------------------------------
  // CSR Write Operation
  //----------------------------------------------------------------------------
  when(io.writeEnable) {
    // Handle MSTATUS writes (using bit mask for clean implementation)
    when(io.writeAddress === CSR.MSTATUS.U) {
      val MSTATUS_WRITE_MASK = "h00001888".U  // Allow writing MIE(3), MPIE(7), MPP(12:11)
      mstatusReg := (io.writeData & MSTATUS_WRITE_MASK) | (mstatusReg & (~MSTATUS_WRITE_MASK).asUInt)
    }
      // MIE and MIP writes are handled by InterruptController
      .elsewhen(io.writeAddress === CSR.MIE.U)     { } // Handled by InterruptController
      .elsewhen(io.writeAddress === CSR.MIP.U)     { } // Read-only register, ignore writes
      .elsewhen(isCounterCSR(io.writeAddress))     { } // Handled by TimerCounter module
      // Handle writes to specific registers directly
      .elsewhen(io.writeAddress === CSR.MEPC.U)    { mepcReg  := io.writeData & (~3.U(32.W)).asUInt } // 4-byte aligned
      .elsewhen(io.writeAddress === CSR.MCAUSE.U)  { mcauseReg:= io.writeData }
      .elsewhen(io.writeAddress === CSR.MTVAL.U)   { mtvalReg := io.writeData }
      .elsewhen(io.writeAddress === CSR.MTVEC.U)   { mtvecReg := io.writeData & (~3.U(32.W)).asUInt } // 4-byte aligned
      .elsewhen(io.writeAddress === CSR.MSCRATCH.U){ mscratchReg := io.writeData }
      .elsewhen(io.writeAddress === CSR.SATP.U)    { satpReg := io.writeData }
      // Read-only registers (ignore writes)
      .elsewhen(io.writeAddress === CSR.MARCHID.U)   { } // Read-only
      .elsewhen(io.writeAddress === CSR.MVENDORID.U) { } // Read-only
      .elsewhen(io.writeAddress === CSR.MISA.U)      { } // Read-only (could be made writable with mask)
      .elsewhen(io.writeAddress === CSR.HARTID.U)    { } // Read-only
      .elsewhen(io.writeAddress === CSR.MIMPID.U)    { } // Read-only (hardwired)
      .elsewhen(io.writeAddress === CSR.MCONFIGPTR.U){ } // Read-only (hardwired)
      // Default to not writing anything (read-only or non-existent registers)
      .otherwise {}
  }

  //----------------------------------------------------------------------------
  // MSTATUS Update Logic (from InterruptController signals)
  //----------------------------------------------------------------------------

  // Handle interrupt disable on trap entry
  when(interruptController.io.disableInterrupts) {
    // Save current MIE to MPIE, then clear MIE
    mstatusReg := Cat(
      mstatusReg(31, 8),      // Preserve upper bits
      mstatusReg(3),          // MPIE = current MIE (bit 7 = bit 3)
      mstatusReg(6, 4),       // Preserve bits 6:4
      false.B,                // MIE = 0 (bit 3)
      mstatusReg(2, 0)        // Preserve lower bits
    )
  }

  // Handle interrupt enable on MRET
  when(interruptController.io.enableInterrupts) {
    // Restore MIE from MPIE, set MPIE to 1
    mstatusReg := Cat(
      mstatusReg(31, 8),      // Preserve upper bits
      true.B,                 // MPIE = 1 (bit 7)
      mstatusReg(6, 4),       // Preserve bits 6:4
      mstatusReg(7),          // MIE = current MPIE (bit 3 = bit 7)
      mstatusReg(2, 0)        // Preserve lower bits
    )
  }

  //----------------------------------------------------------------------------
  // Trap Handling Logic
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
  io.globalInterruptEnabled := mstatusReg(3) // MSTATUS.MIE bit
  io.timerInterruptEnabled := interruptController.io.timerInterruptEnabled

  //----------------------------------------------------------------------------
  // Helper Functions
  //----------------------------------------------------------------------------
  def isCounterCSR(addr: UInt): Bool = {
    (addr === CSR.CYCLE.U)    ||  (addr === CSR.CYCLEH.U)   ||
    (addr === CSR.TIME.U)     ||  (addr === CSR.TIMEH.U)    ||
    (addr === CSR.INSTRET.U)  ||  (addr === CSR.INSTRETH.U) ||
    (addr === CSR.MCYCLE.U)   ||  (addr === CSR.MCYCLEH.U)  ||
    (addr === CSR.MINSTRET.U) ||  (addr === CSR.MINSTRETH.U)
  }

}