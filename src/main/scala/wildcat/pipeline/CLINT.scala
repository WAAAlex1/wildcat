// In src/main/scala/wildcat/pipeline/CLINT.scala
package wildcat.pipeline

import chisel3._
import chisel3.util._
import wildcat.CSR.MemoryMap // Import the memory map definitions

/**
 * Interface bundle for connecting CLINT directly to WildcatTop
 */
class CLINTLink extends Bundle {
  // From WildcatTop to CLINT
  val enable  = Input(Bool())      // Indicates a valid access to CLINT address range
  val isWrite = Input(Bool())      // Indicates write operation
  val address = Input(UInt(32.W))  // Full address from WildcatTop
  val wrData  = Input(UInt(32.W))  // Data to be written (32-bit chunks)

  // From CLINT
  val rdData  = Output(UInt(32.W)) // Data read from CLINT registers
}

/**
 * Core Local Interruptor (CLINT) module (simplified).
 * Provides memory-mapped access to mtime and mtimecmp for Hart 0
 * via a direct interface to wildcatTop (where it is to be instantiated).
 * Assumes RV32 access width.
 */
class CLINT extends Module {
  val io = IO(new Bundle {
    // Interface to wildcatTop
    val link = new CLINTLink()

    // Interface to TimerCounter
    val currentTimeIn   = Input(UInt(64.W))     // Current mtime value from TimerCounter
    val mtimecmpValueOut= Output(UInt(64.W))    // mtimecmp value to TimerCounter for comparison
  })

  // --- Registers ---
  // MTIMECMP for Hart 0 (64-bit)
  val mtimecmpReg = RegInit(0.U(64.W))
  // MTIME is read directly from TimerCounter via io.currentTimeIn

  // --- Internal Wires ---
  val rdDataWire = WireDefault(0.U(32.W))   // Default read data is 0
  val address = io.link.address             // Address provided by wildcatTop

  // --- Registers for safe 64-bit write ---
  val tempMtimecmpHigh = Reg(UInt(32.W)) // Temporarily store the high word
  val highWordWritten = RegInit(false.B) // Flag: True if high word was written, waiting for low

  // Decode specific register access based on address
  val isMtimecmpAccess = (address === MemoryMap.MTIMECMP_HART0_ADDR_L.U) || (address === MemoryMap.MTIMECMP_HART0_ADDR_H.U)
  val isMtimeAccess    = (address === MemoryMap.MTIME_ADDR_L.U) || (address === MemoryMap.MTIME_ADDR_H.U)
  val isLowWordAccess  = (address === MemoryMap.MTIMECMP_HART0_ADDR_L.U) || (address === MemoryMap.MTIME_ADDR_L.U)
  val isHighWordAccess = (address === MemoryMap.MTIMECMP_HART0_ADDR_H.U) || (address === MemoryMap.MTIME_ADDR_H.U)

  // --- Write Logic (Modified for safety) ---
  // Expect standard high-to-low writesequence for writing to 64 bit reg.
  when(io.link.enable && io.link.isWrite) {
    when(isMtimecmpAccess) {
      val writeData = io.link.wrData
      when(isHighWordAccess) {
        // High word write: Store it temporarily and set the flag
        tempMtimecmpHigh := writeData
        highWordWritten := true.B
        printf(p"[CLINT] Write mtimecmp_H (staged): Addr=0x${Hexadecimal(address)}, Data=0x${Hexadecimal(writeData)}\n")
      }.elsewhen(isLowWordAccess) {
        // Low word write:
        // If high word was written previously, commit the full 64-bit value
        when(highWordWritten) {
          mtimecmpReg := Cat(tempMtimecmpHigh, writeData)
          highWordWritten := false.B // Clear the flag, sequence complete
          printf(p"[CLINT] Write mtimecmp_L (commit): Addr=0x${Hexadecimal(address)}, Data=0x${Hexadecimal(writeData)}, Full=0x${Hexadecimal(Cat(tempMtimecmpHigh, writeData))}\n")
        }.otherwise {
          // Low word written *without* prior high word write (unconventional sequence)
          // Update only the low part. This maintains the previous high word.
          // Alternatively, could ignore this write if strict high-then-low sequence is assumed.
          mtimecmpReg := Cat(mtimecmpReg(63, 32), writeData)
          printf(p"[CLINT] Write mtimecmp_L (low only): Addr=0x${Hexadecimal(address)}, Data=0x${Hexadecimal(writeData)}\n")
        }
      }
    }.elsewhen(isMtimeAccess) {
      // Attempt to write to mtime (read-only)
      //printf(p"[CLINT] Write ERROR: Addr=0x${Hexadecimal(address)} (mtime) is read-only\n")
    }.otherwise {
      // Attempt to write to invalid CLINT address
      //printf(p"[CLINT] Write ERROR: Addr=0x${Hexadecimal(address)} is invalid within CLINT range\n")
    }
  }.otherwise {
    // Could clear the highword flag here. Current solution is just to keep it high, waiting for a low-word write.
  }

  // --- Read Logic ---
  // Read is combinational based on current inputs
  when(io.link.enable && !io.link.isWrite) {
    when(isMtimecmpAccess) {
      rdDataWire := Mux(isLowWordAccess, mtimecmpReg(31, 0), mtimecmpReg(63, 32))
      //printf(p"[CLINT] Read mtimecmp: Addr=0x${Hexadecimal(address)}, Data=0x${Hexadecimal(rdDataWire)}\n")
    }.elsewhen(isMtimeAccess) {
      rdDataWire := Mux(isLowWordAccess, io.currentTimeIn(31, 0), io.currentTimeIn(63, 32))
      //printf(p"[CLINT] Read mtime: Addr=0x${Hexadecimal(address)}, Data=0x${Hexadecimal(rdDataWire)}\n")
    }.otherwise {
      // Attempt to read invalid CLINT address
      //printf(p"[CLINT] Read ERROR: Addr=0x${Hexadecimal(address)} is invalid within CLINT range\n")
      rdDataWire := 0.U // Or some error indication if bus supports it
    }
  }

  // Drive outputs
  io.link.rdData := rdDataWire
  io.mtimecmpValueOut := mtimecmpReg // Connect output to TimerCounter

}
