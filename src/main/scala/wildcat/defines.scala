package wildcat

object Opcode {
  val AluImm = 0x13
  val Alu = 0x33
  val Atomic = 0x2f
  val Branch = 0x63
  val Load = 0x03
  val Store = 0x23
  val Lui = 0x37
  val AuiPc = 0x17
  val Jal = 0x6f
  val JalR = 0x67
  val Fence = 0x0f
  val System = 0x73
}

object InstrType extends Enumeration {
  type InstrType = Value
  val R, I, S, SBT, U, UJ = Value
}

object AluType extends Enumeration {
  type AluType = Value
  val ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND = Value
}

object AluFunct7 {
  val DEFAULT = 0x00
  val SRA_SUB = 0x20
}

object AluFunct3 {
  val F3_ADD_SUB = 0x00 // no SUB in I-type
  val F3_SLL = 0x01
  val F3_SLT = 0x02
  val F3_SLTU = 0x03
  val F3_XOR = 0x04
  val F3_SRL_SRA = 0x05
  val F3_OR = 0x06
  val F3_AND = 0x07
}

object BranchFunct3 {
  val BEQ = 0x00
  val BNE = 0x01
  val BLT = 0x04
  val BGE = 0x05
  val BLTU = 0x06
  val BGEU = 0x07
}

object LoadStoreFunct3 {
  val LB = 0x00
  val LH = 0x01
  val LW = 0x02
  val LBU = 0x04
  val LHU = 0x05
  val SB = 0x00
  val SH = 0x01
  val SW = 0x02
}

object CSRFunct3 {
  val ESYS = 0x00
  val CSRRW = 0x01
  val CSRRS = 0x02
  val CSRRC = 0x03
  val CSRRWI = 0x05
  val CSRRSI = 0x06
  val CSRRCI = 0x07

  //FOR DEBUGGING:
  def name(funct3: Int): String = funct3 match {
    case ESYS => "ESYS"
    case CSRRW => "CSRRW"
    case CSRRS => "CSRRS"
    case CSRRC => "CSRRC"
    case CSRRWI => "CSRRWI"
    case CSRRSI => "CSRRSI"
    case CSRRCI => "CSRRCI"
    case _ => f"Unknown(0x${funct3.toHexString})"
  }

}

object CSR {
  val CYCLE           = 0xc00
  val CYCLEH          = 0xc80
  val TIME            = 0xc01
  val TIMEH           = 0xc81
  val MCYCLE          = 0xb00
  val MCYCLEH         = 0xb80

  val INSTRET         = 0xc02
  val INSTRETH        = 0xc82

  val HARTID          = 0xf10
  val MARCHID         = 0xf12
  val WILDCAT_MARCHID = 47       // see https://github.com/riscv/riscv-isa-manual/blob/main/marchid.md

  val MINSTRET        = 0xb02
  val MINSTRETH       = 0xb82

  //Extra registers with special settings or explicitly called registers

  val MSTATUS         = 0x300     // Machine status register
  val MSTATUSH        = 0x310     // The 32 MSB of MSTATUS

  val MISA            = 0x301     // Machine ISA and extensions register
  val WILDCAT_MISA    = 0x40000101// Only A, I extensions. MXL = 1, MXLEN = 32.

  val MEPC            = 0x341     // Machine exception Program counter
  val MTVEC           = 0x305     // Machine trap-handler base address
  val MCAUSE          = 0x342     // Machine trap cause (encoded)
  val MTVAL           = 0x343     // Machine bad address or instruction

  val MVENDORID       = 0xF11     // VENDOR ID - (Should be 0)
  val WILDCAT_VENDORID= 0x0

  val MEDELEG         = 0x302     // Should not exist when S mode not supported
  val MIDELEG         = 0x303     // Should not exist when S mode not supported

  val MIP             = 0x344     // Interrupt pending Register
  val MIE             = 0x304     // Interrupt enable Register

  val MCONFIGPTR      = 0xF15     // Pointer to configuration data structure (not used)

  val MENVCFG         = 0x30A     // Environment Configuration Register
  val MENVCFGH        = 0x31A


  //CLINT Definitions:
  val CLINT_BASE = 0xF2000000 // Example base address, ensure it's unused
  val CLINT_SIZE = 0x10000 // Standard size (64KB)

  // Offsets within CLINT (Standard for SiFive CLINT)
  val CLINT_MSIP_OFFSET = 0x0000 // Optional: Machine Software Interrupt Pending (Hart 0)
  val CLINT_MTIMECMP_OFFSET = 0x4000 // Machine Timer Compare (Hart 0)
  val CLINT_MTIME_OFFSET = 0xBFF8 // Machine Time (Shared)


  // Add write mask definitions extracted from the simulator
  // Defines which bits are writable for each CSR (1 = writable, 0 = read-only)
  val MSTATUS_MASK    = 0x000018aa // MPRV, MXR, SUM, SBE, UBE, TVM, TW, TSR, FS, VS, XS, SD, all WPRI = 0 (read only)
  val MSTATUSH_MASK   = 0x00000000 // No fields used.
  val MISA_MASK       = 0x00000101 // Only allow A (bit 0) and I (bit 8) to be writable
  val MTVEC_MASK      = 0xFFFFFFFC // 0-1 read only 0 (Always want direct MODE)
  val MEPC_MASK       = 0xFFFFFFFC // 0-1 always zero (no unaligned address access).
  val MARCHID_MASK    = 0x00000000
  val HARTID_MASK     = 0x00000000
  val MVENDORID_MASK  = 0x00000000
  val MEDELEG_MASK    = 0x00000000
  val MIDELEG_MASK    = 0x00000000
  val MIE_MASK        = 0x00000888 // Allow writing MTIE(7), MEIE(11), MSIE(3)
  val MIP_MASK        = 0x00000000
  val MCONFIGPTR_MASK = 0x00000000
  val MENVCFG_MASK    = 0x00000000
  val MENVCFGH_MASK   = 0x00000000
  val TIME_MASK       = 0x00000000
  val TIMEH_MASK      = 0x00000000

  /**
   * Get the write mask for a CSR address.
   * Returns a mask where 1 bits are writable, 0 bits are read-only.
   * Returns 0x00000000 (fully protected) for standard read-only CSR ranges.
   */
  def getWriteMask(csrAddr: Int): Int = {
    // Check if CSR is in standard read-only range based on bits [11:8]
    val csr11_8 = (csrAddr >> 8) & 0xF

    // Check if register is in read-only ranges
    // 0xC00-0xCFF (Unprivileged, read-only)
    // 0xD00-0xDFF (Supervisor, read-only)
    if (csr11_8 == 0xC || csr11_8 == 0xD) {
      return 0x00000000 // Fully read-only
    }

    // Check for specific CSRs with custom write masks
    csrAddr match {
      case MSTATUS => MSTATUS_MASK
      case MSTATUSH => MSTATUSH_MASK
      case MISA => MISA_MASK
      case MTVEC => MTVEC_MASK
      case MEPC => MEPC_MASK
      case MARCHID => MARCHID_MASK
      case HARTID => HARTID_MASK
      case MVENDORID => MVENDORID_MASK
      case MEDELEG => MEDELEG_MASK
      case MIDELEG => MIDELEG_MASK
      case MIE => MIE_MASK
      case MIP => MIP_MASK
      case MCONFIGPTR => MCONFIGPTR_MASK
      case MENVCFG => MENVCFG_MASK
      case MENVCFGH => MENVCFGH_MASK
      case TIME => TIME_MASK
      case TIMEH => TIMEH_MASK
      case _ => 0xFFFFFFFF // Default, fully writable
    }
  }

  /**
   * Check if a CSR register is completely read-only.
   * Returns true if the register cannot be written to at all.
   */
  def isReadOnly(csrAddr: Int): Boolean = {
    getWriteMask(csrAddr) == 0
  }

  /**
   * Check if a CSR register is a counter register that needs special handling.
   * Returns true for CYCLE, CYCLEH, MCYCLE, MCYCLEH, INSTRET, INSTRETH, etc.
   */
  def isCounterRegister(csrAddr: Int): Boolean = {
    csrAddr match {
      case CYCLE | CYCLEH | TIME | TIMEH | MCYCLE | MCYCLEH |
           INSTRET | INSTRETH | MINSTRET | MINSTRETH => true
      case _ => false
    }
  }

}

object REGS {
  // Standard ABI names
  val zero = 0   // Hard-wired zero
  val ra   = 1   // Return address
  val sp   = 2   // Stack pointer
  val gp   = 3   // Global pointer
  val tp   = 4   // Thread pointer
  val t0   = 5   // Temporaries
  val t1   = 6
  val t2   = 7
  val s0   = 8   // Saved register / frame pointer
  val fp   = 8   // Alias for s0
  val s1   = 9
  val a0   = 10  // Function arguments / return values
  val a1   = 11
  val a2   = 12
  val a3   = 13
  val a4   = 14
  val a5   = 15
  val a6   = 16
  val a7   = 17
  val s2   = 18  // Saved registers
  val s3   = 19
  val s4   = 20
  val s5   = 21
  val s6   = 22
  val s7   = 23
  val s8   = 24
  val s9   = 25
  val s10  = 26
  val s11  = 27
  val t3   = 28  // Temporaries
  val t4   = 29
  val t5   = 30
  val t6   = 31

  // Standard x0–x31 register names
  val x0  = 0
  val x1  = 1
  val x2  = 2
  val x3  = 3
  val x4  = 4
  val x5  = 5
  val x6  = 6
  val x7  = 7
  val x8  = 8
  val x9  = 9
  val x10 = 10
  val x11 = 11
  val x12 = 12
  val x13 = 13
  val x14 = 14
  val x15 = 15
  val x16 = 16
  val x17 = 17
  val x18 = 18
  val x19 = 19
  val x20 = 20
  val x21 = 21
  val x22 = 22
  val x23 = 23
  val x24 = 24
  val x25 = 25
  val x26 = 26
  val x27 = 27
  val x28 = 28
  val x29 = 29
  val x30 = 30
  val x31 = 31
}
