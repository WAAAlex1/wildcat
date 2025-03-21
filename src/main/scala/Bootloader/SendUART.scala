package Bootloader

/*
    First draft : Being able to send bytes through UART
        Needs to be able to send many bytes over UART
        Needs to determine structure of address and data. Maybe 32bit address followed by 32bit data for every word?
 */

import com.fazecast.jSerialComm._

import java.nio.ByteBuffer
import java.util.HexFormat
import scala.math.BigInt
import scala.io.Source
import scala.util.Try

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
    else{
      System.out.println("Port opened successfully.")
    }

    /*
    // Send data - Test program using hardcoded data
    // This byte array should contain the addresses and instructions for turning on the LED on the FPGA board
    val data = Array[Byte](0xF0.toByte,0x01.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0xFF.toByte,0xF1.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x00.toByte,0x01.toByte)

    for(i <- data){
      serialPort.writeBytes(data.slice(i,i+4),4)
      System.out.println(data.slice(i,i+4).mkString("Array(", ", ", ")")) //Check what we are sending
    }
    */

    // Send data - actual program fetching data from file
    val filePath = "ElfTranslated.txt" // Get data from the translated elf file

    try {
      val source = Source.fromFile(filePath)

      for (line <- source.getLines()) { // Reading file line by line
        val parts = line.trim.split("\\s+") // Splitting on one or more spaces

        // Get the address - make into byte array - pad byte array to always be 4 bytes (32bit)
        val address = parts(0).toInt
        //val addressBytes = BigInt(address).toByteArray
        val addressBytesPadded = ByteBuffer.allocate(4).putInt(address).array()
        //val addressBytesPadded = addressBytes.reverse.padTo(4,0).reverse //Pad to always 4 bytes (might be needed for small values)

        // Get the data - make into byte array - pad byte array to always be 4 bytes (32bit)
        val data = parts(1).toInt
        val dataBytesPadded = ByteBuffer.allocate(4).putInt(data).array()
        //val dataBytes = BigInt(data).toByteArray
        //val dataBytesPadded = dataBytes.reverse.padTo(4, 0).reverse //Pad to always 4 bytes (might be needed for small values)

        // Write address (4 bytes)
        serialPort.writeBytes(addressBytesPadded.slice(0,4), 4)
        System.out.println(addressBytesPadded.mkString("Array(", ", ", ")")) //Check what we are sending

        // Write data (4 bytes)
        serialPort.writeBytes(dataBytesPadded.slice(0,4), 4)
        System.out.println(dataBytesPadded.mkString("Array(", ", ", ")")) //Check what we are sending
      }
      source.close() // Make sure to close the file we read from

    } catch {
      case ex: Exception => println(s"Error reading file: ${ex.getMessage}")
    }

    System.out.println("Data sent.")
    serialPort.closePort  // Make sure to close the SerialPort
    System.out.println("Port closed.")
  }
}
