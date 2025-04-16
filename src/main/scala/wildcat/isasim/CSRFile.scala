package wildcat

// Define a CSR Register File class
class CSRFile {
  // Use a Map to store CSR values with their addresses as keys
  private val csrMap = collection.mutable.Map[Int, Int]()

  // Define write masks for CSRs with read-only fields. Writeable bits should be set.
  private val csrWriteMasks = Map[Int, Int](

    //Registers which are completely read-only:
    CSR.MARCHID   -> 0x0,
    CSR.HARTID    -> 0x0,
    CSR.MVENDORID -> 0x0,
    CSR.MEDELEG   -> 0x0,
    CSR.MIDELEG   -> 0x0,
    CSR.MIE       -> 0x0,         // Interrupt enabled -> We do not support interrupts
    CSR.MIP       -> 0x0,         // Interrupt pending -> We do not support interrupts.
    CSR.MCONFIGPTR-> 0x0,         // Read only - not used - set to 0.
    CSR.MENVCFG   -> 0x0,         // NO U-Mode -> Register not needed, set to 0
    CSR.MENVCFGH  -> 0x0,         // NO U-Mode -> Register not needed, set to 0

    //Registers with read-only fields (not set):
    CSR.MSTATUS   -> 0x000018aa,  // MPRV, MXR, SUM, SBE, UBE, TVM, TW, TSR, FS, VS, XS, SD, all WPRI = 0 (read only)
    CSR.MSTATUSH  -> 0x00000000,  // No fields used.
    CSR.MISA      -> 0x03888888,  // 0-25 writeable, 26-29 constant 0 (read only), 30-31 read-only (should be 01)
    CSR.MTVEC     -> 0xFFFFFFFC,  // 0-1 read only 0 (Always want direct MODE)
    CSR.MEPC      -> 0xFFFFFFFC,  // 0-1 always zero (no unaligned address access).

  )

  // Initialize commonly used CSRs with default values
  csrMap(CSR.MARCHID) = CSR.WILDCAT_MARCHID           // = 47
  csrMap(CSR.HARTID) = 0                              // "At least one hart must have a hart ID of zero."

  // Counter for instruction retirement
  private var instRetCounter: Long = 0

  // Update instruction retirement counter
  def incrementInstRet(): Unit = {
    instRetCounter += 1
  }

  // Read a CSR register
  def read(csr: Int): Int = {
    // Handle special cases for counters that need real-time values. All of these cases are the same
    // as we are only using a single counter. Real implementation might be different (We do not support timers/counters).
    csr match {
      case CSR.CYCLE | CSR.TIME => instRetCounter.toInt
      case CSR.CYCLEH | CSR.TIMEH => (instRetCounter >> 32).toInt
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
  def write(csr: Int, value: Int): Unit = {
    // Some CSRs might be read-only or have special write behavior

    val isReadOnly = {
      val csr11_8 = (csr >> 8) & 0xF  // Bits [11:8]

      // Standard read-only ranges from the table:
      // 0xC00-0xC7F, 0xC80-0xCBF, 0xCC0-0xCFF (Unprivileged, Standard read-only)
      // 0xD00-0xD7F, 0xD80-0xDBF, 0xDC0-0xDFF (Supervisor, Standard read-only)

      // This corresponds to bit pattern 11 in positions [11:10]
      csr11_8 == 0xC | csr11_8 == 0xD
    }



    csr match {
      // Handle special cases for counters
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

    // First check if it's in a completely read-only range
    if (isReadOnly) {
      // CSR is in a read-only range, ignore write
      return
    }

    // Next check if it's in the map of specific CSRs with read-only fields
    if (csrWriteMasks.contains(csr)) {
      val writeMask = csrWriteMasks(csr)
      val oldValue = csrMap.getOrElse(csr, 0)
      // If the mask is 0, it's completely read-only
      if (writeMask == 0) {
        return
      }
      // Otherwise apply the mask for partially read-only CSRs
      csrMap(csr) = (oldValue & ~writeMask) | (value & writeMask)
      return
    }

    // For all other CSRs (fully writable)
    csrMap(csr) = value
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
}
