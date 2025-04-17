package wildcat.pipeline

import chisel3._
import chisel3.util._
import wildcat.CSR._

/**
 * Control and Status Registers File
 *
 * Implements CSR registers as a memory to support the full range of CSRs.
 */
class Csr() extends Module {
  val io = IO(new Bundle {
    // INPUTS
    val address       = Input(UInt(12.W))
    val writeEnable   = Input(Bool())
    val writeData     = Input(UInt(32.W))
    val readEnable    = Input(Bool())
    val instrComplete = Input(Bool())
    // OUTPUTS
    val data        = Output(UInt(32.W))
    val mretTarget  = Output(UInt(32.W))   // For MRET instruction

    // Exception handling signals
    val exception = Input(Bool())
    val exceptionCause = Input(UInt(32.W))
    val exceptionPC = Input(UInt(32.W))
    val trapVector = Output(UInt(32.W))
  })

  // Create a CSR file supporting the entire range of registers (4096)
  val csrMem = SyncReadMem(4096, UInt(32.W))

  // For debugging and initialization
  val debugCsrs = RegInit(VecInit(Seq.fill(4096)(0.U(32.W))))

  // Initialize commonly used registers with default values
  debugCsrs(MARCHID.U) := WILDCAT_MARCHID.U
  debugCsrs(MVENDORID.U) := WILDCAT_VENDORID.U
  debugCsrs(MISA.U) := WILDCAT_MISA.U

  // Special registers for counters
  val cycle = RegInit(0.U(32.W))
  val cycleh = RegInit(0.U(32.W))
  val instret = RegInit(0.U(32.W))
  val instreth = RegInit(0.U(32.W))

  // Update cycle counter every cycle
  cycle := cycle + 1.U
  when(cycle === 0.U) {
    cycleh := cycleh + 1.U
  }
  // Update Intruction complete counter
  when(io.instrComplete) {
    instret := instret + 1.U
    when(instret === 0.U) {
      instreth := instreth + 1.U
    }
  }

  // Read operation
  val readData =Wire(UInt(32.W))
  readData := 0.U
  // Read operation - with special handling for certain registers
  when(io.readEnable){
    readData := csrMem.read(io.address)
    switch(io.address) { //Special cases
      is(CYCLE.U)     {readData := cycle}
      is(CYCLEH.U)    {readData := cycleh}
      is(TIME.U)      {readData := cycle}
      is(TIMEH.U)     {readData := cycleh}
      is(MCYCLE.U)    {readData := cycle}
      is(MCYCLEH.U)   {readData := cycleh}
      is(INSTRET.U)   {readData := instret}
      is(INSTRETH.U)  {readData := instreth}
      is(MINSTRET.U)  {readData := instret}
      is(MINSTRETH.U) {readData := instreth}
      is(MARCHID.U)   {readData := WILDCAT_MARCHID.U}
      is(MVENDORID.U) {readData := WILDCAT_VENDORID.U}
      is(MISA.U)      {readData := WILDCAT_MISA.U}
    }
  }
  io.data := readData

  // Write operation
  when(io.writeEnable) {
    // Convert address to Int for using with our helper methods
    val addr = io.address.litValue.toInt

    // Only perform write if not read-only (using our helper method)
    when(!isReadOnly(addr).B) {
      // Special handling for counter registers
      val isCounter = isCounterRegister(addr).B
      when(isCounter) {
        switch(io.address) {
          is(CYCLE.U) { cycle := io.writeData }
          is(CYCLEH.U) { cycleh := io.writeData }
          is(TIME.U) { cycle := io.writeData }
          is(TIMEH.U) { cycleh := io.writeData }
          is(MCYCLE.U) { cycle := io.writeData }
          is(MCYCLEH.U) { cycleh := io.writeData }
          is(INSTRET.U) { instret := io.writeData }
          is(INSTRETH.U) { instreth := io.writeData }
          is(MINSTRET.U) { instret := io.writeData }
          is(MINSTRETH.U) { instreth := io.writeData }
        }
      }.otherwise {
        // Regular CSR registers with write masks
        val writeMask = getWriteMask(addr).U
        val oldValue = csrMem.read(io.address)
        val newValue = (oldValue & (~writeMask).asUInt) | (io.writeData & writeMask)
        csrMem.write(io.address, newValue)
        debugCsrs(io.address) := newValue
      }
    }
  }

  // Provide MEPC content for MRET instruction
  io.mretTarget := csrMem.read(MEPC.U)

  // Handle exceptions
  when(io.exception) {
    // Save PC to MEPC
    csrMem.write(MEPC.U, io.exceptionPC)
    debugCsrs(MEPC.U) := io.exceptionPC

    // Save cause to MCAUSE
    csrMem.write(MCAUSE.U, io.exceptionCause)
    debugCsrs(MCAUSE.U) := io.exceptionCause

    // Update MSTATUS: save current interrupt enable bit
    // we are not supporting interrupts, this will always save 0 to this field, but it is protocol
    val currentStatus = csrMem.read(MSTATUS.U)
    val mie = (currentStatus >> 3)(0)
    val newStatus = (currentStatus & (~0x1888.U).asUInt) | // Clear MIE, MPIE, MPP
                    (mie << 7).asUInt | // Set MPIE to old MIE
                    (3 << 11).asUInt // Set MPP to 11 (M-mode)
    csrMem.write(MSTATUS.U, newStatus)
    debugCsrs(MSTATUS.U) := newStatus
  }

  // Trap vector address
  io.trapVector := csrMem.read(MTVEC.U)

}
