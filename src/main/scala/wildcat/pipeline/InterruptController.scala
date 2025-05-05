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
    val mstatusInterruptEnable = Output(Bool())

    // Trap Handling Inputs (from Csr module)
    val takeTrap       = Input(Bool())
    val trapIsInterrupt= Input(Bool())

    // MRET Execution Signal
    val mret_executing = Input(Bool())
  })

  // Registers for Interrupt Control CSRs (MSTATUS.MIE, MIE, MIP)
  val mstatus_mie = RegInit(false.B)
  val mstatus_mpie = RegInit(true.B) // Machine Previous Interrupt Enable - Start enabled (as per spec)
  val mie_mtie    = RegInit(false.B) // Only Timer Enable bit for now
  val mip_mtip    = RegInit(false.B) // Only Timer Pending bit for now

  // Update mip.MTIP based on hardware signal
  mip_mtip := io.timerInterruptPendingIn

  // Interrupt Request Logic
  val timerInterruptActive = mstatus_mie && mie_mtie && mip_mtip
  io.interruptRequest := timerInterruptActive
  io.interruptCause := Mux(timerInterruptActive, "h80000007".U, 0.U)

  // CSR Read Logic (Only for MSTATUS, MIE, MIP)
  val readDataWire = WireDefault(0.U(32.W))
  val MIE_BIT = 3
  val MPIE_BIT = 7
  val MTIE_BIT = 7
  val MTIP_BIT = 7
  switch(io.csrReadAddr) {
    // Construct mstatus read value from internal registers
    is(CSR.MSTATUS.U) {
      // Combine relevant bits. Assume other MSTATUS bits are 0 or hardwired.
      // Adjust Cat arguments if other bits like MPP need representation.
      readDataWire := Cat(
        Fill(31 - MPIE_BIT, 0.U), // Bits 31 down to MPIE_BIT+1
        mstatus_mpie,             // Bit 7 (MPIE)
        Fill(MPIE_BIT - MIE_BIT - 1, 0.U), // Bits 6 down to MIE_BIT+1
        mstatus_mie,              // Bit 3 (MIE)
        Fill(MIE_BIT, 0.U)         // Bits 2 down to 0
      )
    }
    // Construct MIE read value
    is(CSR.MIE.U)     {
      readDataWire := Cat(
        Fill(31 - MTIE_BIT, 0.U), // Higher bits
        mie_mtie,                 // Bit 7 (MTIE)
        Fill(MTIE_BIT, 0.U)       // Lower bits
      )
    }
    // Construct MIP read value
    is(CSR.MIP.U)     {
      readDataWire := Cat(
        Fill(31 - MTIP_BIT, 0.U), // Higher bits
        mip_mtip,                 // Bit 7 (MTIP)
        Fill(MTIP_BIT, 0.U)       // Lower bits
      )
    }
  }
  io.csrReadData := readDataWire

  // CSR Write Logic (Only for MSTATUS, MIE - respecting masks)
  when(io.csrWriteEnable) {
    when(io.csrWriteAddr === CSR.MSTATUS.U) {
      // Allow writing MIE and MPIE based on the write mask defined in CSR.scala
      val MSTATUS_WRITE_MASK = "b0000_0000_0000_0000_0000_0000_1000_1000".U // Allow writing MPIE(7), MIE(3)
      val maskedWriteData = io.csrWriteData & MSTATUS_WRITE_MASK

      // Only update if the corresponding mask bit is 1
      when(MSTATUS_WRITE_MASK(MIE_BIT))   { mstatus_mie := maskedWriteData(MIE_BIT) }
      when(MSTATUS_WRITE_MASK(MPIE_BIT))  { mstatus_mpie := maskedWriteData(MPIE_BIT) }
      // Handle other writable mstatus bits if any based on mask
    }
      .elsewhen(io.csrWriteAddr === CSR.MIE.U) {
        // Allow writing MTIE based on the write mask
        val MIE_WRITE_MASK = "b0000_0000_0000_0000_0000_0000_1000_0000".U // Allow writing MTIE(7)
        val maskedWriteData = io.csrWriteData & MIE_WRITE_MASK

        when(MIE_WRITE_MASK(MTIE_BIT))    { mie_mtie := maskedWriteData(MTIE_BIT) }
      }
    // MIP is read-only for software, ignore writes
  }

  // Trap Handling Updates
  when(io.takeTrap) {
    mstatus_mpie := mstatus_mie // Save current MIE state to MPIE
    mstatus_mie := false.B // Disable global interrupts
    printf("[InterruptController] Trap Taken: MIE(%b) -> MPIE, MIE -> false\n", mstatus_mie) // Use value *before* update for print
  }

  // MRET Logic
  // Action on executing MRET (restore MIE <- MPIE, set MPIE <- 1)
  when(io.mret_executing) {
    mstatus_mie := mstatus_mpie // Restore global interrupt enable from MPIE
    mstatus_mpie := true.B      // Set MPIE to 1 (interrupts were enabled prior to trap)
    printf("[InterruptController] MRET Executing: MIE <- MPIE(%b), MPIE -> true\n", mstatus_mpie) // Use value *before* update for print
  }

  //FOR WFI TO PIPELINE
  io.mstatusInterruptEnable := mstatus_mie


}