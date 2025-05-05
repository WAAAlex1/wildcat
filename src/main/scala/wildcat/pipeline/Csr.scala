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
    val timerCounter = Output(UInt(64.W)) // TimerCounter to CLINT (through toplevel)

    // Interrupt Request to Pipeline
    val interruptRequest = Output(Bool())   // An interrupt is pending and enabled
    val interruptCause   = Output(UInt(32.W)) // The specific interrupt cause
  })

  //----------------------------------------------------------------------------
  // Module Instantiations
  //----------------------------------------------------------------------------

  // Timer/Counter Module (Handles TIME, CYCLE, INSTRET CSRs)
  val timerCounter = Module(new TimerCounter(freqHz))
  timerCounter.io.instrComplete   := io.instrComplete
  timerCounter.io.csrAddr         := io.readAddress // Pass raw read address
  timerCounter.io.csrWriteEnable  := io.writeEnable && isCounterCSR(io.writeAddress) // Qualify write enable
  timerCounter.io.csrWriteData    := io.writeData
  timerCounter.io.mtimecmpValue   := io.mtimecmpVal
  io.timerCounter                 := timerCounter.io.currentTime

  // Interrupt Controller Module (Handles MSTATUS.MIE, MIE, MIP)
  val interruptController = Module(new InterruptController())
  interruptController.io.timerInterruptPendingIn := timerCounter.io.timerInterruptPending
  interruptController.io.csrReadAddr    := io.readAddress // Pass raw read address
  interruptController.io.csrWriteAddr   := io.writeAddress// Pass raw write address
  interruptController.io.csrWriteEnable := io.writeEnable && isInterruptCSR(io.writeAddress) // Qualify write enable
  interruptController.io.csrWriteData   := io.writeData
  interruptController.io.takeTrap       := io.takeTrap
  interruptController.io.trapIsInterrupt:= io.trapIsInterrupt
  interruptController.io.mret_executing := io.mret_executing

  // Get interrupt request signals from InterruptController
  io.interruptRequest := interruptController.io.interruptRequest
  io.interruptCause   := interruptController.io.interruptCause

  //----------------------------------------------------------------------------
  // Register Definitions
  //----------------------------------------------------------------------------
  // Generic CSR Memory
  val csrMem = SyncReadMem(4096, UInt(32.W))

  // Special Registers for Exception/Trap Handling & State
  val mepcReg   = RegInit(0.U(32.W))
  val mcauseReg = RegInit(0.U(32.W))
  val mtvalReg  = RegInit(0.U(32.W))
  val mtvecReg  = RegInit(0.U(32.W))

  //----------------------------------------------------------------------------
  // Forwarding Registers
  //----------------------------------------------------------------------------
  val lastWriteAddr = RegNext(io.writeAddress)
  // Qualify forwarding enable: Write must be enabled, target must not be RO,
  // and target must not be handled by InterruptController or TimerCounter directly.
  val canForwardWrite = io.writeEnable && !isReadOnly(io.writeAddress) && !isInterruptCSR(io.writeAddress) && !isCounterCSR(io.writeAddress)
  val lastWriteEnable = RegNext(io.writeEnable && !isReadOnly(io.writeAddress) && !isInterruptCSR(io.writeAddress) && !isCounterCSR(io.writeAddress), false.B)
  val lastWriteData = RegNext(io.writeData)

  // Registers for forwarding exception updates
  // Store *which* CSR was updated by the trap mechanism last cycle
  val lastTrapWriteAddr = RegNext(Mux(io.takeTrap,
    Mux(io.trapIsInterrupt, 0.U,
      Mux(io.writeAddress === CSR.MEPC.U, CSR.MEPC.U,
        Mux(io.writeAddress === CSR.MCAUSE.U, CSR.MCAUSE.U,
          Mux(io.writeAddress === CSR.MTVAL.U, CSR.MTVAL.U, 0.U)))
    ), 0.U)) // Address being written during trap (MEPC, MCAUSE, MTVAL)
  val lastTrapOccurred = RegNext(io.takeTrap, false.B)
  val lastTrapPC = RegNext(io.trapPC) // Store MEPC value written by trap
  val lastTrapCause = RegNext(Mux(io.trapIsInterrupt, io.interruptCause, io.exceptionCause)) // Store MCAUSE value written by trap
  val lastTrapValue = RegNext(Mux(io.trapIsInterrupt, 0.U, io.trapInstruction)) // Store MTVAL value written by trap

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
  // CSR Read Operation (Before Forwarding)
  //----------------------------------------------------------------------------
  val readDataInternal = Wire(UInt(32.W)) // Value read before forwarding

  // Prioritize reads from specialized modules/registers
  when(isInterruptCSR(io.readAddress)) {
    readDataInternal := interruptController.io.csrReadData // Read MSTATUS, MIE, MIP
  }.elsewhen(isCounterCSR(io.readAddress)) {
      readDataInternal := timerCounter.io.csrReadData      // Read TIME, CYCLE, INSTRET, etc.
    }
    // Read specific registers handled directly here
    .elsewhen(io.readAddress === CSR.MEPC.U)      { readDataInternal := mepcReg }
    .elsewhen(io.readAddress === CSR.MCAUSE.U)    { readDataInternal := mcauseReg }
    .elsewhen(io.readAddress === CSR.MTVAL.U)     { readDataInternal := mtvalReg }
    .elsewhen(io.readAddress === CSR.MTVEC.U)     { readDataInternal := mtvecReg }
    // Standard read-only ID registers
    .elsewhen(io.readAddress === CSR.MARCHID.U)   { readDataInternal := CSR.WILDCAT_MARCHID.U }
    .elsewhen(io.readAddress === CSR.MVENDORID.U) { readDataInternal := CSR.WILDCAT_VENDORID.U }
    .elsewhen(io.readAddress === CSR.MISA.U)      { readDataInternal := CSR.WILDCAT_MISA.U }
    .elsewhen(io.readAddress === CSR.HARTID.U)    { readDataInternal := 0.U } // Assuming Hart ID 0
    // Default to reading from generic CSR memory
    .otherwise {
      readDataInternal := csrMem.read(io.readAddress, io.readEnable)
      // printf("[Csr] Read from generic CSR 0x%x\n", io.readAddress)
    }

  //----------------------------------------------------------------------------
  // Forwarding Logic
  //----------------------------------------------------------------------------
  io.data := MuxCase(readDataInternal, Seq(
    // Case 1: Immediate same-cycle read-after-write
    (io.readEnable && io.writeEnable && (io.readAddress === io.writeAddress) && !isReadOnly(io.writeAddress)) -> io.writeData,

    // Case 2: Forward data potentially updated by a trap mechanism in the *current* cycle
    (io.readEnable && io.takeTrap) ->
      MuxLookup(io.readAddress, readDataInternal, Seq(
        CSR.MEPC.U   -> io.trapPC,
        CSR.MCAUSE.U -> Mux(io.trapIsInterrupt, io.interruptCause, io.exceptionCause),
        CSR.MTVAL.U  -> Mux(io.trapIsInterrupt, 0.U, io.trapInstruction)
      )),

    // Case 3: Forward data written by a regular CSR instruction in the *previous* cycle
    (io.readEnable && lastWriteEnable && (io.readAddress === lastWriteAddr)) -> lastWriteData,

    // Case 4: Forward data written by the trap mechanism in the *previous* cycle
    (io.readEnable && lastTrapOccurred && (io.readAddress === lastTrapWriteAddr)) ->
      MuxLookup(io.readAddress, readDataInternal, Seq(
        CSR.MEPC.U   -> lastTrapPC,
        CSR.MCAUSE.U -> lastTrapCause,
        CSR.MTVAL.U  -> lastTrapValue
      ))
  ))
  //----------------------------------------------------------------------------
  // CSR Write Operation
  //----------------------------------------------------------------------------
  when(io.writeEnable) {
    // Delegate writes to specialized modules first
    when(isInterruptCSR(io.writeAddress)) {
      // Write handled by InterruptController instance
    }.elsewhen(isCounterCSR(io.writeAddress)) {
        // Write handled by TimerCounter instance
      }
      // Handle writes to specific registers directly
      .elsewhen(io.writeAddress === CSR.MEPC.U)    { mepcReg  := io.writeData & (~3.U(32.W)).asUInt }
      .elsewhen(io.writeAddress === CSR.MCAUSE.U)  { mcauseReg:= io.writeData }
      .elsewhen(io.writeAddress === CSR.MTVAL.U)   { mtvalReg := io.writeData }
      .elsewhen(io.writeAddress === CSR.MTVEC.U)   { mtvecReg := io.writeData & (~1.U(32.W)).asUInt }
      // Default to writing generic CSR memory if not read-only
      .otherwise {
        when(!isReadOnly(io.writeAddress)){
          csrMem.write(io.writeAddress, io.writeData)
          // printf("[Csr] Write to generic CSR 0x%x \n", io.writeAddress)
        }
      }
  }

  //----------------------------------------------------------------------------
  // Other Outputs
  //----------------------------------------------------------------------------
  io.mretTarget := mepcReg // MRET jumps to mepc
  io.trapVector := mtvecReg // Exceptions and Interrupts jump to mtvec

  //----------------------------------------------------------------------------
  // Helper Functions
  //----------------------------------------------------------------------------
  def isReadOnly(addr: UInt): Bool = {
    val upperBits = addr(11, 8)
    // Standard User/Supervisor RO ranges
    val isStandardReadOnlyRange = (upperBits === "b1100".U) || (upperBits === "b1101".U)

    // Specific RO CSRs (add MIMPID if defined/used)
    val specificReadOnly = (addr === CSR.MARCHID.U) || (addr === CSR.MVENDORID.U) ||
      (addr === CSR.HARTID.U) || (addr === CSR.MIP.U) // MIP is RO by SW

    isStandardReadOnlyRange || specificReadOnly
  }

  def isCounterCSR(addr: UInt): Bool = {
    (addr === CSR.CYCLE.U) || (addr === CSR.CYCLEH.U) ||
      (addr === CSR.TIME.U) || (addr === CSR.TIMEH.U) || // Read-only access via CSR
      (addr === CSR.INSTRET.U) || (addr === CSR.INSTRETH.U) ||
      (addr === CSR.MCYCLE.U) || (addr === CSR.MCYCLEH.U) ||
      (addr === CSR.MINSTRET.U) || (addr === CSR.MINSTRETH.U)
  }

  def isInterruptCSR(addr: UInt): Bool = {
    (addr === CSR.MSTATUS.U) || (addr === CSR.MIE.U) || (addr === CSR.MIP.U)
  }

}