package Bootloader;

import java.io.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class ELFHandler {
    public static void main(String[] args) {
        String elfFilePath = "test.elf"; // Replace with actual ELF file

        try {
            // Get loadable program headers
            // basically calls the bash readelf -l "pathToElf"
            ProcessBuilder pb = new ProcessBuilder("readelf", "-l", elfFilePath);
            Process process = pb.start();

            // get output from calling bash
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;

            // Parse the program header output
            // do this for each line found
            while ((line = reader.readLine()) != null) {
                if (line.contains("LOAD")) {
                    String[] parts = line.trim().split("\\s+");

                    // Expect three parts to each line - fileOffset - physAddress - fileSize (bytes)
                    int fileOffset = Integer.decode(parts[1]);  // Extract file offset
                    int physAddress = Integer.decode(parts[2]); // Extract load address
                    int fileSize = Integer.decode(parts[3]);  // Extract file size

                    // Output to console for debugging
                    System.out.printf("Loading Segment: Offset 0x%X -> Address 0x%X (%d bytes)%n",
                            fileOffset, physAddress, fileSize);

                    // Read the binary data using custom function
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

            String filePath = "ElfTranslated.txt"; //Path for outputting the bootloader ready data

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {

                // Output [address] [data] pairs to file
                for (int i = 0; i < fileSize; i += 4) {
                    int address = physAddress + i;
                    int value = ByteBuffer.wrap(data, i, 4).order(ByteOrder.LITTLE_ENDIAN).getInt();

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

