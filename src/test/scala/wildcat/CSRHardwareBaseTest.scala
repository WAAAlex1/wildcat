package wildcat

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import wildcat.REGS

/**
 * Base class for CSR and Exception handling hardware tests
 */
abstract class CSRHardwareBaseTest extends AnyFlatSpec with ChiselScalatestTester {
  // Get the path to the binary file
  def getBinaryPath(filename: String): String = {
    new java.io.File("bin", filename).getAbsolutePath
  }

  def printDebugInfo(dut: WildcatTestTop): Unit = {
    // Print PC and instruction if available
    println(f"PC: 0x${dut.io.debug_pc.peekInt()}%08x, Instruction: 0x${dut.io.debug_instr.peekInt()}%08x")
    println(f"Branch: ${dut.io.debug_doBranch.peekBoolean()}, Target: 0x${dut.io.debug_branchTarget.peekInt()}%08x, Stall: ${dut.io.debug_stall.peekBoolean()}")
    val instrValue = dut.io.debug_instr.peekInt()
    println(f"PC: 0x${dut.io.debug_pc.peekInt()}%08x, Instruction: 0x${instrValue}%08x (${decodeInstructionForDebug(instrValue.toLong)})")
    // Print registers in a formatted table, 8 per row
    println("Registers:")
    for (i <- 0 until 32 by 8) {
      print(f"x${i}%-2d: 0x${dut.io.regFile(i).peekInt()}%08x")
      print(f" | x${i + 1}%-2d: 0x${dut.io.regFile(i + 1).peekInt()}%08x")
      print(f" | x${i + 2}%-2d: 0x${dut.io.regFile(i + 2).peekInt()}%08x")
      print(f" | x${i + 3}%-2d: 0x${dut.io.regFile(i + 3).peekInt()}%08x")
      print(f" | x${i + 4}%-2d: 0x${dut.io.regFile(i + 4).peekInt()}%08x")
      print(f" | x${i + 5}%-2d: 0x${dut.io.regFile(i + 5).peekInt()}%08x")
      print(f" | x${i + 6}%-2d: 0x${dut.io.regFile(i + 6).peekInt()}%08x")
      print(f" | x${i + 7}%-2d: 0x${dut.io.regFile(i + 7).peekInt()}%08x")
      println()
    }
    println()
  }

  // Add this to your CSRHardwareBaseTest class
  def dumpBinary(filePath: String): Unit = {
    println("\n===== TEST BINARY CONTENTS =====")
    println(s"File: $filePath")

    try {
      val (code, start) = Util.getCode(filePath)
      println(s"Start address: 0x${start.toHexString}")
      println(s"Code length: ${code.length} words")

      if (code.length == 0) {
        println("WARNING: Empty binary file!")
      } else {
        // Print first several instructions for verification
        println("First 20 instructions:")
        for (i <- 0 until Math.min(20, code.length)) {
          println(f"$i%3d: 0x${code(i)}%08x")
        }

        // Print instructions from the main test area (if applicable)
        if (code.length > 50) {
          println("\nInstructions around position 50:")
          for (i <- 45 until Math.min(55, code.length)) {
            println(f"$i%3d: 0x${code(i)}%08x")
          }
        }

        // Print last few instructions
        if (code.length > 10) {
          println("\nLast 10 instructions:")
          for (i <- Math.max(0, code.length - 10) until code.length) {
            println(f"$i%3d: 0x${code(i)}%08x")
          }
        }
      }
    } catch {
      case e: Exception =>
        println(s"ERROR reading binary file: ${e.getMessage}")
        e.printStackTrace()
    }
    println("\n")
  }

  // SIMPLE, NOT ALL INSTRUCTIONS INCLUDED
  def decodeInstructionForDebug(instr: Long): String = {
    val opcode = instr & 0x7f
    val rd = (instr >> 7) & 0x1f
    val rs1 = (instr >> 15) & 0x1f
    val rs2 = (instr >> 20) & 0x1f
    val funct3 = (instr >> 12) & 0x7
    val funct7 = (instr >> 25) & 0x7f

    opcode match {
      case 0x13 => s"addi x$rd, x$rs1, ${(instr >> 20).toInt}" // I-type immediate
      case 0x33 => s"ALU op x$rd, x$rs1, x$rs2" // R-type
      case 0x37 => s"lui x$rd, 0x${(instr >> 12).toHexString}" // U-type
      case 0x17 => s"auipc x$rd, 0x${(instr >> 12).toHexString}" // U-type
      case 0x73 => {
        funct3 match {
          case 0 => "ecall/mret"
          case 1 => s"csrrw x$rd, 0x${((instr >> 20) & 0xfff).toHexString}, x$rs1"
          case 2 => s"csrrs x$rd, 0x${((instr >> 20) & 0xfff).toHexString}, x$rs1"
          case 3 => s"csrrc x$rd, 0x${((instr >> 20) & 0xfff).toHexString}, x$rs1"
          case _ => s"CSR op 0x${funct3.toHexString}"
        }
      }
      case _ => s"Unknown op 0x${opcode.toHexString}"
    }
  }

  def printCompactDebugInfo(dut: WildcatTestTop): Unit = {
    val pc = dut.io.debug_pc.peekInt()
    val instrValue = dut.io.debug_instr.peekInt()
    val branch = dut.io.debug_doBranch.peekBoolean()
    val target = dut.io.debug_branchTarget.peekInt()
    val csrResult = dut.io.debug_csrResult.peekInt()
    val csrWrite = dut.io.debug_csrWrite.peekBoolean()
    val isIllegal = dut.io.debug_isIllegal.peekBoolean()

    println(f"PC=0x${pc}%08x Instr=0x${instrValue}%08x Branch=${branch} Target=0x${target}%08x, WRITE CSR=${csrWrite}, isIllegal=${isIllegal}" )
//    if(branch){
//      println(f"BRANCHING TO: 0x${target}%08x")
//    }
//    if (branch) {
//      println(f"BRANCH TAKEN FROM 0x${pc}%08x TO 0x${target}%08x")
//    }
  }

}

/**
 * Test for CSR Instructions in the ThreeCats processor
 */
class CSRHardwareInstructionsTest extends CSRHardwareBaseTest {
  // Define the expected register values - same as in simulator tests
  val csrTestExpected = Map(
    REGS.x3   -> 0x00000000,      // Original mcause (0)
    REGS.x4   -> 0x00001880,      // After CSRRW
    REGS.x5   -> 0x00001888,      // After CSRRS
    REGS.x6   -> 0x00000888,      // After CSRRC
    REGS.x7   -> 0x0000001C,      // After CSRRWI
    REGS.x8   -> 0x0000001F,      // After CSRRSI
    REGS.x9   -> 0x00000013,      // After CSRRCI
    REGS.x10  -> 0xABCDEF00,      // MEPC value
    REGS.x11  -> 0x00000000,      // VENDOR_ID = 0
    REGS.x12  -> 0x0000002F       // MARCHID = 47 (0x2F)
  )

  "CSR Instructions Test" should "pass on the ThreeCats processor" in {
    // Get binary file path
    val binFile = getBinaryPath("CSR_full_test.bin")

    // Dump binary file contents before testing
    // dumpBinary(binFile)

    test(new WildcatTestTop(binFile)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Run for enough cycles to complete the test
      println("\n===== STARTING TEST EXECUTION =====")
      println(s"Test binary: $binFile")

      for (i <- 1 to 50) {
        dut.clock.step(1)
        printCompactDebugInfo(dut)
      }

      // Final state
      println("\n----- FINAL STATE -----")
      printDebugInfo(dut)

      // Check register values
      for ((reg, expectedValue) <- csrTestExpected) {
        val actualValue = dut.io.regFile(reg).peekInt()
        println(f"Checking x$reg: Actual=0x${actualValue}%08x, Expected=0x${expectedValue}%08x")
        assert((actualValue & 0xFFFFFFFFL) == (expectedValue & 0xFFFFFFFFL),
          f"Register x$reg value: 0x${actualValue}%08x, expected: 0x${expectedValue}%08x")
      }
    }
  }
}

/**
 * Test for CSR Edge Cases in the ThreeCats processor
 */
class CSRHardwareEdgeCasesTest extends CSRHardwareBaseTest {
  // Define the expected register values - same as in simulator tests
  val csrEdgeCaseTestExpected = Map(
    REGS.x2   -> 0x12345678, // x2 (CSRRS with rs1=x0)
    REGS.x3   -> 0x12345678, // x3 (CSRRC with rs1=x0)
    REGS.x4   -> 0x12345678, // x4 (CSRRSI with zimm=0)
    REGS.x5   -> 0x12345678, // x5 (CSRRCI with zimm=0)
    REGS.x6   -> 0x12345678, // x6 (verify mcause unchanged)
    REGS.x8   -> 0xABCDEF01, // x8 (verify mcause updated by CSRRW)
    REGS.x9   -> 0xABCDEFFF, // x9 (verify mcause updated by CSRRS)
    REGS.x10  -> 0x0000002F, // x10 (marchid value)
    REGS.x11  -> 0x0000002F, // x11 (verify marchid unchanged)
    REGS.x13  -> 0x40000101, // x13 (verify MISA Start value)
    REGS.x14  -> 0x40000101  // x14 (verify MISA MASK)
  )

  "CSR Instructions Edgecases Test" should "pass on the ThreeCats processor" in {
    // Get binary file path
    val binFile = getBinaryPath("CSR_edgecases_test.bin")

    // Dump binary file contents before testing
    // dumpBinary(binFile)

    test(new WildcatTestTop(binFile)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Run for enough cycles to complete the test
      println("\n===== STARTING TEST EXECUTION =====")
      println(s"Test binary: $binFile")

      for (i <- 1 to 100) {
        dut.clock.step(1)
        printCompactDebugInfo(dut)
      }

      // Final state
      println("\n----- FINAL STATE -----")
      printDebugInfo(dut)

      // Check register values
      for ((reg, expectedValue) <- csrEdgeCaseTestExpected) {
        val actualValue = dut.io.regFile(reg).peekInt()
        println(f"Checking x$reg: Actual=0x${actualValue}%08x, Expected=0x${expectedValue}%08x")
        assert((actualValue & 0xFFFFFFFFL) == (expectedValue & 0xFFFFFFFFL),
          f"Register x$reg value: 0x${actualValue}%08x, expected: 0x${expectedValue}%08x")
      }
    }
  }
}

/**
 * Test for Exception Handling in the ThreeCats processor
 */
class CSRHardwareExceptionHandlingTest extends CSRHardwareBaseTest {
  // Define the expected register values - same as in simulator tests
  val exceptionTestExpected = Map(
    REGS.x10 -> 1,          // Success code
    REGS.x12 -> 0xFEFEFEFE, // Illegal instruction from mtval
    REGS.x21 -> 2,          // Last illegal instruction exception causes = 2
    REGS.x22 -> 42,         // Success code for handling ecall
    REGS.x23 -> 0xFEFEFEFE, // Illegal instruction from mtval
    REGS.x24 -> 0x55,       // Success code for handling illegal instr
  )

  "CSR Hardware Exception Test" should "pass on the ThreeCats processor" in {
    // Get binary file path
    val binFile = getBinaryPath("Exception_test.bin")

    // Dump binary file contents before testing
    // dumpBinary(binFile)

    test(new WildcatTestTop(binFile)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Run for enough cycles to complete the test
      println("\n===== STARTING TEST EXECUTION =====")
      println(s"Test binary: $binFile")

      for (i <- 1 to 100) {
        dut.clock.step(1)
        printCompactDebugInfo(dut)
      }

      // Final state
      println("\n----- FINAL STATE -----")
      printDebugInfo(dut)

      // Check register values
      for ((reg, expectedValue) <- exceptionTestExpected) {
        val actualValue = dut.io.regFile(reg).peekInt()
        println(f"Checking x$reg: Actual=0x${actualValue}%08x, Expected=0x${expectedValue}%08x")
        assert((actualValue & 0xFFFFFFFFL) == (expectedValue & 0xFFFFFFFFL),
          f"Register x$reg value: 0x${actualValue}%08x, expected: 0x${expectedValue}%08x")
      }
    }
  }
}