/*
 * Copyright (c) 2015-2017, DTU
 * Simplified BSD License
 */

/*
 * A simple ISA simulator of RISC-V.
 * 
 * Author: Martin Schoeberl (martin@jopdesign.com)
 */

package wildcat.isasim

import net.fornwall.jelf.ElfFile
import wildcat.Opcode._
import wildcat.AluFunct3._
import wildcat.AluFunct7._
import wildcat.BranchFunct3._
import wildcat.LoadStoreFunct3._
import wildcat.CSRFunct3._
import wildcat.InstrType._
import wildcat.{CSR, Util}

class SimRV(mem: Array[Int], start: Int, stop: Int) {

  // That's the state of the processor.
  // That's it, nothing else (except memory ;-)
  var pc = start // RISC-V tests start at 0x200
  var reg = new Array[Int](32)
  reg(0) = 0

  val csrFile = new CSRFile()

  // Reservation state for LR/SC
  var reservationValid = false
  var reservationAddr = 0

  // stop on a test end
  var run = true;

  // some statistics
  var instrCnt = 0

  def execute(instr: Int): Boolean = {

    // Do some decoding: extraction of decoded fields
    val opcode = instr & 0x7f
    val rd = (instr >> 7) & 0x01f
    val rs1 = (instr >> 15) & 0x01f
    val rs2 = (instr >> 20) & 0x01f
    val funct3 = (instr >> 12) & 0x07
    val funct7 = (instr >> 25) & 0x07f  // Extended to 7 bits for AMO
    val aq = (instr >> 26) & 0x01       // Acquire bit
    val rl = (instr >> 25) & 0x01       // Release bit

    /**
     * Immediate generation is a little bit elaborated,
     * but shall give smaller multiplexers in the hardware.
     */
    def genImm() = {

      val instrType: InstrType = opcode match {
        case AluImm => I
        case Alu => R
        case Branch => SBT
        case Load => I
        case Store => S
        case Lui => U
        case AuiPc => U
        case Jal => UJ
        case JalR => I
        case System => I
        case _ => R
      }
      // subfields of the instruction 
      val instr7 = (instr >> 7) & 0x01
      val instr11_8 = (instr >> 8) & 0x0f
      val instr19_12 = (instr >> 12) & 0xff
      val instr20 = (instr >> 20) & 0x01
      val instr24_21 = (instr >> 21) & 0x0f
      val instr31_20 = (instr >> 20) & 0xfff
      val instr30_25 = (instr >> 25) & 0x3f
      val instr31 = (instr >> 31) & 0x01
      val sext8 = if (instr31 == 1) 0xff else 0
      val sext12 = if (instr31 == 1) 0xfff else 0

      // subfields of the immediate, depending on instruction type
      val imm0 = instrType match {
        case I => instr20
        case S => instr7
        case _ => 0
      }
      val imm4_1 = instrType match {
        case I => instr24_21
        case U => 0
        case UJ => instr24_21
        case _ => instr11_8
      }
      val imm10_5 = if (instrType == U) 0 else instr30_25
      val imm11 = instrType match {
        case SBT => instr7
        case U => 0
        case UJ => instr20
        case _ => instr31
      }
      val imm19_12 = if (instrType == U || instrType == UJ) instr19_12 else sext8
      val imm31_20 = if (instrType == U) instr31_20 else sext12

      // now glue together
      (imm31_20 << 20) | (imm19_12 << 12) | (imm11 << 11) |
        (imm10_5 << 5) | (imm4_1 << 1) | imm0
    }

    val imm = genImm()

    // single bit on extended function - this is not nice
    val sraSub = funct7 == SRA_SUB && (opcode == Alu || (opcode == AluImm && funct3 == F3_SRL_SRA))

    def alu(funct3: Int, sraSub: Boolean, op1: Int, op2: Int): Int = {
      val shamt = op2 & 0x1f

      funct3 match {
        case F3_ADD_SUB => if (sraSub) op1 - op2 else op1 + op2
        case F3_SLL => op1 << shamt
        case F3_SLT => if (op1 < op2) 1 else 0
        case F3_SLTU => if ((op1 < op2) ^ (op1 < 0) ^ (op2 < 0)) 1 else 0
        case F3_XOR => op1 ^ op2
        case F3_SRL_SRA => if (sraSub) op1 >> shamt else op1 >>> shamt
        case F3_OR => op1 | op2
        case F3_AND => op1 & op2
      }
    }

    def compare(funct3: Int, op1: Int, op2: Int): Boolean = {
      funct3 match {
        case BEQ => op1 == op2
        case BNE => !(op1 == op2)
        case BLT => op1 < op2
        case BGE => op1 >= op2
        case BLTU => (op1 < op2) ^ (op1 < 0) ^ (op2 < 0)
        case BGEU => op1 == op2 || ((op1 > op2) ^ (op1 < 0) ^ (op2 < 0))
      }
    }

    def load(funct3: Int, base: Int, displ: Int): Int = {
      val addr = ((base + displ) & 0xfffff) // 1 MB wrap around
      val data = mem(addr >>> 2)
      funct3 match {
        case LB => (((data >> (8 * (addr & 0x03))) & 0xff) << 24) >> 24
        case LH => (((data >> (8 * (addr & 0x03))) & 0xffff) << 16) >> 16
        case LW => data
        case LBU => (data >> (8 * (addr & 0x03))) & 0xff
        case LHU => (data >> (8 * (addr & 0x03))) & 0xffff
      }
    }

    def store(funct3: Int, base: Int, displ: Int, value: Int): Unit = {
      val addr = base + displ
      val wordAddr = addr >>> 2
      
      // Any store should invalidate reservations to the same address
      if (reservationValid && (addr >>> 2) == (reservationAddr >>> 2)) {
        reservationValid = false
      }
      
      funct3 match {
        case SB => {
          val mask = (addr & 0x03) match {
            case 0 => 0xffffff00
            case 1 => 0xffff00ff
            case 2 => 0xff00ffff
            case 3 => 0x00ffffff
          }
          mem(wordAddr) = (mem(wordAddr) & mask) | ((value & 0xff) << (8 * (addr & 0x03)))
        }
        case SH => {
          val mask = (addr & 0x03) match {
            case 0 => 0xffff0000
            case 2 => 0x0000ffff
          }
          mem(wordAddr) = (mem(wordAddr) & mask) | ((value & 0xffff) << (8 * (addr & 0x03)))
        }
        case SW => {
          // very primitive IO simulation
          if (addr == 0xf0000004) {
            println("out: " + value.toChar)
          } else {
            mem(wordAddr) = value
          }
        }
      }
    }

    def handleSYS(funct3: Int, csrAddr: Int, rs1Val: Int, pcNext: Int, rd: Int, rs1: Int): (Int, Boolean, Int) = {
      funct3 match {

        case ESYS =>
          if (csrAddr == 0) { // ECALL
            println("ecall")
            run = false
            (0, false, pcNext)
          // EBREAK SUPPORT (uncomment for using)
          //} else if (csrAddr == 1) { // EBREAK
          //  println("ebreak")
          //  run = false
          //  (0, false, pcNext)
          } else {
            throw new Exception(s"Unknown immediate for ECALL/EBREAK: $csrAddr")
          }

        case CSRRW | CSRRS | CSRRC =>
          var result = 0 // Standard value
          if (funct3 == CSRRW) {
            result = csrFile.exchange(csrAddr, rs1Val, rd)
          } else if (funct3 == CSRRS) {
            result = csrFile.setBits(csrAddr, rs1Val, rs1)
          } else if (funct3 == CSRRC) {
            result = csrFile.clearBits(csrAddr, rs1Val, rs1)
          }
          (result, true, pcNext)

        case CSRRWI | CSRRSI | CSRRCI =>
          val zimm = rs1 // For immediate variants, rs1 field contains zimm
          var result = 0
          if (funct3 == CSRRWI) {
            result = csrFile.exchange(csrAddr, zimm, rd) // pass rd to check for nonzero imm
          } else if (funct3 == CSRRSI) {
            result = csrFile.setBits(csrAddr, zimm, zimm) // Use zimm as rd for checking non-zero
          } else if (funct3 == CSRRCI) {
            result = csrFile.clearBits(csrAddr, zimm, zimm) // Use zimm as rd for checking non-zero
          }
          (result, true, pcNext)
        case _ =>
          throw new Exception(s"Unknown System funct3: $funct3")
      }
    }

    def atomic(funct5: Int, addr: Int, rs2Val: Int): (Int, Boolean) = {
      if ((addr & 0x3) != 0) {
        throw new Exception(f"Misaligned atomic address: 0x${addr}%08x")
      }
      val wordAddr = addr >>> 2
      val oldValue = mem(wordAddr)
      
      funct5 match {
        case 0x02 => { // LR.W
          reservationValid = true
          reservationAddr = addr
          (oldValue, true)
        }
        case 0x03 => { // SC.W
          if (reservationValid && reservationAddr == addr) {
            mem(wordAddr) = rs2Val
            reservationValid = false
            (0, true) // Success: return 0
          } else {
            (1, true) // Failure: return non-zero
          }
        }
        case 0x01 => { // AMOSWAP.W
          mem(wordAddr) = rs2Val
          (oldValue, true)
        }
        case 0x00 => { // AMOADD.W
          val result = oldValue + rs2Val
          mem(wordAddr) = result
          (oldValue, true)
        }
        case 0x04 => { // AMOXOR.W
          val result = oldValue ^ rs2Val
          mem(wordAddr) = result
          (oldValue, true)
        }
        case 0x0C => { // AMOAND.W
          val result = oldValue & rs2Val
          mem(wordAddr) = result
          (oldValue, true)
        }
        case 0x08 => { // AMOOR.W
          val result = oldValue | rs2Val
          mem(wordAddr) = result
          (oldValue, true)
        }
        case _ => (0, false)
      }
    }

    // read register file
    val rs1Val = reg(rs1)
    val rs2Val = reg(rs2)
    // next pc
    val pcNext = pc + 4

    // Debug output for atomic instructions
    if (opcode == 0x2f) {
      println(f"Atomic instruction at pc=0x${pc}%08x: rs1=x${rs1}%d(0x${rs1Val}%08x) rs2=x${rs2}%d(0x${rs2Val}%08x) rd=x${rd}%d funct7=0x${funct7}%02x")
    }

    // Execute the instruction and return a tuple for the result:
    //   (ALU result, writeBack, next PC)
    val result = opcode match {
      case 0x2f => { // AMO - Atomic Memory Operations
        val addr = rs1Val
        if (funct3 != 0x2) {
          throw new Exception(f"Invalid funct3 for atomic operation: 0x${funct3}%x")
        }
        val funct5 = (funct7 >> 2) & 0x1f  // Get bits [31:27] for funct5
        val (value, success) = atomic(funct5, addr, rs2Val)
        (value, success, pcNext)
      }
      case AluImm => (alu(funct3, sraSub, rs1Val, imm), true, pcNext)
      case Alu => (alu(funct3, sraSub, rs1Val, rs2Val), true, pcNext)
      case Branch => (0, false, if (compare(funct3, rs1Val, rs2Val)) pc + imm else pcNext)
      case Load => (load(funct3, rs1Val, imm), true, pcNext)
      case Store => store(funct3, rs1Val, imm, rs2Val); (0, false, pcNext)
      case Lui => (imm, true, pcNext)
      case AuiPc => (pc + imm, true, pcNext)
      case Jal => (pc + 4, true, pc + imm)
      case JalR => (pc + 4, true, (rs1Val + imm) & 0xfffffffe)
      case Fence => (0, false, pcNext)
      case System => handleSYS(funct3, imm & 0xFFF, rs1Val, pcNext, rd, rs1)
      case _ => throw new Exception("Opcode " + opcode + " at " + pc + " not (yet) implemented")
    }

    // External interference simulation (uncomment for testing)
    // if (scala.util.Random.nextInt(100) < 5) { // 5% chance
    //   reservationValid = false
    // }

    if (rd != 0 && result._2) {
      reg(rd) = result._1
    }

    val oldPc = pc
    pc = result._3

    instrCnt += 1

    pc != oldPc && run && pc < stop // detect endless loop or go beyond code to stop simulation
  }

  var cont = true
  while (cont) {
    cont = execute(mem(pc >> 2))
    // print("regs: ")
    // reg.foreach(printf("%08x ", _))
    // println()
  }

}

object SimRV {

  def runSimRV(file: String) = {
    val mem = new Array[Int](1024 * 256) // 1 MB, also check masking in load and store

    val (code, start) = Util.getCode(file)

    for (i <- 0 until code.length) {
      mem(i) = code(i)
    }

    val stop = start + code.length * 4

    // TODO: do we really want ot ba able to start at an arbitrary address?
    // Read in RV spec
    val sim = new SimRV(mem, start, stop)
    sim
  }

  def main(args: Array[String]): Unit = {
    runSimRV(args(0))
  }
}


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

