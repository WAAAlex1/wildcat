package Software;

import java.io.*;
import java.nio.file.*;

public class StitchBinaries {

    public static void main(String[] args) throws IOException {
        // Input binary files
        String file1Path = "ZSBL.bin";
        String file2Path = "wildcat.dtb";
        String file3Path = "Exception_Handler.bin";
        String file4Path = "Image.bin";

        // Corresponding memory offsets
        int offset1 = 0x00000000; // 0MB
        int offset2 = 0x00100000; // 1MB
        int offset3 = 0x00300000; // 3MB
        int offset4 = 0x00400000; // 4MB

        // Read all files into byte arrays
        byte[] bin1 = Files.readAllBytes(Paths.get(file1Path));
        byte[] bin2 = Files.readAllBytes(Paths.get(file2Path));
        byte[] bin3 = Files.readAllBytes(Paths.get(file3Path));
        byte[] bin4 = Files.readAllBytes(Paths.get(file4Path));

        // Calculate size of final output (largest offset + size)
        int totalSize = Math.max(offset1 + bin1.length, Math.max(offset2 + bin2.length, Math.max(offset3 + bin3.length,offset4 + bin4.length)));
        byte[] stitched = new byte[totalSize];

        // Place each binary at its offset
        System.arraycopy(bin1, 0, stitched, offset1, bin1.length);
        System.arraycopy(bin2, 0, stitched, offset2, bin2.length);
        System.arraycopy(bin3, 0, stitched, offset3, bin3.length);
        System.arraycopy(bin4, 0, stitched, offset4, bin4.length);

        // Write output
        Files.write(Paths.get("stitched_output.bin"), stitched);
        System.out.println("✔ Binaries stitched successfully into stitched_output.bin");
    }
}
