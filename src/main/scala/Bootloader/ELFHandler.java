package Bootloader;

import java.io.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class ELFHandler {
    public static void main(String[] args) {
        String elfFilePath = "test.elf"; // Replace with actual ELF file when time comes

        try {
            // Get loadable program headers
            ProcessBuilder pb = new ProcessBuilder("readelf", "-l", elfFilePath); //This effective creates the bash readelf -l theElfFile.elf
            Process process = pb.start(); //this effectively runs the bash

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream())); //Get the output from running the bash
            String line;

            // Parse the program header output
            //For each line in the output we run this
            while ((line = reader.readLine()) != null) {
                if (line.contains("LOAD")) {
                    String[] parts = line.trim().split("\\s+"); // Regex magic, split when one or more whitespace characters

                    //Expect three parts - file offset - load address - file size (bytes)
                    int fileOffset = Integer.decode(parts[1]);  // Extract file offset
                    int physAddress = Integer.decode(parts[2]); // Extract load address
                    int fileSize = Integer.decode(parts[3]);  // Extract file size

                    //Useful debugging outputs
                    System.out.printf("Loading Segment: Offset 0x%X -> Address 0x%X (%d bytes)%n",
                            fileOffset, physAddress, fileSize);

                    // Read the binary data
                    // Use a custom function for this
                    extractAndSendData(elfFilePath, fileOffset, physAddress, fileSize);
                }
            }

            process.waitFor();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void extractAndSendData(String elfFilePath, int fileOffset, int physAddress, int fileSize) {
        try (RandomAccessFile elfFile = new RandomAccessFile(elfFilePath, "r")) {
            elfFile.seek(fileOffset); // Move to the segment's file offset
            byte[] data = new byte[fileSize];
            elfFile.readFully(data); // Read binary data

            String filePath = "ELF_TRANSLATED.txt";

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {

                // Step 4: Output [address] [data] pairs to file (also write to System.out.printf)
                for (int i = 0; i < fileSize; i += 4) {

                    int address = physAddress + i; //Generate correct address
                    int value = ByteBuffer.wrap(data, i, 4).order(ByteOrder.LITTLE_ENDIAN).getInt(); //Generate data
                    System.out.printf("0x%08X 0x%08X%n", address, value); //Print to console

                    writer.write(address + "  " + value); // Writing to file with whitespace separator
                    writer.newLine(); // Move to next line
                }
                System.out.println("Data written to " + filePath);

            } catch (IOException e) {
                e.printStackTrace();
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

