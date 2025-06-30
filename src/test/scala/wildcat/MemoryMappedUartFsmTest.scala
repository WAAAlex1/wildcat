package uart

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import chisel3.util._

/**
 * Comprehensive testbench for MemoryMappedUartWithInterrupts
 * Tests threshold interrupts, timeout interrupts, and edge cases with the new FSM
 */
class MemoryMappedUartFsmTest extends AnyFlatSpec with ChiselScalatestTester {

  // Use compatible settings for simulation
  val testFreq = 1000000    // 1MHz
  val testBaud = 10000      // 10kbaud (much slower for better compatibility)
  val cyclesPerBit = testFreq / testBaud  // 100 cycles per bit
  val cyclesPerChar = cyclesPerBit * 10   // 1000 cycles per character

  // DEBUGGING TOGGLE - Set to true for detailed debug output
  val DEBUG_ENABLED = false

  /**
   * Debug print function that only prints when debugging is enabled
   */
  def debugPrint(msg: String): Unit = {
    if (DEBUG_ENABLED) {
      println(s"[DEBUG] $msg")
    }
  }

  /**
   * Debug function to print FSM state and buffer status
   */
  def debugFsmState(dut: MemoryMappedUartWithInterrupts, context: String): Unit = {
    if (DEBUG_ENABLED) {
      val fsmState = dut.io.timeoutFsmState.peekInt()
      val counter = dut.io.timeoutCounterValue.peekInt()
      val rxThresh = dut.io.rxThresholdActive.peek().litToBoolean
      val rxTimeout = dut.io.rxTimeoutActive.peek().litToBoolean
      val interrupt = dut.io.rxInterrupt.peek().litToBoolean
      val status = busRead(dut, 4)

      println(s"[FSM-DEBUG] $context:")
      println(s"  FSM State: $fsmState (${getFsmStateName(fsmState)})")
      println(s"  Counter: $counter")
      println(s"  Threshold Active: $rxThresh")
      println(s"  Timeout Active: $rxTimeout")
      println(s"  Interrupt: $interrupt")
      println(s"  Status Reg: 0x${status.toString(16)}")
      println()
    }
  }

  /**
   * Helper to get FSM state name for debugging
   */
  def getFsmStateName(state: BigInt): String = {
    state.toInt match {
      case 0 => "sIdle"
      case 1 => "sDelay"
      case 2 => "sTimeout"
      case 3 => "sTriggered"
      case 4 => "sThresholdMet"
      case _ => "Unknown"
    }
  }

  /**
   * Helper function to send a single character via UART RX pin
   */
  def sendUartChar(dut: MemoryMappedUartWithInterrupts, char: Int): Unit = {
    debugPrint(s"Sending character: '${char.toChar}' (0x${char})")

    // Ensure we start from idle (high)
    dut.io.pins.rx.poke(true.B)
    dut.clock.step(cyclesPerBit)

    // Start bit (0) - hold for full bit time
    dut.io.pins.rx.poke(false.B)
    dut.clock.step(cyclesPerBit)

    // 8 data bits (LSB first) - hold each bit for full bit time
    for (i <- 0 until 8) {
      val bit = ((char >> i) & 1) == 1
      dut.io.pins.rx.poke(bit)
      dut.clock.step(cyclesPerBit)
    }

    // Stop bit (1) - hold for full bit time
    dut.io.pins.rx.poke(true.B)
    dut.clock.step(cyclesPerBit)

    // Extra idle time between characters
    dut.clock.step(cyclesPerBit / 2)

    debugPrint(s"Character '${char.toChar}' transmission complete")
  }

  /**
   * Helper function to send multiple characters
   */
  def sendUartString(dut: MemoryMappedUartWithInterrupts, str: String): Unit = {
    debugPrint(s"Sending string: \"$str\"")
    str.foreach(c => sendUartChar(dut, c.toInt))
    debugPrint(s"String transmission complete")
  }

  /**
   * Helper function to perform a single bus read transaction
   */
  def busRead(dut: MemoryMappedUartWithInterrupts, addr: Int): BigInt = {
    // Assert read request
    dut.io.port.read.poke(true.B)
    dut.io.port.write.poke(false.B)
    dut.io.port.addr.poke(addr.U)
    dut.io.port.wrData.poke(0.U)
    dut.clock.step(1)

    // Deassert and read result
    dut.io.port.read.poke(false.B)
    dut.clock.step(1)
    val data = dut.io.port.rdData.peekInt()
    dut.clock.step(1) // Extra cycle for safety

    debugPrint(s"Bus read from addr 0x${addr}: 0x${data}")
    data
  }

  /**
   * Helper function to perform a single bus write transaction
   */
  def busWrite(dut: MemoryMappedUartWithInterrupts, addr: Int, data: Int): Unit = {
    debugPrint(s"Bus write to addr 0x${addr}: 0x${data}")

    // Assert write request
    dut.io.port.read.poke(false.B)
    dut.io.port.write.poke(true.B)
    dut.io.port.addr.poke(addr.U)
    dut.io.port.wrData.poke(data.U)
    dut.clock.step(1)

    // Deassert
    dut.io.port.write.poke(false.B)
    dut.io.port.wrData.poke(0.U)
    dut.clock.step(1)
  }

  /**
   * Initialize bus port to idle state
   */
  def initBusPort(dut: MemoryMappedUartWithInterrupts): Unit = {
    dut.io.port.read.poke(false.B)
    dut.io.port.write.poke(false.B)
    dut.io.port.addr.poke(0.U)
    dut.io.port.wrData.poke(0.U)
  }

  "MemoryMappedUartWithInterrupts" should "initialize correctly" in {
    test(new MemoryMappedUartWithInterrupts(testFreq, testBaud, 16, 16, 4, 4))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>

        dut.clock.setTimeout(50000)
        initBusPort(dut)
        dut.io.pins.rx.poke(true.B)  // Idle high
        dut.clock.step(10)

        debugFsmState(dut, "Initial state")

        // Check initial state
        assert(!dut.io.rxInterrupt.peek().litToBoolean, "RX interrupt should be false initially")
        assert(!dut.io.rxTimeoutActive.peek().litToBoolean, "RX timeout should be false initially")
        assert(!dut.io.rxThresholdActive.peek().litToBoolean, "RX threshold should be false initially")

        // Check FSM is in idle state (0)
        assert(dut.io.timeoutFsmState.peekInt() == 0, "FSM should be in idle state initially")

        // Initial status should show TX ready, no RX data
        val status = busRead(dut, 4)
        assert((status & 0x01) != 0, "TX should be ready initially")
        assert((status & 0x02) == 0, "RX should be empty initially")

        debugPrint("Initialization test PASSED")
      }
  }

  "MemoryMappedUartWithInterrupts" should "generate threshold interrupt" in {
    test(new MemoryMappedUartWithInterrupts(testFreq, testBaud, 16, 16, 4, 4))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>

        dut.clock.setTimeout(50000)
        initBusPort(dut)
        dut.io.pins.rx.poke(true.B)
        dut.clock.step(10)

        debugFsmState(dut, "Before enabling interrupts")

        // Enable RX interrupts (bit 2)
        busWrite(dut, 4, 0x04)
        dut.clock.step(5)

        debugFsmState(dut, "After enabling interrupts")

        // Send 3 characters (below threshold of 4)
        sendUartString(dut, "ABC")
        dut.clock.step(100)

        debugFsmState(dut, "After sending 3 characters")

        // FSM should be in delay or timeout state, not threshold
        val fsmAfter3 = dut.io.timeoutFsmState.peekInt()
        assert(fsmAfter3 != 4, "FSM should not be in threshold state with 3 chars") // 4 = sThresholdMet

        // Should not have threshold interrupt yet
        assert(!dut.io.rxThresholdActive.peek().litToBoolean, "Threshold should not be active with 3 chars")

        // Send 4th character to reach threshold
        sendUartChar(dut, 'D'.toInt)
        dut.clock.step(100)

        debugFsmState(dut, "After sending 4th character (threshold reached)")

        // FSM should now be in threshold state (4)
        val fsmAfter4 = dut.io.timeoutFsmState.peekInt()
        assert(fsmAfter4 == 4, "FSM should be in threshold state with 4 chars") // 4 = sThresholdMet

        // Should now have threshold interrupt
        assert(dut.io.rxInterrupt.peek().litToBoolean, "Should have interrupt with 4 chars")
        assert(dut.io.rxThresholdActive.peek().litToBoolean, "Threshold should be active with 4 chars")

        // Check status register - threshold pending should be set
        val statusAfter4 = busRead(dut, 4)
        assert((statusAfter4 & 0x10) != 0, "RX threshold pending should be set")
        assert((statusAfter4 & 0x02) != 0, "RX valid should be set")

        // Read one character - this should change FSM state from threshold back to delay/timeout
        val char1 = busRead(dut, 0)
        debugPrint(s"Read character: ${char1.toInt.toChar} (${char1})")
        dut.clock.step(10)

        debugFsmState(dut, "After reading one character")

        // FSM should transition away from threshold state since we're now below threshold
        val fsmAfterRead = dut.io.timeoutFsmState.peekInt()
        assert(fsmAfterRead != 4, "FSM should not be in threshold state after reading below threshold")

        // Threshold active should be false
        assert(!dut.io.rxThresholdActive.peek().litToBoolean, "Threshold should not be active after reading")

        debugPrint("Threshold interrupt test PASSED")
      }
  }

  "MemoryMappedUartWithInterrupts" should "handle timeout FSM correctly" in {
    test(new MemoryMappedUartWithInterrupts(testFreq, testBaud, 16, 16, 4, 4))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>

        dut.clock.setTimeout(100000)
        initBusPort(dut)
        dut.io.pins.rx.poke(true.B)
        dut.clock.step(10)

        // Enable RX interrupts
        busWrite(dut, 4, 0x04)
        dut.clock.step(10)

        debugFsmState(dut, "Before sending characters for timeout test")

        // Send 2 characters (below threshold)
        sendUartString(dut, "AB")
        dut.clock.step(100)

        debugFsmState(dut, "After sending 2 characters")

        // FSM should be in delay state (1) initially
        val fsmAfterSend = dut.io.timeoutFsmState.peekInt()
        assert(fsmAfterSend == 1 || fsmAfterSend == 2, "FSM should be in delay or timeout state")

        // Wait for timeout to trigger
        val timeoutCycles = 4 * cyclesPerChar
        debugPrint(s"Waiting for timeout ($timeoutCycles cycles)")
        dut.clock.step(timeoutCycles + 200)

        debugFsmState(dut, "After timeout period")

        // FSM should be in triggered state (3)
        val fsmAfterTimeout = dut.io.timeoutFsmState.peekInt()
        assert(fsmAfterTimeout == 3, "FSM should be in triggered state after timeout") // 3 = sTriggered

        // Should have timeout interrupt
        assert(dut.io.rxTimeoutActive.peek().litToBoolean, "Timeout should be active")
        assert(dut.io.rxInterrupt.peek().litToBoolean, "Should have interrupt from timeout")

        // Check status register
        val statusAfterTimeout = busRead(dut, 4)
        assert((statusAfterTimeout & 0x20) != 0, "RX timeout pending should be set")

        // Read a character - FSM should transition back to idle or appropriate state
        val char1 = busRead(dut, 0)
        debugPrint(s"Read character after timeout: ${char1.toInt.toChar}")
        dut.clock.step(10)

        debugFsmState(dut, "After reading character from timeout")

        // FSM should transition away from triggered state
        val fsmAfterRead = dut.io.timeoutFsmState.peekInt()
        // Should be in delay/timeout state for remaining character, or idle if buffer empty

        // Timeout active should be false after reading
        assert(!dut.io.rxTimeoutActive.peek().litToBoolean, "Timeout should not be active after reading")

        debugPrint("Timeout FSM test PASSED")
      }
  }

  "MemoryMappedUartWithInterrupts" should "handle FSM edge cases correctly" in {
    test(new MemoryMappedUartWithInterrupts(testFreq, testBaud, 16, 16, 4, 4))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>

        dut.clock.setTimeout(100000)
        initBusPort(dut)
        dut.io.pins.rx.poke(true.B)
        dut.clock.step(10)

        // Enable RX interrupts
        busWrite(dut, 4, 0x04)
        dut.clock.step(10)

        // Test 1: Send exactly threshold amount rapidly
        debugPrint("=== Test 1: Rapid threshold trigger ===")
        sendUartString(dut, "ABCD") // Exactly 4 chars
        dut.clock.step(50)

        debugFsmState(dut, "After rapid threshold trigger")
        val fsm1 = dut.io.timeoutFsmState.peekInt()
        assert(fsm1 == 4, "Should immediately go to threshold state") // 4 = sThresholdMet

        // Clear everything
        busWrite(dut, 4, 0x70) // Clear all pending flags
        dut.clock.step(5)

        // Read all characters to empty buffer
        for (i <- 0 until 4) {
          busRead(dut, 0)
          dut.clock.step(5)
        }

        // FSM should go back to idle
        dut.clock.step(10)
        debugFsmState(dut, "After emptying buffer")
        val fsmIdle = dut.io.timeoutFsmState.peekInt()
        assert(fsmIdle == 0, "FSM should return to idle when buffer empty") // 0 = sIdle

        // Test 2: New character during timeout
        debugPrint("=== Test 2: New character during timeout ===")
        sendUartChar(dut, 'X'.toInt)
        dut.clock.step(100)

        // Wait for timeout to start
        val halfTimeoutCycles = 2 * cyclesPerChar
        dut.clock.step(halfTimeoutCycles)

        debugFsmState(dut, "Mid-timeout")
        val fsmMidTimeout = dut.io.timeoutFsmState.peekInt()

        // Send another character - should reset timeout
        sendUartChar(dut, 'Y'.toInt)
        dut.clock.step(100)

        debugFsmState(dut, "After new character during timeout")
        val fsmAfterNewChar = dut.io.timeoutFsmState.peekInt()
        // Should be back in delay state, not triggered
        assert(fsmAfterNewChar != 3, "Should not be in triggered state after new character")

        // Test 3: Manual interrupt clearing
        debugPrint("=== Test 3: Manual interrupt clearing ===")

        // Let timeout expire
        val fullTimeoutCycles = 4 * cyclesPerChar
        dut.clock.step(fullTimeoutCycles + 100)

        debugFsmState(dut, "Before manual clear")
        val fsmTriggered = dut.io.timeoutFsmState.peekInt()
        assert(fsmTriggered == 3, "Should be in triggered state")

        // Manually clear timeout interrupt (bit 5)
        busWrite(dut, 4, 0x20 | 0x04) // Clear timeout + keep RX enabled
        dut.clock.step(10)

        debugFsmState(dut, "After manual clear")
        val fsmAfterClear = dut.io.timeoutFsmState.peekInt()
        assert(fsmAfterClear == 0, "FSM should return to idle after manual clear")

        assert(!dut.io.rxTimeoutActive.peek().litToBoolean, "Timeout should be cleared")
        assert(!dut.io.rxInterrupt.peek().litToBoolean, "Interrupt should be cleared")

        debugPrint("FSM edge cases test PASSED")
      }
  }

  "MemoryMappedUartWithInterrupts" should "handle interrupt enable/disable with FSM" in {
    test(new MemoryMappedUartWithInterrupts(testFreq, testBaud, 16, 16, 4, 4))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>

        dut.clock.setTimeout(50000)
        initBusPort(dut)
        dut.io.pins.rx.poke(true.B)
        dut.clock.step(10)

        // Initially disable RX interrupts
        busWrite(dut, 4, 0x00)
        dut.clock.step(5)

        debugFsmState(dut, "With interrupts disabled")

        // Send enough characters to trigger threshold
        sendUartString(dut, "ABCD")
        dut.clock.step(50)

        debugFsmState(dut, "After threshold with interrupts disabled")

        // FSM should be in threshold state even with interrupts disabled
        val fsmDisabled = dut.io.timeoutFsmState.peekInt()
        assert(fsmDisabled == 4, "FSM should be in threshold state even when interrupts disabled")

        // Should not have interrupt output (disabled)
        assert(!dut.io.rxInterrupt.peek().litToBoolean, "Should not have interrupt when disabled")

        // But threshold condition should be met
        assert(dut.io.rxThresholdActive.peek().litToBoolean, "Threshold condition should be met")

        // Enable RX interrupts
        busWrite(dut, 4, 0x04)
        dut.clock.step(2)

        debugFsmState(dut, "After enabling interrupts")

        // Should now have interrupt
        assert(dut.io.rxInterrupt.peek().litToBoolean, "Should have interrupt when enabled")
        assert(dut.io.rxThresholdActive.peek().litToBoolean, "Threshold should still be active")

        // Disable interrupts again
        busWrite(dut, 4, 0x00)
        dut.clock.step(2)

        debugFsmState(dut, "After disabling interrupts again")

        // Interrupt output should go low
        assert(!dut.io.rxInterrupt.peek().litToBoolean, "Interrupt should go low when disabled")
        // But FSM and conditions still active
        assert(dut.io.rxThresholdActive.peek().litToBoolean, "Threshold condition should still be met")

        val fsmStillThreshold = dut.io.timeoutFsmState.peekInt()
        assert(fsmStillThreshold == 4, "FSM should still be in threshold state")

        debugPrint("Interrupt enable/disable test PASSED")
      }
  }

  "MemoryMappedUartWithInterrupts" should "show FSM debug information" in {
    test(new MemoryMappedUartWithInterrupts(testFreq, testBaud, 16, 16, 4, 4))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>

        dut.clock.setTimeout(100000)
        initBusPort(dut)
        dut.io.pins.rx.poke(true.B)
        dut.clock.step(10)

        // Enable interrupts
        busWrite(dut, 4, 0x04)
        dut.clock.step(5)

        println("=== FSM State Transitions Debug ===")

        // Initial state
        debugFsmState(dut, "Initial")

        // Send one character
        sendUartChar(dut, 'A'.toInt)
        dut.clock.step(50)
        debugFsmState(dut, "After 1 character")

        // Wait some time to see transitions
        dut.clock.step(100)
        debugFsmState(dut, "After delay")

        // Send more characters to reach threshold
        sendUartString(dut, "BCD")
        dut.clock.step(50)
        debugFsmState(dut, "After reaching threshold")

        // Check status register includes FSM state in bits [9:7]
        val statusWithFsm = busRead(dut, 4)
        val fsmInStatus = (statusWithFsm >> 7) & 0x7
        val fsmFromOutput = dut.io.timeoutFsmState.peekInt()
        debugPrint(s"FSM in status register: ${fsmInStatus}, FSM output: ${fsmFromOutput}")
        assert(fsmInStatus == fsmFromOutput, "FSM state should match between status register and debug output")

        println("=== FSM Debug Test Complete ===")
      }
  }
}