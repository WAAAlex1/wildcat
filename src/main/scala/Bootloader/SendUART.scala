package Bootloader

/*
    First draft : Being able to send bytes through UART
        Needs to be able to send many bytes over UART
        Needs to determine structure of address and data. Maybe 32bit address followed by 32bit data for every word?
 */

import com.fazecast.jSerialComm._
import java.util.HexFormat
import scala.math.BigInt

object SendUART {
  def main(args: Array[String]): Unit = {
    // Identify available serial ports
    val ports = SerialPort.getCommPorts
    if (ports.length == 0) System.out.println("No COM ports found ;(")

    var foundPortName = "COM6" //Standard COM port found on Alexander PC
    for (port <- ports) {
      foundPortName = port.getSystemPortName //If other port found dynamically allocate
      System.out.println("Found Port: " + foundPortName)
    }

    val serialPort = SerialPort.getCommPort(foundPortName)
    serialPort.setBaudRate(115200) // Set baud rate (match with receiver)

    serialPort.setNumDataBits(8)
    serialPort.setNumStopBits(SerialPort.ONE_STOP_BIT)
    serialPort.setParity(SerialPort.NO_PARITY)

    if (!serialPort.openPort) {
      System.out.println("Failed to open port.")
      return
    }

    System.out.println("Port opened successfully.")
    // Send data
    // This byte array should contain the addresses and instructions for turning on the LED on the FPGA board
    val hexString = "F0010000000000FFF100000000000001"
    val data = Array[Byte](0xF0.toByte,0x01.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0xFF.toByte,0xF1.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x01.toByte)
    System.out.println(data.mkString("Array(", ", ", ")")) //Check what we are sending
    serialPort.writeBytes(data, hexString.length / 2)
    System.out.println("Data sent.")
    serialPort.closePort
    System.out.println("Port closed.")
  }
}
