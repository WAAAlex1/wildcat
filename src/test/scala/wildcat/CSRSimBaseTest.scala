package wildcat

import org.scalatest.flatspec.AnyFlatSpec
import wildcat.isasim.SimRV
import java.io.File
import java.io.FileWriter
import wildcat.REGS
import scala.sys.process._

/**
 * Base class for CSR and Exception handling simulator tests
 */
abstract class CSRSimBaseTest extends AnyFlatSpec {
  // Create the bin directory if it doesn't exist
  val binDir = new File("CSR_testFiles")
  if (!binDir.exists()) {
    binDir.mkdir()
  }

  // Create link.ld if it doesn't exist
  val linkFile = new File(binDir, "link.ld")
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
    println(s"Created link.ld in ${binDir.getAbsolutePath}")
  }

  // Get the path to the binary file
  def getBinaryPath(filename: String): String = {
    new File(binDir, filename).getAbsolutePath
  }

  // Helper function to compile test
  def compileTest(testName: String): String = {
    val sourceFile = new File(binDir, s"${testName}.s")
    val objectFile = new File(binDir, s"${testName}.o")
    val executableFile = new File(binDir, s"${testName}.out")
    val binaryFile = new File(binDir, s"${testName}.bin")

    if (!sourceFile.exists()) {
      fail(s"Source file ${sourceFile.getAbsolutePath} not found")
    }

    println(s"Compiling $testName for simulation testing...")

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

    // Return the path to the binary file
    binaryFile.getAbsolutePath
  }

  // Helper function to compile and run a test in the simulator
  def runSimulatorTest(testName: String, expectedResults: Map[Int, Int]): Unit = {
    // Compile the test
    val binFile = compileTest(testName)

    println(s"\n===== STARTING $testName SIMULATION =====")
    println(s"Binary file: $binFile")

    try {
      // Run the simulator using Util.getCode
      val (code, start) = Util.getCode(binFile)
      val sim = new SimRV(code, start, start + code.length * 4)

      println("\n----- FINAL REGISTER STATE -----")

      // Check register values
      var allPassed = true
      for ((reg, expectedValue) <- expectedResults) {
        val actualValue = sim.reg(reg)
        println(f"Register x$reg: Actual=0x${actualValue}%08x, Expected=0x${expectedValue}%08x")

        if (actualValue != expectedValue) {
          allPassed = false
          println(f"ERROR: Register x$reg value mismatch: 0x${actualValue}%08x, expected: 0x${expectedValue}%08x")
        }
      }

      // Final assertion for the test
      assert(allPassed, "One or more register values did not match expected values")
    } catch {
      case e: Exception =>
        println(s"Error running simulator test: ${e.getMessage}")
        e.printStackTrace()
        fail(s"Error running simulator test: ${e.getMessage}")
    }
  }
}

/**
 * Test for CSR Instructions
 */
class CSRSimInstructionsTest extends CSRSimBaseTest {
  // Define the expected register values
  val csrTestExpected = Map(
    REGS.x3   -> 0x00000000,      // Original mstatus (0)
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

  "CSR Instructions Test" should "pass in the simulator" in {
    runSimulatorTest("CSR_full_test", csrTestExpected)
  }
}

/**
 * Test for Exception Handling
 */
class CSRSimExceptionHandlingTest extends CSRSimBaseTest {
  // Define the expected register values
  val exceptionTestExpected = Map(
    REGS.x10 -> 1,          // Success code
    REGS.x12 -> 0xFEFEFEFE, // Illegal instruction from mtval
    REGS.x21 -> 2,          // Last exception cause = 2
    REGS.x22 -> 42,         // Success code for handling ecall
    REGS.x23 -> 0xFEFEFEFE, // Illegal instruction from mtval
    REGS.x24 -> 0x55,       // Success code for handling illegal instr
  )

  "Exception Handling Test" should "pass in the simulator" in {
    runSimulatorTest("Exception_test", exceptionTestExpected)
  }
}

/**
 * Test for CSR Edge Cases
 */
class CSRSimEdgeCasesTest extends CSRSimBaseTest {
  // Define the expected register values
  val csrEdgeCaseTestExpected = Map(
    REGS.x2   -> 0x12345678, // x2 (CSRRS with rs1=x0)
    REGS.x3   -> 0x12345678, // x3 (CSRRC with rs1=x0)
    REGS.x4   -> 0x12345678, // x4 (verify mstatus unchanged)
    REGS.x5   -> 0x12345678, // x5 (CSRRSI with zimm=0)
    REGS.x6   -> 0x12345678, // x6 (CSRRCI with zimm=0)
    REGS.x8   -> 0xABCDEF01, // x8 (verify mstatus updated by CSRRW)
    REGS.x9   -> 0xABCDEFFF, // x9 (verify mstatus updated by CSRRS)
    REGS.x10  -> 0x0000002F, // x10 (marchid value)
    REGS.x11  -> 0x0000002F, // x11 (verify marchid unchanged)
    REGS.x13  -> 0x40000101, // x13 (verify MISA Start value)
    REGS.x14  -> 0x40000101  // x14 (verify MISA MASK)
  )

  "CSR Edge Cases Test" should "pass in the simulator" in {
    runSimulatorTest("CSR_edgecases_test", csrEdgeCaseTestExpected)
  }
}

class ClintSimTest extends CSRSimBaseTest {
  // Define the expected register values
  val ClintTestExpected = Map(
    REGS.x10  -> 0x00000001, // a0 = 1 is a test success
    REGS.x11  -> 0x00000001, // a1 = 1 is a test success
    REGS.x12  -> 0x00000001, // a2 = 1 is a test success
  )

  "Clint Sim Test" should "pass in the simulator" in {
    runSimulatorTest("CLINT_test", ClintTestExpected)
  }
}

/**
 * Main combined test class that runs all CSR simulator tests
 */
class CSRSimAllTests extends CSRSimBaseTest {
  // Create instances of the individual test classes
  val instructionsTest = new CSRSimInstructionsTest()
  val exceptionTest = new CSRSimExceptionHandlingTest()
  val edgeCasesTest = new CSRSimEdgeCasesTest()
  val ClintTest = new ClintSimTest()

  "CSR Instructions" should "pass all simulator tests" in {
    runSimulatorTest("CSR_full_test", instructionsTest.csrTestExpected)
  }

  "CSR Exception Handling" should "pass all simulator tests" in {
    runSimulatorTest("Exception_test", exceptionTest.exceptionTestExpected)
  }

  "CSR Edge Cases" should "pass all simulator tests" in {
    runSimulatorTest("CSR_edgecases_test", edgeCasesTest.csrEdgeCaseTestExpected)
  }

  "Clint Sim test" should "pass all simulator tests" in {
    runSimulatorTest("CLINT_test", ClintTest.ClintTestExpected)
  }
}