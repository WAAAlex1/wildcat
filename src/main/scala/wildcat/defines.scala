package wildcat

object Opcode {
  val AluImm = 0x13
  val Alu = 0x33
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
}

object CSR {
  val CYCLE = 0xc00
  val CYCLEH = 0xc80
  val TIME = 0xc01
  val TIMEH = 0xc81
  val MCYCLE = 0xb00
  val MCYCLEH = 0xb80
  // Disassembler does not know them
  val MTIME = 0xb01
  val MTIMEH = 0xb81

  val INSTRET = 0xc02
  val INSTRETH = 0xc82

  val HARTID = 0xf10
  val MARCHID = 0xf12
  val WILDCAT_MARCHID = 47 // see https://github.com/riscv/riscv-isa-manual/blob/main/marchid.md

  val MINSTRET = 0xb02
  val MINSTRETH = 0xb82

  //Extra registers with special settings or explicitly called registers

  val MSTATUS = 0x300    // Machine status register
  val MSTATUSH = 0x310   // The 32 MSB of MSTATUS

  val MISA = 0x301       // Machine ISA and extensions register
  val WILDCAT_MISA = 0x40000081 // Only A, I extensions. MXL = 1, MXLEN = 32.

  val MEPC = 0x341       // Machine exception Program counter
  val MTVEC = 0x305      // Machine trap-handler base address
  val MCAUSE = 0x342     // Machine trap cause (encoded)
  val MTVAL = 0x343      // Machine bad address or instruction

  val MVENDORID = 0xF11  // VENDOR ID - (Should be 0)
  val WILDCAT_VENDORID = 0x0

  val MEDELEG = 0x302     // Should not exist when S mode not supported
  val MIDELEG = 0x303     // Should not exist when S mode not supported

  val MIP = 0x344         // Interrupt pending Register
  val MIE = 0x304         // Interrupt enable Register

  val MCONFIGPTR = 0xF15  // Pointer to configuration data structure (not used)

  val MENVCFG = 0x30A     // Environment Configuration Register
  val MENVCFGH = 0x31A
}