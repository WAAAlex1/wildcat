/*
    First draft : Being able to send byte[] through UART
        Needs to be able to send many bytes over UART
        Needs to determine structure of address and data. Maybe 32address followed by 32data for every word?



 */

import com.fazecast.jSerialComm.*;
import java.util.HexFormat;

public class SendUART {
    public static void main(String[] args) {
        // Identify available serial ports

        SerialPort[] ports = SerialPort.getCommPorts();
        if(ports.length == 0) System.out.println("No COM ports found ;(");

        for (SerialPort port : ports) {
            System.out.println("Found Port: " + port.getSystemPortName());
        }

        // Open the serial port (Change COM3 to your actual port)
        SerialPort serialPort = SerialPort.getCommPort("COM3"); //Alexander's laptop had COM7
        serialPort.setBaudRate(9600);  // Set baud rate (match with receiver)
        serialPort.setNumDataBits(8);
        serialPort.setNumStopBits(SerialPort.ONE_STOP_BIT);
        serialPort.setParity(SerialPort.NO_PARITY);

        if (!serialPort.openPort()) {
            System.out.println("Failed to open port.");
            return;
        }

        SerialPort serialPort4 = SerialPort.getCommPort("COM4");
        if (!serialPort4.openPort()) {
            System.out.println("Failed to open port.");
            return;
        }

        System.out.println("Port opened successfully.");

        // Send data
            // This byte array should contain the addresses and instructions for turning on the LED on the FPGA board
        byte[] data = HexFormat.of().parseHex("000000000012829300000004e00003370000000800530023");
        serialPort.writeBytes(data, data.length);
        System.out.println("Data sent: ");

        // Close the port
        /*
        boolean varb = true;
        while(varb)
        {
            varb = true;
        }
        */
        serialPort.closePort();
        System.out.println("Port closed.");

    }



}
