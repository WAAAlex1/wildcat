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
}

/**
 * Test for CSR Instructions in the ThreeCats processor
 */
class CSRHardwareInstructionsTest extends CSRHardwareBaseTest {
  // Define the expected register values - same as in simulator tests
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

  "CSR Instructions Test" should "pass on the ThreeCats processor" in {
    // Get binary file path
    val binFile = getBinaryPath("CSR_full_test.bin")
    test(new WildcatTestTop(binFile)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Run for enough cycles to complete the test
      var i = 0
      println("---------------- STEPPING CLOCK ----------------")
      while(i < 100){
          i += 1
          dut.clock.step(1)
          for (x <- 0 until 32) {
            val r = dut.io.regFile(x).peekInt()
            println(f"reg($x) = ${r}")
          }
      }
      // Check register values
      for ((reg, expectedValue) <- csrTestExpected) {
        val actualValue = dut.io.regFile(reg).peekInt()
        assert(actualValue == expectedValue,
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

  "CSR Edge Cases Test" should "pass on the ThreeCats processor" in {
    // Get binary file path
    val binFile = getBinaryPath("CSR_edgecases_test.bin")

    test(new WildcatTestTop(binFile)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Run for enough cycles to complete the test
      dut.clock.step(100)

      // Check register values
      for ((reg, expectedValue) <- csrEdgeCaseTestExpected) {
        val actualValue = dut.io.regFile(reg).peekInt()
        assert(actualValue == expectedValue,
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
    REGS.x21 -> 1,          // Last exception cause = 2
    REGS.x22 -> 42,         // Success code for handling ecall
    REGS.x23 -> 0xFEFEFEFE, // Illegal instruction from mtval
    REGS.x24 -> 0x55,       // Success code for handling illegal instr
  )

  "Exception Handling Test" should "pass on the ThreeCats processor" in {
    // Get binary file path
    val binFile = getBinaryPath("Exception_test.bin")

    test(new WildcatTestTop(binFile)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Will need more steps for exception handling test
      var cycles = 0
      var testFinished = false

      while (cycles < 500 && !testFinished) {
        dut.clock.step(1)
        cycles += 1

        // Check if we're at the success_end loop indicated by x10 = 1
        val x10Value = dut.io.regFile(10).peekInt()
        if (x10Value == 1) {
          testFinished = true
        }
      }

      // Check if we reached the success point
      assert(testFinished, "Test didn't reach success endpoint within timeout")

      // Check register values
      for ((reg, expectedValue) <- exceptionTestExpected) {
        val actualValue = dut.io.regFile(reg).peekInt()
        assert(actualValue == expectedValue,
          f"Register x$reg value: 0x${actualValue}%08x, expected: 0x${expectedValue}%08x")
      }
    }
  }
}