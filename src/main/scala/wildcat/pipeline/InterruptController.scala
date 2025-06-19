// In src/main/scala/wildcat/pipeline/InterruptController.scala
package wildcat.pipeline

import chisel3._
import chisel3.util._
import wildcat.CSR

/**
 * Handles M-mode interrupt control logic.
 * Owns MIE and MIP registers, generates timer interrupts internally,
 * and provides clean interface for CSR access and trap handling.
 */
class InterruptController extends Module {
  val io = IO(new Bundle {
    // Interrupt Sources (hardware signals to generate interrupts)
    val mtime = Input(UInt(64.W))                     // Current mtime from TimerCounter
    val mtimecmp = Input(UInt(64.W))                  // Current mtimecmp from CLINT
    val externalInterrupt = Input(Bool())             // External interrupt source (for future expansion)
    val softwareInterrupt = Input(Bool())             // Software interrupt source (for future expansion)

    // Control from CSR module (only global enable from MSTATUS)
    val globalInterruptEnable = Input(Bool())         // MSTATUS.MIE bit

    // CSR interface for MIE/MIP registers (owned by this module)
    val mieWrite = Input(Bool())
    val mieWriteData = Input(UInt(32.W))
    val mieReadData = Output(UInt(32.W))
    val mipReadData = Output(UInt(32.W))

    // Outputs to Pipeline
    val interruptRequest = Output(Bool())
    val interruptCause = Output(UInt(32.W))

    // For trap handling (to update MSTATUS.MIE/MPIE in CSR module)
    val trapTaken = Input(Bool())
    val mretExecuting = Input(Bool())
    val disableInterrupts = Output(Bool()) // Tell CSR to clear MSTATUS.MIE
    val enableInterrupts = Output(Bool())  // Tell CSR to restore MSTATUS.MIE from MPIE

    // Additional outputs for WFI and debugging
    val timerInterruptEnabled = Output(Bool())
    val anyInterruptPending = Output(Bool())
  })

  // ============================================================================
  // Register Definitions (32-bit registers, not bit-by-bit)
  // ============================================================================

  // MIE Register - Machine Interrupt Enable (32-bit)
  val mieReg = RegInit(0.U(32.W))

  // MIP Register - Machine Interrupt Pending (32-bit, mostly read-only from software)
  val mipReg = RegInit(0.U(32.W))

  // ============================================================================
  // Interrupt Generation Logic (Internal)
  // ============================================================================

  // Timer interrupt generation (moved from TimerCounter)
  val timerInterruptPending = io.mtime >= io.mtimecmp && io.mtimecmp =/= 0.U

  // External interrupt (for future expansion)
  val externalInterruptPending = io.externalInterrupt

  // Software interrupt (for future expansion)
  val softwareInterruptPending = io.softwareInterrupt

  // Update MIP register with hardware-generated pending bits
  val mipUpdated = WireDefault(mipReg)
  mipUpdated := Cat(
    mipReg(31, 8),                    // Reserved bits [31:8]
    timerInterruptPending,            // MTIP - bit 7
    mipReg(6, 4),                     // Reserved bits [6:4]
    externalInterruptPending,         // MEIP - bit 3 (for future)
    mipReg(2, 1),                     // Reserved bits [2:1]
    softwareInterruptPending          // MSIP - bit 0 (for future)
  )
  mipReg := mipUpdated

  // ============================================================================
  // Interrupt Priority and Request Logic
  // ============================================================================

  // Extract individual enable bits from MIE register
  val timerInterruptEnabled = mieReg(7)      // MTIE - bit 7
  val externalInterruptEnabled = mieReg(3)   // MEIE - bit 3
  val softwareInterruptEnabled = mieReg(0)   // MSIE - bit 0

  // Interrupt request logic (priority: External > Software > Timer)
  val externalInterruptActive = io.globalInterruptEnable && externalInterruptEnabled && externalInterruptPending
  val softwareInterruptActive = io.globalInterruptEnable && softwareInterruptEnabled && softwareInterruptPending
  val timerInterruptActive = io.globalInterruptEnable && timerInterruptEnabled && timerInterruptPending

  // Generate interrupt request and cause (following RISC-V priority)
  val anyInterruptActive = externalInterruptActive || softwareInterruptActive || timerInterruptActive

  io.interruptRequest := anyInterruptActive
  io.interruptCause := MuxCase(0.U, Seq(
    externalInterruptActive -> 0x8000000B.U,  // Machine external interrupt
    softwareInterruptActive -> 0x80000003.U,  // Machine software interrupt
    timerInterruptActive    -> 0x80000007.U   // Machine timer interrupt
  ))

  // ============================================================================
  // CSR Interface (Read/Write Logic)
  // ============================================================================

  // MIE Register Read
  io.mieReadData := mieReg

  // MIP Register Read (always current hardware state)
  io.mipReadData := mipReg

  // MIE Register Write (using bit masks for clean implementation)
  when(io.mieWrite) {
    // Write mask: allow writing to standard interrupt enable bits
    val MIE_WRITE_MASK = 0x00000889.U  // MEIE(3), MTIE(7), MSIE(0), others reserved
    val MIE_WRITE_MASK_NEG = 0xFFFFF776.U
    mieReg := (io.mieWriteData & MIE_WRITE_MASK) | (mieReg & MIE_WRITE_MASK_NEG)
  }

  // Note: MIP register is read-only from software (hardware updates only)

  // ============================================================================
  // Trap Handling Logic
  // ============================================================================

  // Default: don't change interrupt state
  io.disableInterrupts := false.B
  io.enableInterrupts := false.B

  // When trap is taken, tell CSR module to disable global interrupts
  when(io.trapTaken) {
    io.disableInterrupts := true.B
  }

  // When MRET is executed, tell CSR module to restore interrupt state
  when(io.mretExecuting) {
    io.enableInterrupts := true.B
  }

  // ============================================================================
  // Additional Outputs
  // ============================================================================

  io.timerInterruptEnabled := timerInterruptEnabled
  io.anyInterruptPending := timerInterruptPending || externalInterruptPending || softwareInterruptPending
}