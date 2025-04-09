package Software;

import net.fornwall.jelf.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class ELFHandler {


    //Possible bugs / Dont really know how supposed to handle:
        // 1. What happens when a section does not have a size divisible by 4?
        //      Eg. .rodata size is 14. How should the last 32bit data look? should it be XX000000 or 000000XX ?
        // 2. Wrong fields included / Not enough fields included.
        //      Currently both .init_array and .fini_array included - are these needed? Should hold instructions
        //      For program to run before and after execution, however they cannot be translated to RISVC instructions
        //      This leads me to believe they should be excluded.
        //      The bss field does not have any data, it only reserves some addresses which should all be 0.
        //      currently it does exactly this, fill the addresses with 0, however is it needed if we already do this?
        //      Do we already do this?

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java ELFHandler <elf-file>");
            return;
        }

        String filePath = args[0];

        try {
            // Read ELF file into byte array
            byte[] elfBytes = Files.readAllBytes(Paths.get(filePath));
            ElfFile elf = ElfFile.from(elfBytes);

            File outputFile = new File("output.txt");
            FileOutputStream fos = new FileOutputStream(outputFile);

            int numSections = elf.getSectionNameStringTable().numStrings;

            for(int i = 0; i < numSections; i++){
                ElfSection section = elf.getSection(i);
                String name = section.header.getName();

                // For why these sections have been selected see https://man7.org/linux/man-pages/man5/elf.5.html
                // also see https://www.cs.cmu.edu/afs/cs/academic/class/15213-f00/docs/elf.pdf
                // and lastly also see https://refspecs.linuxfoundation.org/LSB_3.1.1/LSB-Core-PPC64/LSB-Core-PPC64/specialsections.html
                if(name != null && (name.equals(".text") | name.equals(".rodata") | name.equals(".bss") |
                   name.equals(".sdata") | name.equals(".init_array") | name.equals(".fini_array") |
                   name.equals(".data") | name.equals(".data1") | name.equals(".sbss") | name.equals(".rodata1"))){

                    long offset = section.header.sh_offset;
                    int size = (int) section.header.sh_size;
                    int address = (int) section.header.sh_addr;
                    byte[] data = section.getData();

                    // Print the details about the section to the console
                    System.out.println("Processing section: " + name);
                    System.out.println("  Section located at offset: " + offset);
                    System.out.println("  Section size: " + size + " bytes");
                    System.out.println("  Expected number of output lines: " + (size / 4) + " lines");
                    System.out.println("  STARTING WRITE AT: " + String.format("0x%08X", address));

                    //Debugging to gain insight into possible bug [1]
                    /*
                    if(name.equals(".rodata") | name.equals(".rodata1") ){
                        System.out.printf("DATADUMP FOR .rodata: ");
                        for(byte z : data){
                            System.out.printf("%02X",z);
                        }
                        System.out.printf("\n");
                    }
                     */

                    // Write data to output file in [address] [data] format
                    for (int j = 0; j < size; j += 4) {
                        // Format address as a 32-bit hexadecimal value
                        String hexAddress = String.format("0x%08X", address + j);

                        // Format the 4 bytes of data as a 32-bit hexadecimal value
                        int dataValue = 0;
                        for (int k = 0; k < 4 && j + k < data.length; k++) {
                            dataValue |= (data[j + k] & 0xFF) << (8 * k); // Shift each byte into its correct position
                        }

                        String hexData = String.format("%08X", dataValue); // Format as 32-bit hex

                        // Prepare the output line
                        String outputLine = hexAddress + " " + hexData;

                        // Write to output file (only the actual data)
                        fos.write(outputLine.getBytes());
                        fos.write("\n".getBytes());

                        // Print to the console
                        System.out.println(outputLine);
                    }
                    System.out.println("Finished processing section: " + name + "\n");
                }
            }

            fos.close();
            System.out.println("Data extraction complete. Output written to output.txt");

        } catch (IOException e) {
            System.err.println("Error reading ELF file: " + e.getMessage());
        }
    }
}