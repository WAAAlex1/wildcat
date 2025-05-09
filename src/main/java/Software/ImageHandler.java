package Software;

import java.io.*;
import java.nio.file.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.zip.GZIPInputStream;

public class ImageHandler {
    public static void main(String[] args) {
        // Validate command-line arguments
        if (args.length != 2) {
            System.err.println("Usage: java ImageHandler <Image.bin.bin> <base-Address>");
            System.err.println("Example: java ImageHandler kernel.bin 0x80000000");
            System.exit(1);
        }

        try {
            // Parse input arguments
            File inputFile = new File(args[0]);
            long baseAddress = parseHexAddress(args[1]);

            // Read image file (with decompression support)
            byte[] imageData = readImageFile(inputFile);

            // Prepare output file
            try (PrintWriter writer = new PrintWriter(new FileWriter("preparedImage.txt"))) {
                // Process image data in 4-byte chunks
                for (int offset = 0; offset < imageData.length; offset += 4) {
                    // Ensure we have a full 4-byte chunk
                    byte[] chunk = new byte[4];
                    int bytesToCopy = Math.min(4, imageData.length - offset);
                    System.arraycopy(imageData, offset, chunk, 0, bytesToCopy);

                    // Convert chunk to 32-bit integer
                    int value = ByteBuffer.wrap(chunk).order(ByteOrder.LITTLE_ENDIAN).getInt();

                    // Write address and data to file
                    long currentAddress = baseAddress + offset;
                    writer.printf("0x%08X 0x%08X\n", currentAddress, value);
                }
            }

            System.out.println("Image.bin.bin prepared successfully. Output written to preparedImage.txt");

        } catch (NumberFormatException e) {
            System.err.println("Invalid base address format. Use 0x prefix for hex.");
            System.exit(1);
        } catch (IOException e) {
            System.err.println("Error processing image file: " + e.getMessage());
            System.exit(1);
        }
    }

    /**
     * Read image file, handling both compressed and uncompressed files
     * @param inputFile Input file, potentially gzipped
     * @return Byte array of the image data
     * @throws IOException If there's an error reading the file
     */
    private static byte[] readImageFile(File inputFile) throws IOException {
        // Check if the file is gzipped
        if (inputFile.getName().toLowerCase().endsWith(".gz")) {
            try (GZIPInputStream gzis = new GZIPInputStream(new FileInputStream(inputFile));
                 ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {

                int nRead;
                byte[] data = new byte[1024];
                while ((nRead = gzis.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }

                buffer.flush();
                return buffer.toByteArray();
            }
        } else {
            // For uncompressed files, read directly
            return Files.readAllBytes(inputFile.toPath());
        }
    }

    /**
     * Parse hex address string to long value
     * @param hexAddress Hex address string (e.g., "0x80000000")
     * @return Parsed long value of the address
     */
    private static long parseHexAddress(String hexAddress) {
        // Remove underscore if present and parse hex
        String cleanAddress = hexAddress.replace("_", "");
        return Long.parseUnsignedLong(cleanAddress.substring(2), 16);
    }
}