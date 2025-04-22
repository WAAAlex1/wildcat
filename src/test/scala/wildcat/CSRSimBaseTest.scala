package wildcat

import org.scalatest.flatspec.AnyFlatSpec
import wildcat.isasim.SimRV
import java.io.File
import wildcat.REGS
/**
 * Base class for CSR and Exception handling tests
 */
abstract class CSRSimBaseTest extends AnyFlatSpec {
  // Create the bin directory if it doesn't exist
  val binDir = new File("bin")
  if (!binDir.exists()) {
    binDir.mkdir()
  }

  // Get the path to the binary file
  def getBinaryPath(filename: String): String = {
    new File("bin", filename).getAbsolutePath
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
    // Get binary file path
    val binFile = getBinaryPath("CSR_full_test.bin")

    // Run the simulator using Util.getCode
    val (code, start) = Util.getCode(binFile)
    val sim = new SimRV(code, start, start + code.length * 4)

    // Check register values
    for ((reg, expectedValue) <- csrTestExpected) {
      val actualValue = sim.reg(reg)
      assert(actualValue == expectedValue,
        f"Register x$reg value: 0x${actualValue}%08x, expected: 0x${expectedValue}%08x")
    }
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
    REGS.x24 -> 0x55,       // Success code fro handling illegal instr
  )

  "Exception Handling Test" should "pass in the simulator" in {
    // Get binary file path
    val binFile = getBinaryPath("Exception_test.bin")

    // Run the simulator using Util.getCode
    val (code, start) = Util.getCode(binFile)
    val sim = new SimRV(code, start, start + code.length * 4)

    // Check register values
    for ((reg, expectedValue) <- exceptionTestExpected) {
      val actualValue = sim.reg(reg)
      assert(actualValue == expectedValue,
        f"Register x$reg value: 0x${actualValue}%08x, expected: 0x${expectedValue}%08x")
    }
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
    // Get binary file path
    val binFile = getBinaryPath("CSR_edgecases_test.bin")

    // Run the simulator using Util.getCode
    val (code, start) = Util.getCode(binFile)
    val sim = new SimRV(code, start, start + code.length * 4)

    // Check register values
    for ((reg, expectedValue) <- csrEdgeCaseTestExpected) {
      val actualValue = sim.reg(reg)
      assert(actualValue == expectedValue,
        f"Register x$reg value: 0x${actualValue}%08x, expected: 0x${expectedValue}%08x")
    }
  }
}