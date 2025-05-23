package Bootloader

/*
 * New SendUART will take any binary file and send it with correct addresses.
 *
 * By @GeorgBD
 */

import com.fazecast.jSerialComm._
import os.FileType.File

import java.io.File
import java.nio.ByteBuffer
import scala.io.Source
import java.nio.file.{Files, Paths}
/*
import java.util.HexFormat
import scala.math.BigInt
import scala.util.Try
 */

object SendUART {
  def main(args: Array[String]): Unit = {
    //Make sure we got a file:
    if (args.length != 1) {
      println("Usage: ReadFileBytes <file-path>")
      System.exit(1)
    }

    // Identify available serial ports
    val ports = SerialPort.getCommPorts
    if (ports.isEmpty) System.out.println("No COM ports found ;(")

    var foundPortName = "COM4" //Standard COM port found on Georg's PC
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

    //Get the bytes of the file to send:
    val programPath = Paths.get(args(0))
    val programBytes = Files.readAllBytes(programPath)
    val zsblPath = Paths.get("ZSBL_demo.bin")
    val zsblBytes = Files.readAllBytes(zsblPath)
    val traphandlerPath = Paths.get("Exception_Handler.bin")
    val traphandlerBytes = Files.readAllBytes(traphandlerPath)
    val uartTestPath = Paths.get("helloUart.bin")
    val uartTestBytes = Files.readAllBytes(uartTestPath)

    //Send ZSBL:
    sendFile(zsblBytes, serialPort, 0x0)

    //Send the program
    sendFile(programBytes, serialPort,  0x100)

    //Send exception handler
    sendFile(traphandlerBytes, serialPort,  0x00300000)

    //Uart test program
    //sendFile(uartTestBytes, serialPort,  0x0)

    //Set the bootloader to sleep and stop stalling the wildcat:
    bootloaderSleep(serialPort)

    System.out.println("Data sent.")
    serialPort.closePort  // Make sure to close the SerialPort
    System.out.println("Port closed.")
  }

  def sendFile(bytes: Array[Byte], serialPort: SerialPort, startAddr: Int): Unit = {
    var address = startAddr

    for(i <- 0 until (Math.ceil(bytes.length / 4.0)).toInt){  // Reading 4 bytes at a time
      val start = i * 4
      val end = Math.min(start + 4, bytes.length)
      val chunk = bytes.slice(start, end)
      val paddedChunk = if (chunk.length < 4) chunk ++ Array.fill[Byte](4 - chunk.length)(0.toByte) else chunk

      if(!(paddedChunk(0) == 0x00 && paddedChunk(1) == 0x00 && paddedChunk(2) == 0x00 && paddedChunk(3) == 0x00)) {
        val addressBytesPadded = ByteBuffer.allocate(4).putInt(address).array()

        // Write address (4 bytes) little endian (reverse needed)
        serialPort.writeBytes(addressBytesPadded.reverse, 4)
        println(addressBytesPadded.map(b => f"0x$b%02X").mkString("Address: (", " ", ")"))

        // Write data (4 bytes) little endian (no reverse needed)
        serialPort.writeBytes(paddedChunk, 4)
        println(paddedChunk.map(b => f"0x$b%02X").mkString("Data: (", " ", ")"))
      }
      address += 4
    }
  }

  def bootloaderSleep(serialPort: SerialPort): Unit = {
    System.out.println("Putting Bootloader to sleep and unstalling pipeline")
    // This byte array should turn on the LED on the FPGA board and sleep the bootloader
    //Changed to little endian
    val blSleepProtocol = Array[Byte](0x00.toByte, 0x00.toByte, 0x01.toByte, 0xF0.toByte, 0xFF.toByte, 0x00.toByte, 0x00.toByte, 0x00.toByte, 0x00.toByte, 0x00.toByte, 0x00.toByte, 0xF1.toByte, 0x01.toByte, 0x00.toByte, 0x00.toByte, 0x00.toByte)
    serialPort.writeBytes(blSleepProtocol, 16)
    println(blSleepProtocol.map(b => f"0x$b%02X").mkString("BootSleep: (", " ", ")"))
  }


}
