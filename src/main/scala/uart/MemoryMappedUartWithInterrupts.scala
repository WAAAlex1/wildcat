package uart

import chisel.lib.uart._
import chisel3._
import chisel3.util._

/** Enhanced UART with robust timeout FSM that handles edge cases
 *
 * @param freq clock frequency
 * @param baud baud rate
 * @param txBufferDepth depth of transmit buffer
 * @param rxBufferDepth depth of receive buffer
 * @param rxThreshold interrupt when buffer has >= this many characters
 * @param timeoutCharTimes timeout after this many character times (default: 4)
 */
class MemoryMappedUartWithInterrupts(
                                      freq: Int,
                                      baud: Int,
                                      txBufferDepth: Int,
                                      rxBufferDepth: Int,
                                      rxThreshold: Int = 4,
                                      timeoutCharTimes: Int = 4)
  extends Module {
  val io = IO(new Bundle {
    /** bus port */
    val port = Bus.RespondPort()

    /** UART tx and rx pins */
    val pins = MemoryMappedUart.UartPins()

    /** Interrupt outputs */
    val rxInterrupt = Output(Bool())

    /** Debug outputs */
    val rxTimeoutActive = Output(Bool())
    val rxThresholdActive = Output(Bool())

    /** Additional debug outputs for FSM state */
    val timeoutFsmState = Output(UInt(3.W))
    val timeoutCounterValue = Output(UInt(32.W))
  })

  // Parameter validation
  require(rxThreshold <= rxBufferDepth, "RX threshold cannot exceed buffer depth")
  require(timeoutCharTimes > 0, "Timeout must be positive")
  require(freq > baud * 20, "Clock frequency must be much higher than baud rate")

  // UART controllers
  val transmitter = Module(new Tx(freq, baud))
  val receiver = Module(new Rx(freq, baud))

  // Buffers
  val txBuffer = Module(new Queue(UInt(8.W), txBufferDepth))
  val rxBuffer = Module(new Queue(UInt(8.W), rxBufferDepth))

  // Connect UART controllers to buffers
  txBuffer.io.deq <> transmitter.io.channel
  receiver.io.channel <> rxBuffer.io.enq

  // Calculate timeout duration in clock cycles with overflow protection
  val cyclesPerChar = (freq / baud).U
  val timeoutCycles = cyclesPerChar * timeoutCharTimes.U

  // Ensure we have adequate counter width to prevent overflow
  val counterWidth = math.max(32, math.ceil(math.log(freq * timeoutCharTimes / baud) / math.log(2)).toInt + 2)

  // RX Interrupt control registers
  val rxInterruptEnable = RegInit(false.B)
  val rxThresholdPending = RegInit(false.B)
  val rxTimeoutPending = RegInit(false.B)

  // Enhanced timeout FSM with proper state management
  object TimeoutState extends ChiselEnum {
    val sIdle = Value(0.U)           // No data in buffer
    val sDelay = Value(1.U)          // Delay period before starting timeout
    val sTimeout = Value(2.U)        // Actively counting timeout
    val sTriggered = Value(3.U)      // Timeout has expired
    val sThresholdMet = Value(4.U)   // Threshold reached, no timeout needed
  }

  val timeoutState = RegInit(TimeoutState.sIdle)
  val rxTimeoutCounter = RegInit(0.U(counterWidth.W))
  val timeoutStartDelay = RegInit(0.U(16.W))

  // Buffer status signals
  val rxBufferCount = rxBuffer.io.count
  val rxBufferHasData = rxBufferCount > 0.U
  val rxThresholdMet = rxBufferCount >= rxThreshold.U
  val newCharReceived = receiver.io.channel.valid && receiver.io.channel.ready
  val dataReadFromBuffer = io.port.hasReadRequestAt(0.U)

  // Timeout calculation with safety margins
  val delayExpired = timeoutStartDelay >= (cyclesPerChar >> 1).asUInt
  val timeoutExpired = rxTimeoutCounter >= timeoutCycles

  // Enhanced timeout FSM with comprehensive edge case handling
  switch(timeoutState) {
    is(TimeoutState.sIdle) {
      // No data in buffer - stay idle
      when(newCharReceived) {
        when(rxThresholdMet) {
          // Skip timeout if threshold immediately met
          timeoutState := TimeoutState.sThresholdMet
        }.otherwise {
          // Start delay period
          timeoutState := TimeoutState.sDelay
          timeoutStartDelay := 0.U
          rxTimeoutCounter := 0.U
        }
      }
    }

    is(TimeoutState.sDelay) {
      when(!rxBufferHasData) {
        // Buffer emptied during delay - back to idle
        timeoutState := TimeoutState.sIdle
        timeoutStartDelay := 0.U
        rxTimeoutCounter := 0.U
      }.elsewhen(newCharReceived) {
        when(rxThresholdMet) {
          // Threshold met during delay - switch to threshold state
          timeoutState := TimeoutState.sThresholdMet
        }.otherwise {
          // Reset delay for new character
          timeoutStartDelay := 0.U
          rxTimeoutCounter := 0.U
        }
      }.elsewhen(rxThresholdMet) {
        // Threshold met during delay (edge case: data read + new data arrives)
        timeoutState := TimeoutState.sThresholdMet
      }.elsewhen(delayExpired) {
        // Delay complete - start timeout counting
        timeoutState := TimeoutState.sTimeout
        rxTimeoutCounter := 0.U
      }.otherwise {
        // Continue delay
        timeoutStartDelay := timeoutStartDelay + 1.U
      }
    }

    is(TimeoutState.sTimeout) {
      when(!rxBufferHasData) {
        // Buffer emptied during timeout - back to idle
        timeoutState := TimeoutState.sIdle
        rxTimeoutCounter := 0.U
        timeoutStartDelay := 0.U
      }.elsewhen(newCharReceived) {
        when(rxThresholdMet) {
          // Threshold met - switch states
          timeoutState := TimeoutState.sThresholdMet
        }.otherwise {
          // New character - restart from delay
          timeoutState := TimeoutState.sDelay
          timeoutStartDelay := 0.U
          rxTimeoutCounter := 0.U
        }
      }.elsewhen(rxThresholdMet) {
        // Threshold met during timeout (edge case)
        timeoutState := TimeoutState.sThresholdMet
      }.elsewhen(timeoutExpired) {
        // Timeout expired - trigger interrupt
        timeoutState := TimeoutState.sTriggered
      }.otherwise {
        // Continue timeout counting with overflow protection
        when(rxTimeoutCounter < timeoutCycles) {
          rxTimeoutCounter := rxTimeoutCounter + 1.U
        }
      }
    }

    is(TimeoutState.sTriggered) {
      when(!rxBufferHasData || dataReadFromBuffer) {
        // Buffer emptied or data read - back to idle
        timeoutState := TimeoutState.sIdle
        rxTimeoutCounter := 0.U
        timeoutStartDelay := 0.U
      }.elsewhen(newCharReceived) {
        when(rxThresholdMet) {
          timeoutState := TimeoutState.sThresholdMet
        }.otherwise {
          // New character after timeout - restart from delay
          timeoutState := TimeoutState.sDelay
          timeoutStartDelay := 0.U
          rxTimeoutCounter := 0.U
        }
      }.elsewhen(rxThresholdMet) {
        // Threshold met while timeout active
        timeoutState := TimeoutState.sThresholdMet
      }
      // Stay in triggered state until buffer read or new data
    }

    is(TimeoutState.sThresholdMet) {
      when(!rxBufferHasData) {
        // Buffer completely emptied
        timeoutState := TimeoutState.sIdle
        rxTimeoutCounter := 0.U
        timeoutStartDelay := 0.U
      }.elsewhen(newCharReceived) {
        // New character - check if still above threshold
        when(rxThresholdMet) {
          // Stay in threshold state
          timeoutState := TimeoutState.sThresholdMet
        }.otherwise {
          // Dropped below threshold - restart timeout logic
          timeoutState := TimeoutState.sDelay
          timeoutStartDelay := 0.U
          rxTimeoutCounter := 0.U
        }
      }.elsewhen(!rxThresholdMet) {
        // Dropped below threshold due to reads
        when(rxBufferHasData) {
          // Still have data - restart timeout
          timeoutState := TimeoutState.sDelay
          timeoutStartDelay := 0.U
          rxTimeoutCounter := 0.U
        }.otherwise {
          // No data left
          timeoutState := TimeoutState.sIdle
          rxTimeoutCounter := 0.U
          timeoutStartDelay := 0.U
        }
      }
    }
  }

  // Interrupt condition detection using FSM state
  val rxTimeoutActive = (timeoutState === TimeoutState.sTriggered)
  val rxThresholdActive = (timeoutState === TimeoutState.sThresholdMet) || rxThresholdMet

  // Interrupt pending logic
  val prevRxThresholdActive = RegNext(rxThresholdActive, false.B)
  val prevRxTimeoutActive = RegNext(rxTimeoutActive, false.B)

  // Set/clear pending flags
  when(rxThresholdActive && !prevRxThresholdActive) {
    rxThresholdPending := true.B
  }.elsewhen(dataReadFromBuffer) {
    rxThresholdPending := false.B
  }

  when(rxTimeoutActive && !prevRxTimeoutActive) {
    rxTimeoutPending := true.B
  }.elsewhen(dataReadFromBuffer) {
    rxTimeoutPending := false.B
  }

  // Control register writes (address 0x04)
  when(io.port.hasWriteRequestAt(4.U)) {
    val writeData = io.port.wrData

    // Bit 2: RX interrupt enable
    rxInterruptEnable := writeData(2)

    // Interrupt pending flag clearing (write 1 to clear)
    when(writeData(4)) {
      rxThresholdPending := false.B
    }
    when(writeData(5)) {
      rxTimeoutPending := false.B
      when(timeoutState === TimeoutState.sTriggered) {
        timeoutState := TimeoutState.sIdle
        rxTimeoutCounter := 0.U
        timeoutStartDelay := 0.U
      }
    }
  }

  // Generate final interrupt outputs
  val rxAnyPending = rxThresholdPending || rxTimeoutPending
  io.rxInterrupt := rxInterruptEnable && rxAnyPending

  // Debug outputs
  io.rxTimeoutActive := rxTimeoutActive
  io.rxThresholdActive := rxThresholdActive
  io.timeoutFsmState := timeoutState.asUInt
  io.timeoutCounterValue := rxTimeoutCounter

  // Bus interface logic
  val hadDataReadRequest = RegNext(io.port.hasReadRequestAt(0.U), init = false.B)

  // TX buffer connection (unchanged)
  txBuffer.io.enq.bits := io.port.wrData
  txBuffer.io.enq.valid := io.port.hasWriteRequestAt(0.U)

  // RX buffer connection
  rxBuffer.io.deq.ready := hadDataReadRequest

  // Connect UART pins
  io.pins.tx := transmitter.io.txd
  receiver.io.rxd := io.pins.rx

  // Enhanced status register with FSM state visibility
  val statusRegister = Cat(
    0.U(22.W),                    // Reserved bits [31:10]
    timeoutState.asUInt,          // Bits [9:7]: FSM state for debugging
    0.U(1.W),                     // Bit 6: Reserved for TX interrupt pending
    rxTimeoutPending,             // Bit 5: RX timeout interrupt pending
    rxThresholdPending,           // Bit 4: RX threshold interrupt pending
    0.U(1.W),                     // Bit 3: Reserved for TX interrupt enable
    rxInterruptEnable,            // Bit 2: RX interrupt enable
    rxBuffer.io.deq.valid,        // Bit 1: receiver has data
    txBuffer.io.enq.ready         // Bit 0: transmitter ready
  )

  io.port.rdData := Mux(
    hadDataReadRequest,
    rxBuffer.io.deq.bits,
    statusRegister
  )
}

object MemoryMappedUartWithInterrupts {
  def apply(
             freq: Int,
             baud: Int,
             txBufferDepth: Int,
             rxBufferDepth: Int,
             rxThreshold: Int = 4,
             timeoutCharTimes: Int = 4
           ): MemoryMappedUartWithInterrupts = Module(
    new MemoryMappedUartWithInterrupts(
      freq, baud, txBufferDepth, rxBufferDepth,
      rxThreshold, timeoutCharTimes
    )
  )

  def standard(freq: Int, baud: Int = 115200): MemoryMappedUartWithInterrupts = {
    apply(
      freq = freq,
      baud = baud,
      txBufferDepth = 16,
      rxBufferDepth = 32,
      rxThreshold = 8,
      timeoutCharTimes = 4
    )
  }
}