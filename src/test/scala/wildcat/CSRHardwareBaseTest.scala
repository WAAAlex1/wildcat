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
  def printCompactDebugInfo(dut: WildcatTestTop, numCycles: Int = 0): Unit = {
    val pc = dut.io.debug_pc.peekInt()
    val instrValue = dut.io.debug_instr.peekInt()
    val branch = dut.io.debug_doBranch.peekBoolean()
    val target = dut.io.debug_branchTarget.peekInt()
    val csrResult = dut.io.debug_csrResult.peekInt()
    val csrWrite = dut.io.debug_csrWrite.peekBoolean()
    val isIllegal = dut.io.debug_isIllegal.peekBoolean()
    val isValid = dut.io.debug_isValid.peekBoolean()
    val timer = dut.io.debug_timer.peekInt()

    println(f"PC=0x${pc}%08x Instr=0x${instrValue}%08x Branch=${branch} Target=0x${target}%08x, WRITE CSR=${csrWrite}, isIllegal=${isIllegal}, isValid =${isValid}, CCnum = ${numCycles}, mtime = ${timer}")
  }

  def printDebugInfo(dut: WildcatTestTop, numCycles: Int = 0): Unit = {
    // Print PC and instruction if available
    println(f"PC: 0x${dut.io.debug_pc.peekInt()}%08x, Instruction: 0x${dut.io.debug_instr.peekInt()}%08x, Number of clock cycles: ${numCycles}")
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
  def runCSRTest(testName: String, expectedResults: Map[Int, Int], maxCycles: Int = 100, freqHz: Int = 100000000, debug: Int = 0): Unit = {
    // Compile the test
    val binFile = compileTest(testName)
    var clockCycles = 0

    test(new WildcatTestTop(file = binFile, freqHz = freqHz)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Run for enough cycles to complete the test
      println(s"\n===== STARTING $testName EXECUTION =====")
      println(s"Test binary: $binFile")
      dut.clock.setTimeout(0) // Increased from the default
      // Run for specified number of cycles
      for (i <- 1 to maxCycles) {
        dut.clock.step(1)
        clockCycles = clockCycles + 1
        if(debug == 1){
          printCompactDebugInfo(dut, clockCycles)
        }
        else if (debug == 2){
          printDebugInfo(dut, clockCycles)
        }
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

  // This is the main test method that will be run directly when testing this class
  "CSR Instructions Test" should "pass on the ThreeCats processor" in {
    runCSRTest("CSR_full_test", csrTestExpected, 50, 100000000, 1)
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
    runCSRTest("CSR_edgecases_test", csrEdgeCaseTestExpected, 100,100000000, 1)
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
    runCSRTest("Exception_test", exceptionTestExpected, 100, 100000000, 1)
  }
}

/**
 * Test for timer/counter functionality in the ThreeCats Processor.
 */
class CSRHardwareTimerTest extends CSRHardwareBaseTest {
  // Define the expected register values
  val timerTestExpected = Map(
    REGS.x30 -> 1,        // CYCLE test result
    REGS.x31 -> 1,        // TIME test result
    REGS.x29 -> 1,        // INSTRET test result
    REGS.x28 -> 1,        // MCYCLE write test result
    REGS.x10 -> 1         // Final overall result
  )

  val testFreqHz = 10000
  val numCycles = 1100 // Should take about 1000 cycles - added a little headroom.

  "Exception Handling Test" should "pass on the ThreeCats processor" in {
    runCSRTest("CSR_timer_core_test", timerTestExpected, numCycles, testFreqHz, 1)
  }
}

/**
 * Test for timer/counter functionality in the ThreeCats Processor.
 */
class CSRHardwareTimeEventTest extends CSRHardwareBaseTest {
  // Define the expected register values

  val timeEventTestExpected = Map(
    REGS.x20 -> 2,        // Number of timer interrupts received
    REGS.x29 -> 0xDEADBEEF, // Marker showing test completed
    REGS.x10 -> 1         // Final overall result
  )

  val testFreqHz = 1000
  val numCycles = 2000  // With 1kHz test frequency (safe)

    "Exception Handling Test" should "pass on the ThreeCats processor" in {
      runCSRTest("CSR_time_event_test", timeEventTestExpected, numCycles, testFreqHz, 1)
    }
}

/**
 * Test for timer/counter functionality in the ThreeCats Processor.
 */
class CSRHardwareTimerEdgecasesTest extends CSRHardwareBaseTest {
  // Define the expected register values
  val timerEdgeCasesTestExpected = Map(
    REGS.x10 -> 1,        // Overall test result (1 = all passed)
    REGS.x21 -> 1,        // Test 1: Counter increments & mcycle writability
    REGS.x22 -> 1,        // Test 2: TIME CSR write protection
    REGS.x23 -> 1,        // Test 3: mtimecmp=0 does not trigger interrupts
    REGS.x24 -> 1,        // Test 4: Basic timer interrupt trigger
    REGS.x25 -> 1,        // Test 5: Interrupt clearing works
    REGS.x26 -> 1,        // Test 6: mtimecmp=MAX disables interrupts
    REGS.x27 -> 1,        // Test 7: mie.MTIE disable/enable works
    REGS.x30 -> 1,        // Volatile interrupt flag (set by handler)
  )

  val testFreqHz = 10000
  val numCycles = 4000  // With 10kHz test frequency

    "Exception Handling Test" should "pass on the ThreeCats processor" in {
      runCSRTest("CSR_timer_edgecases_test", timerEdgeCasesTestExpected, numCycles, testFreqHz, 1)
    }
}

/**
 * Test for WFI instruction in the ThreeCats processor
 */
class CSRHardwareWfiTest extends CSRHardwareBaseTest {
  // Define the expected register values
  val wfiTestExpected = Map(
    REGS.x10 -> 1,           // Success code
    REGS.x20 -> 1,           // Interrupt handler flag
    REGS.x29 -> 0xDEADBEEF   // Test completion marker
  )

  val testFreqHz = 10000     // 10kHz for faster simulation
  val numCycles = 550        // Should be enough for interrupt to trigger

  "WFI and Timer Interrupt Test" should "pass on the ThreeCats processor" in {
    runCSRTest("WFI_test", wfiTestExpected, numCycles, testFreqHz, 1)
  }
}

/**
 * Test class for all WFI (Wait For Interrupt) edge cases
 * Extends CSRHardwareBaseTest for shared functionality
 */
class CSRHardwareWfiEdgeCasesTest extends CSRHardwareBaseTest {

  val pendingInterruptExpected = Map(
    REGS.x10 -> 1, // Success code
    REGS.x20 -> 1, // Interrupt handler executed once
    REGS.x21 -> 2, // Execution reached post-WFI point (2)
    REGS.x29 -> 0xDEADBEEF // Test completion marker
  )
  val disabledInterruptsExpected = Map(
    REGS.x10 -> 1, // Success code
    REGS.x20 -> 0, // Handler should not execute
    REGS.x21 -> 2, // Execution reached post-WFI point
    REGS.x29 -> 0xDEADBEEF // Test completion marker
  )
  val wakeupTimingExpected = Map(
    REGS.x10 -> 1, // Success code
    REGS.x20 -> 1, // Interrupt handler executed once
    REGS.x21 -> 2, // Execution reached post-WFI point
    REGS.x29 -> 0xDEADBEEF // Test completion marker
  )
  val interruptMaskingExpected = Map(
    REGS.x10 -> 1, // Success code
    REGS.x20 -> 1, // Interrupt handler executed once
    REGS.x21 -> 4, // Execution reached final phase
    REGS.x29 -> 0xCAFEBABE // Test completion marker
  )
  val reexecutionExpected = Map(
    REGS.x10 -> 1, // Success code
    REGS.x20 -> 2, // Interrupt handler executed twice
    REGS.x21 -> 2, // WFI executed twice
    REGS.x22 -> 3, // Test reached final phase
    REGS.x29 -> 0xDEADBEEF // Test completion marker
  )

  val testFreqHz = 10000      // 1kHz for faster simulation
  val numCycles = 600        // Enough cycles to complete each test

  // Test 1: WFI with already pending interrupt
  "WFI Short Nap Test" should "quickly exit sleep upon interrupt" in {
    runCSRTest("WFI_Short_Nap_test", pendingInterruptExpected, numCycles, testFreqHz, 1)
  }

  // Test 2: WFI with disabled interrupts
  "WFI Disabled Interrupts Test" should "act as NOP when interrupts are globally disabled" in {
    runCSRTest("WFI_Disabled_Interrupt_test", disabledInterruptsExpected, numCycles, testFreqHz, 1)
  }

  // Test 3: WFI wake-up timing
  "WFI Wake-up Timing Test" should "wake up at the correct time when interrupt triggers" in {
    runCSRTest("WFI_WakeUp_timing_test", wakeupTimingExpected, numCycles, testFreqHz, 1)
  }

  // Test 4: WFI with interrupt masking
  "WFI Interrupt Masking Test" should "only respond to enabled interrupt sources" in {
    runCSRTest("WFI_Interrupt_mask_test", interruptMaskingExpected, numCycles, testFreqHz, 1)
  }

  // Test 5: WFI re-execution
  "WFI Re-execution Test" should "handle consecutive WFI instructions correctly" in {
    runCSRTest("WFI_reExecution_test", reexecutionExpected, numCycles, testFreqHz, 1)
  }
}

/**
 * Main test class that combines all CSR tests
 * This class can be run directly to execute all tests
 * argument for sbt test to ignore as part of extensive test.
 */
class CSRHardwareAllTests(Ignore: String) extends CSRHardwareBaseTest {
  // This class reuses test definitions from the individual test classes
  // and calls the same shared runCSRTest method

  // Import the needed test classes
  val instructionsTest = new CSRHardwareInstructionsTest()
  val edgeCasesTest = new CSRHardwareEdgeCasesTest()
  val exceptionTest = new CSRHardwareExceptionHandlingTest()
  val timerFunctionalityTest = new CSRHardwareTimerTest()
  val timerEdgeCasesTest = new CSRHardwareTimerEdgecasesTest()
  val timeEventsTest = new CSRHardwareTimeEventTest()
  val WFITest = new CSRHardwareWfiTest()
  val WFIEdgeCasesTest = new CSRHardwareWfiEdgeCasesTest()

  "CSR Hardware Basic Instructions" should "pass all tests" in {
    runCSRTest("CSR_full_test", instructionsTest.csrTestExpected, 50, 100000000, 0)
  }

  "CSR Hardware Edge Cases" should "pass all tests" in {
    runCSRTest("CSR_edgecases_test", edgeCasesTest.csrEdgeCaseTestExpected, 100, 100000000, 0)
  }

  "CSR Hardware Exception Handling" should "pass all tests" in {
    runCSRTest("Exception_test", exceptionTest.exceptionTestExpected, 100, 100000000, 0)
  }

  "CSR Hardware Timer Functionality" should "pass all tests" in {
    runCSRTest("CSR_timer_core_test", timerFunctionalityTest.timerTestExpected, timerFunctionalityTest.numCycles, timerFunctionalityTest.testFreqHz, 0)
  }

  "CSR Timer Edge Cases" should "pass all tests" in {
    runCSRTest("CSR_timer_edgecases_test", timerEdgeCasesTest.timerEdgeCasesTestExpected, timerEdgeCasesTest.numCycles, timerEdgeCasesTest.testFreqHz, 0)
  }

  "CSR Timer Time Events" should "pass all tests" in {
    runCSRTest("CSR_time_event_test", timeEventsTest.timeEventTestExpected, timeEventsTest.numCycles, timeEventsTest.testFreqHz, 0)
  }

  "CSR WFI" should "pass all tests" in {
    runCSRTest("WFI_test", WFITest.wfiTestExpected, WFITest.numCycles, WFITest.testFreqHz, 0)
  }

  "WFI Short Nap Test" should "quickly exit sleep upon interrupt" in {
    runCSRTest("WFI_Short_Nap_test", WFIEdgeCasesTest.pendingInterruptExpected, WFIEdgeCasesTest.numCycles, WFIEdgeCasesTest.testFreqHz, 1)
  }

  "WFI Disabled Interrupts Test" should "act as NOP when interrupts are globally disabled" in {
    runCSRTest("WFI_Disabled_Interrupt_test", WFIEdgeCasesTest.disabledInterruptsExpected, WFIEdgeCasesTest.numCycles, WFIEdgeCasesTest.testFreqHz, 1)
  }

  "WFI Wake-up Timing Test" should "wake up at the correct time when interrupt triggers" in {
    runCSRTest("WFI_WakeUp_timing_test", WFIEdgeCasesTest.wakeupTimingExpected, WFIEdgeCasesTest.numCycles, WFIEdgeCasesTest.testFreqHz, 1)
  }

  "WFI Interrupt Masking Test" should "only respond to enabled interrupt sources" in {
    runCSRTest("WFI_Interrupt_mask_test", WFIEdgeCasesTest.interruptMaskingExpected, WFIEdgeCasesTest.numCycles, WFIEdgeCasesTest.testFreqHz, 1)
  }

  "WFI Re-execution Test" should "handle consecutive WFI instructions correctly" in {
    runCSRTest("WFI_reExecution_test", WFIEdgeCasesTest.reexecutionExpected, WFIEdgeCasesTest.numCycles, WFIEdgeCasesTest.testFreqHz, 1)
  }

}