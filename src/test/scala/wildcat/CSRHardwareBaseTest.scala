package wildcat

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import wildcat.REGS
import java.io.File
import java.io.FileWriter
import scala.sys.process._

/**
 * Base class for CSR and Exception handling hardware tests
 */
abstract class CSRHardwareBaseTest extends AnyFlatSpec with ChiselScalatestTester {
  // Initialize test directory
  val testDir = new File("CSR_testFiles")
  if (!testDir.exists()) {
    testDir.mkdir()
  }

  // Create link.ld if it doesn't exist
  val linkFile = new File(testDir, "link.ld")
  if (!linkFile.exists()) {
    val linkScript =
      """SECTIONS
        |{
        |  . = 0x0000;      /* Start address for the .text section */
        |  .text : { *(.text) }
        |  .data : { *(.data) }
        |  .bss : { *(.bss) }
        |}
        |""".stripMargin

    // Use Java IO to write the file
    val writer = new FileWriter(linkFile)
    try {
      writer.write(linkScript)
    } finally {
      writer.close()
    }
    println(s"Created link.ld in ${testDir.getAbsolutePath}")
  }

  // Helper function to get the path to a binary file
  def getBinaryPath(filename: String): String = {
    new File(testDir, filename).getAbsolutePath
  }

  // Shared compile function for all tests
  def compileTest(testName: String): String = {
    val sourceFile = new File(testDir, s"$testName.s")
    val objectFile = new File(testDir, s"$testName.o")
    val executableFile = new File(testDir, s"$testName.out")
    val binaryFile = new File(testDir, s"$testName.bin")

    if (!sourceFile.exists()) {
      fail(s"Source file ${sourceFile.getAbsolutePath} not found")
    }

    println(s"Compiling $testName for hardware testing...")

    // Compile the assembly file
    val asResult = s"riscv64-unknown-elf-as -march rv32ia_zicsr ${sourceFile.getAbsolutePath} -o ${objectFile.getAbsolutePath}".!
    if (asResult != 0) {
      fail(s"Failed to assemble ${sourceFile.getAbsolutePath}")
    }

    // Link the object file
    val ldResult = s"riscv64-unknown-elf-ld -m elf32lriscv -T ${linkFile.getAbsolutePath} ${objectFile.getAbsolutePath} -o ${executableFile.getAbsolutePath}".!
    if (ldResult != 0) {
      fail(s"Failed to link ${objectFile.getAbsolutePath}")
    }

    // Generate binary file
    val binResult = s"riscv64-unknown-elf-objcopy -O binary ${executableFile.getAbsolutePath} ${binaryFile.getAbsolutePath}".!
    if (binResult != 0) {
      fail(s"Failed to create binary ${binaryFile.getAbsolutePath}")
    }

    println(s"Successfully compiled ${executableFile.getAbsolutePath} and ${binaryFile.getAbsolutePath}")

    // Return the path to the executable file
    executableFile.getAbsolutePath
  }

  // Utility functions for debug output during tests
  def printCompactDebugInfo(dut: WildcatTestTop): Unit = {
    val pc = dut.io.debug_pc.peekInt()
    val instrValue = dut.io.debug_instr.peekInt()
    val branch = dut.io.debug_doBranch.peekBoolean()
    val target = dut.io.debug_branchTarget.peekInt()
    val csrResult = dut.io.debug_csrResult.peekInt()
    val csrWrite = dut.io.debug_csrWrite.peekBoolean()
    val isIllegal = dut.io.debug_isIllegal.peekBoolean()

    println(f"PC=0x${pc}%08x Instr=0x${instrValue}%08x Branch=${branch} Target=0x${target}%08x, WRITE CSR=${csrWrite}, isIllegal=${isIllegal}")
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

  // Simple decoder for debugging
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

  // Shared helper method for running tests
  def runCSRTest(testName: String, expectedResults: Map[Int, Int], maxCycles: Int = 100): Unit = {
    // Compile the test
    val binFile = compileTest(testName)

    test(new WildcatTestTop(binFile)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Run for enough cycles to complete the test
      println(s"\n===== STARTING $testName EXECUTION =====")
      println(s"Test binary: $binFile")

      // Run for specified number of cycles
      for (i <- 1 to maxCycles) {
        dut.clock.step(1)
        printCompactDebugInfo(dut)
      }

      // Final state
      println("\n----- FINAL STATE -----")
      printDebugInfo(dut)

      // Check register values
      for ((reg, expectedValue) <- expectedResults) {
        val actualValue = dut.io.regFile(reg).peekInt()
        println(f"Checking x$reg: Actual=0x${actualValue}%08x, Expected=0x${expectedValue}%08x")
        assert((actualValue & 0xFFFFFFFFL) == (expectedValue & 0xFFFFFFFFL),
          f"Register x$reg value: 0x${actualValue}%08x, expected: 0x${expectedValue}%08x")
      }
    }
  }
}

/**
 * Test for CSR Instructions in the ThreeCats processor
 */
class CSRHardwareInstructionsTest extends CSRHardwareBaseTest {
  // Define the expected register values
  val csrTestExpected = Map(
    REGS.x3   -> 0x00000001,      // Original mcause (0)
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

  // This is the main test method that will be run directly when testing this class
  "CSR Instructions Test" should "pass on the ThreeCats processor" in {
    runCSRTest("CSR_full_test", csrTestExpected, 50)
  }
}

/**
 * Test for CSR Edge Cases in the ThreeCats processor
 */
class CSRHardwareEdgeCasesTest extends CSRHardwareBaseTest {
  // Define the expected register values
  val csrEdgeCaseTestExpected = Map(
    REGS.x2   -> 0x12345678, // x2 (CSRRS with rs1=x0)
    REGS.x3   -> 0x12345678, // x3 (CSRRC with rs1=x0)
    REGS.x4   -> 0x12345678, // x4 (verify mstatus unchanged)
    REGS.x5   -> 0x12345678, // x5 (CSRRSI with zimm=0)
    REGS.x6   -> 0x12345678, // x6 (CSRRCI with zimm=0)
    REGS.x8   -> 0xABCDEF01, // x8 (verify mcause updated by CSRRW)
    REGS.x9   -> 0xABCDEFFF, // x9 (verify mcause updated by CSRRS)
    REGS.x10  -> 0x0000002F, // x10 (marchid value)
    REGS.x11  -> 0x0000002F, // x11 (verify marchid unchanged)
    REGS.x13  -> 0x40000101, // x13 (verify MISA Start value)
    REGS.x14  -> 0xFFFFFFFF  // x14 (MISA NOT WRITE PROTECTED HERE)
  )

  "CSR Edge Cases Test" should "pass on the ThreeCats processor" in {
    runCSRTest("CSR_edgecases_test", csrEdgeCaseTestExpected)
  }
}

/**
 * Test for Exception Handling in the ThreeCats processor
 */
class CSRHardwareExceptionHandlingTest extends CSRHardwareBaseTest {
  // Define the expected register values
  val exceptionTestExpected = Map(
    REGS.x10 -> 1,          // Success code
    REGS.x12 -> 0xFEFEFEFE, // Illegal instruction from mtval
    REGS.x21 -> 2,          // Last illegal instruction exception causes = 2
    REGS.x22 -> 42,         // Success code for handling ecall
    REGS.x23 -> 0xFEFEFEFE, // Illegal instruction from mtval
    REGS.x24 -> 0x55,       // Success code for handling illegal instr
  )

  "Exception Handling Test" should "pass on the ThreeCats processor" in {
    runCSRTest("Exception_test", exceptionTestExpected)
  }
}

/**
 * Main test class that combines all CSR tests
 * This class can be run directly to execute all tests
 */
class CSRHardwareAllTests extends CSRHardwareBaseTest {
  // This class reuses test definitions from the individual test classes
  // and calls the same shared runCSRTest method

  // Import the needed test classes
  val instructionsTest = new CSRHardwareInstructionsTest()
  val edgeCasesTest = new CSRHardwareEdgeCasesTest()
  val exceptionTest = new CSRHardwareExceptionHandlingTest()

  "CSR Hardware Basic Instructions" should "pass all tests" in {
    runCSRTest("CSR_full_test", instructionsTest.csrTestExpected, 50)
  }

  "CSR Hardware Edge Cases" should "pass all tests" in {
    runCSRTest("CSR_edgecases_test", edgeCasesTest.csrEdgeCaseTestExpected)
  }

  "CSR Hardware Exception Handling" should "pass all tests" in {
    runCSRTest("Exception_test", exceptionTest.exceptionTestExpected)
  }
}