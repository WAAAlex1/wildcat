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

//import net.fornwall.jelf.ElfFile
import wildcat.Opcode._
import wildcat.AluFunct3._
import wildcat.AluFunct7._
import wildcat.BranchFunct3._
import wildcat.LoadStoreFunct3._
import wildcat.CSRFunct3._
import wildcat.InstrType._
import wildcat.{CSR, CSRFile, CSRFunct3, Util}

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
    //println("EXECUTING INSTRUCTION: " + f"${instr}%08x" )
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
            //println("out: " + value.toChar)
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
            val ex = handleException(11, instr)
            //println("ecall")
            (0, false, ex._2)
          } else if (csrAddr == 0x302 && rs1 == 0x0 && rd == 0x0) { // MRET
            //println("mret")
            val mepc = csrFile.read(CSR.MEPC)

            // Update mstatus: set MIE to MPIE, set MPIE to 1, set MPP to U (00)
            val mstatus = csrFile.read(CSR.MSTATUS)
            // Extract MPIE (bit 7)
            val mpie = (mstatus >> 7) & 1
            // Set MIE (bit 3) to MPIE
            val newMstatus = (mstatus & ~(1 << 3)) | (mpie << 3)
            // Set MPIE to 1
            val newMstatus2 = newMstatus | (1 << 7)
            // Set MPP to U (00) - bits 12:11
            val newMstatus3 = newMstatus2 & ~(3 << 11)
            csrFile.write(CSR.MSTATUS, newMstatus3)

            // Return to address stored in mepc
            (0, false, mepc)
          } else {
            throw new Exception(s"Unknown immediate for ECALL/EBREAK: $csrAddr")
          }

        case CSRRW | CSRRS | CSRRC =>
          //println("HANDLING NORMAL CSR: " + CSRFunct3.name(funct3))
          var result = 0 // Standard value
          if (funct3 == CSRRW) {
            result = csrFile.exchange(csrAddr, rs1Val, rd)
            //println(f"RESULT: 0x$result%08X")
          } else if (funct3 == CSRRS) {
            result = csrFile.setBits(csrAddr, rs1Val, rs1)
            //println(f"RESULT: 0x$result%08X")
          } else if (funct3 == CSRRC) {
            result = csrFile.clearBits(csrAddr, rs1Val, rs1)
            //println(f"RESULT: 0x$result%08X")
          }
          (result, true, pcNext)

        case CSRRWI | CSRRSI | CSRRCI =>
          //println("HANDLING IMM CSR: " + CSRFunct3.name(funct3))
          val zimm = rs1 // For immediate variants, rs1 field contains zimm
          var result = 0
          if (funct3 == CSRRWI) {
            result = csrFile.exchange(csrAddr, zimm, rd) // pass rd to check for nonzero imm
            //println(f"RESULT: 0x$result%08X")
          } else if (funct3 == CSRRSI) {
            result = csrFile.setBits(csrAddr, zimm, zimm) // Use zimm as rd for checking non-zero
            //println(f"RESULT: 0x$result%08X")
          } else if (funct3 == CSRRCI) {
            result = csrFile.clearBits(csrAddr, zimm, zimm) // Use zimm as rd for checking non-zero
            //println(f"RESULT: 0x$result%08X")
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
      //println(f"Atomic instruction at pc=0x${pc}%08x: rs1=x${rs1}%d(0x${rs1Val}%08x) rs2=x${rs2}%d(0x${rs2Val}%08x) rd=x${rd}%d funct7=0x${funct7}%02x")
    }

    // Check for illegal instruction
    val illegalInstr = opcode match {
      case AluImm | Alu | Branch | Load | Store | Lui | AuiPc | Jal | JalR | Fence | System => false
      case _ => true
    }
    if (illegalInstr) {
      var ex = handleException(2, instr)
      pc = ex._2
      return ex._1// Illegal instruction
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

    (pc != oldPc && run && pc < stop) && !(pc == 0 && opcode == System) // detect endless loop or go beyond code to stop simulation
    // Added that code will stop running if new pc is 0 (we jump back to start)
    // Solves Ecall issue - added ecall support will not make the code stop
    //                      Instead will set pc = MTVEC = 0 (missing exception handler for tests)
    //                      Code will hence loop/run infinitely
  }

  //Handling exceptions
  def handleException(cause: Int, instr: Int): (Boolean, Int) = {
    // Save current PC to MEPC
    csrFile.write(CSR.MEPC, pc)

    // Helper variable for new PC
    var newPC = pc

    // Save cause to MCAUSE
    csrFile.write(CSR.MCAUSE, cause)
    //println("Handling Exception #: " + csrFile.read(CSR.MCAUSE))

    // Save instr to MTVAL
    csrFile.write(CSR.MTVAL, instr)

    // Update MSTATUS: save current interrupt enable bit
    val currentStatus = csrFile.read(CSR.MSTATUS)
    val mie = (currentStatus >> 3) & 0x1
    val newStatus = (currentStatus & ~0x1888) |
      (mie << 7) // MPIE = MIE
    csrFile.write(CSR.MSTATUS, newStatus)

    // Jump to trap handler
    newPC = csrFile.read(CSR.MTVEC)
    //println("Jumping to: " + f"${newPC}%08x")

    if(newPC == 0){
     return (false, newPC) // end execution
    }
    (true, newPC) // Continue execution
  }

  var cont = true
  while (cont) {
    cont = execute(mem(pc >>> 2))
    // print("regs: ")
    // reg.foreach(printf("%08x ", _))
    // println()
  }

}

object SimRV {

  def runSimRV(file: String) = {
    val mem = new Array[Int](1024 * 256) // 1 MB, also check masking in load and store

    val (code, start) = Util.getCode(file)

    for (i <- code.indices) {
      mem(i) = code(i)
    }

    val stop = start + code.length * 4

    // TODO: do we really want ot ba able to start at an arbitrary address?
    // Read in RV spec
    val sim = new SimRV(mem, start, stop)
    sim
  }

  def runSimRVforImage(file: String) = {
    val mem = new Array[Int](1024 * 4096) // 16 MB to fit the image, also check masking in load and store

    val (image, start) = Util.getCode(file)

    for (i <- 0 until image.length) { //Load kernel in at 4MB
      mem(i) = image(i)
    }

    val stop = start + image.length * 4

    // TODO: do we really want ot ba able to start at an arbitrary address?
    // Read in RV spec
    val sim = new SimRV(mem, start, stop)
    sim
  }

  def main(args: Array[String]): Unit = {
    runSimRVforImage(args(0))
  }
}



