// In src/main/scala/wildcat/pipeline/InterruptController.scala
package wildcat.pipeline

import chisel3._
import chisel3.util._
import wildcat.CSR // Assuming CSR definitions are here

/**
 * Handles M-mode interrupt control logic (mie, mip, mstatus.MIE).
 * Receives timer pending signal externally.
 */
class InterruptController extends Module {
  val io = IO(new Bundle {
    // CSR Interface (from Csr module for MSTATUS, MIE, MIP)
    val csrReadAddr    = Input(UInt(12.W))
    val csrWriteAddr   = Input(UInt(12.W))
    val csrWriteEnable = Input(Bool())
    val csrWriteData   = Input(UInt(32.W))
    val csrReadData    = Output(UInt(32.W)) // Data read for MSTATUS, MIE, MIP

    // Interrupt Source Inputs
    val timerInterruptPendingIn = Input(Bool()) // From TimerCounter via Csr
    // Add other interrupt source inputs here if needed

    // Interrupt Control Outputs (to Csr module)
    val interruptRequest = Output(Bool())
    val interruptCause   = Output(UInt(32.W))

    // Trap Handling Inputs (from Csr module)
    val takeTrap       = Input(Bool())
    val trapIsInterrupt= Input(Bool())
  })

  // Registers for Interrupt Control CSRs (MSTATUS.MIE, MIE, MIP)
  val mstatus_mie = RegInit(false.B)
  val mie_mtie    = RegInit(false.B) // Only Timer Enable bit for now
  val mip_mtip    = RegInit(false.B) // Only Timer Pending bit for now

  // Update mip.MTIP based on hardware signal
  mip_mtip := io.timerInterruptPendingIn
  // TODO: Update other MIP bits if software/external interrupts are added

  // Interrupt Request Logic
  val timerInterruptActive = mstatus_mie && mie_mtie && mip_mtip
  // TODO: Add logic for other interrupt sources
  io.interruptRequest := timerInterruptActive
  io.interruptCause := Mux(timerInterruptActive, "h80000007".U, 0.U)

  // CSR Read Logic (Only for MSTATUS, MIE, MIP)
  val readDataWire = WireDefault(0.U(32.W))
  switch(io.csrReadAddr) {
    is(CSR.MSTATUS.U) { readDataWire := Cat(0.U((31 - CSR.MSTATUS_MIE_BIT).W), mstatus_mie, 0.U(CSR.MSTATUS_MIE_BIT.W)) }
    is(CSR.MIE.U)     { readDataWire := Cat(0.U((31 - CSR.MIE_MTIE_BIT).W), mie_mtie, 0.U(CSR.MIE_MTIE_BIT.W)) }
    is(CSR.MIP.U)     { readDataWire := Cat(0.U((31 - CSR.MIP_MTIP_BIT).W), mip_mtip, 0.U(CSR.MIP_MTIP_BIT.W)) }
  }
  io.csrReadData := readDataWire

  // CSR Write Logic (Only for MSTATUS, MIE)
  when(io.csrWriteEnable) {
    when(io.csrWriteAddr === CSR.MSTATUS.U) {
      mstatus_mie := io.csrWriteData(CSR.MSTATUS_MIE_BIT)
    }
      .elsewhen(io.csrWriteAddr === CSR.MIE.U) {
        mie_mtie := io.csrWriteData(CSR.MIE_MTIE_BIT)
        // TODO: Add writes to other MIE bits if implemented
      }
    // MIP is read-only, ignore writes (already handled by addr check in Csr)
  }

  // Trap Handling Updates
  when(io.takeTrap) {
    mstatus_mie := false.B // Disable global interrupts on trap entry
  }
  // TODO: Add MRET logic to restore mstatus_mie from a saved MPIE bit if full MRET is implemented.

}