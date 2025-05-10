package wildcat

import scala.math.BigInt

// Define a CSR Register File class
class CSRFile {
  // Use a Map to store CSR values with their addresses as keys
  private val csrMap = collection.mutable.Map[Int, Int]()

  // Initialize commonly used CSRs with default values
  csrMap(CSR.MARCHID) = CSR.WILDCAT_MARCHID           // = 47
  csrMap(CSR.HARTID) = 0                              // "At least one hart must have a hart ID of zero."
  csrMap(CSR.MISA) = CSR.WILDCAT_MISA


  // Counter for instruction retirement
  private var instRetCounter: BigInt = BigInt(0)

  //Updates counters assuming one instruction has passed in the threecats pipeline
  def updateCounters(): Unit = {
    //1 cycle per instruction kinda
    instRetCounter += 1
  }

  // Read a CSR register
  def read(csr: Int): Int = {
    // Handle special cases for counters that need real-time values.
    csr match {
      case CSR.CYCLE => instRetCounter.toInt
      case CSR.CYCLEH => (instRetCounter >> 32).toInt
      case CSR.INSTRET => instRetCounter.toInt
      case CSR.INSTRETH => (instRetCounter >> 32).toInt
      case CSR.MCYCLE => instRetCounter.toInt
      case CSR.MCYCLEH => (instRetCounter >> 32).toInt
      case CSR.MINSTRET => instRetCounter.toInt
      case CSR.MINSTRETH => (instRetCounter >> 32).toInt
      case _ => csrMap.getOrElse(csr, 0) // Return 0 for uninitialized CSRs
    }
  }

  // Write to a CSR register
  // Some CSRs might be read-only or have special write behavior
  def write(csr: Int, value: Int): Unit = {
    //Do not write to read-only csr
    if(CSR.isReadOnly(csr)){
      return
    }

    // Handle special cases for counters
    csr match {
      case CSR.MCYCLE =>
        instRetCounter = (instRetCounter & 0xFFFFFFFF00000000L) | (value & 0xFFFFFFFFL)
      case CSR.MCYCLEH =>
        instRetCounter = (instRetCounter & 0x00000000FFFFFFFFL) | (value.toLong << 32)
      case CSR.MINSTRET =>
        instRetCounter = (instRetCounter & 0xFFFFFFFF00000000L) | (value & 0xFFFFFFFFL)
      case CSR.MINSTRETH =>
        instRetCounter = (instRetCounter & 0x00000000FFFFFFFFL) | (value.toLong << 32)
      case _ =>
    }

    // Get writemask
    val writeMask = CSR.getWriteMask(csr)
    val oldValue = csrMap.getOrElse(csr, 0)
    csrMap(csr) = (oldValue & ~writeMask) | (value & writeMask)
  }

  // Set bits in a CSR (CSRRS instruction)
  def setBits(csr: Int, mask: Int, rs1: Int): Int = {
    val oldValue = read(csr)

    // Only modify the CSR if rs1 is not x0
    if (rs1 != 0) {
      write(csr, oldValue | mask)
    }
    // Always return the original value
    oldValue
  }

  // Clear bits in a CSR (CSRRC instruction)
  def clearBits(csr: Int, mask: Int, rs1: Int): Int = {
    val oldValue = read(csr)

    // Only modify the CSR if rs1 is not x0
    if (rs1 != 0) {
      write(csr, oldValue & ~mask)
    }
    // Always return the original value
    oldValue
  }

  // Exchange value with CSR (CSRRW instruction)
  def exchange(csr: Int, value: Int, rd: Int = -1): Int = {
    // If rd is x0, skip reading the CSR (avoid side effects of read)
    val oldValue = if (rd == 0) 0 else read(csr)

    // Always perform the write - this is independent of rd
    write(csr, value)

    // Return the old value (or 0 if rd was x0)
    oldValue
  }

  // --- Add method to update pending interrupts (callable from SimRV) ---
  def setInterruptPendingBit(bit: Int, pending: Boolean): Unit = {
    val currentMip = csrMap.getOrElse(CSR.MIP, 0)
    val mask = 1 << bit
    val newMip = if (pending) currentMip | mask else currentMip & ~mask
    csrMap(CSR.MIP) = newMip
  }
}
