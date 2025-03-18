package Bootloader

/*
    First draft : Being able to send byte[] through UART
        Needs to be able to send many bytes over UART
        Needs to determine structure of address and data. Maybe 32address followed by 32data for every word?
 */

import com.fazecast.jSerialComm._
import java.util.HexFormat

object SendUART {
  def main(args: Array[String]): Unit = {
    // Identify available serial ports
    val ports = SerialPort.getCommPorts
    if (ports.length == 0) System.out.println("No COM ports found ;(")
    var foundPortName = "COM6"
    for (port <- ports) {
      foundPortName = port.getSystemPortName
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
    val data = HexFormat.of.parseHex("000000000012829300000004e00003370000000800530023")
    serialPort.writeBytes(data, data.length)
    System.out.println("Data sent.")
    serialPort.closePort
    System.out.println("Port closed.")
  }
}
