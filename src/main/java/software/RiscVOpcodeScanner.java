package software;

import java.io.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.*;

public class RiscVOpcodeScanner {
    // Maps for CSR privilege levels and accessibility
    private static final Map<Integer, String> privilegeLevelMap = new HashMap<>();
    private static final Map<Integer, String> accessibilityMap = new HashMap<>();

    // Counters for summary
    private static final Map<String, Integer> instructionTypeCounts = new HashMap<>();
    private static final Map<Integer, Integer> csrAddressCounts = new HashMap<>();
    private static final List<String> unknownSystemInstructions = new ArrayList<>();

    static {
        initializeCSRMaps();
    }

    public static void main(String[] args) {
        File file = new File("Image.bin.bin");
        File outputFile = new File("csr_instructions.txt");

        try (FileInputStream fis = new FileInputStream(file);
             PrintWriter writer = new PrintWriter(new FileWriter(outputFile))) {

            byte[] buffer = new byte[4];
            long offset = 0;
            int bytesRead;

            // Write header to the output file with tabs
            writer.println("=== RISC-V System/CSR Instructions Scan Results ===");
            writer.println("\n--- Known CSR Instructions ---");
            writer.println("Offset\tInstruction\tDecoded Instruction\tPrivilege Level\tUse and Accessibility");
            writer.println("----------\t----------\t------------------\t--------------\t-------------------");

            while ((bytesRead = fis.read(buffer)) == 4) {
                int instruction = ByteBuffer.wrap(buffer)
                        .order(ByteOrder.BIG_ENDIAN)
                        .getInt();

                int opcode = instruction & 0x7F;

                if (opcode == 0x73) {
                    int funct3 = (instruction >> 12) & 0x7;
                    String decoded = decodeSystemInstruction(instruction);

                    // Process based on whether this is a known or unknown instruction
                    if (decoded.startsWith("Unknown")) {
                        // Just add to the unknown list for later printing
                        unknownSystemInstructions.add(String.format("0x%08X\t0x%08X\t%s",
                                offset, instruction, decoded));

                        // Count the unknown type
                        incrementInstructionTypeCount("Unknown SYSTEM");
                    } else {
                        // For known instructions, show detailed info
                        int csrAddress = (instruction >> 20) & 0xFFF;
                        String privilegeLevel = getPrivilegeLevel(csrAddress);
                        String accessibility = getAccessibility(csrAddress);

                        writer.printf("0x%08X\t0x%08X\t%s\t%s\t%s%n",
                                offset, instruction, decoded, privilegeLevel, accessibility);

                        System.out.printf("0x%08X: 0x%08X → %s | %s | %s%n",
                                offset, instruction, decoded, privilegeLevel, accessibility);

                        // Count the CSR address and instruction type
                        incrementCSRCount(csrAddress);
                        incrementInstructionTypeCount(getBaseInstructionType(decoded));
                    }
                }

                offset += 4;
            }

            // Print unknown system instructions
            if (!unknownSystemInstructions.isEmpty()) {
                writer.println("\n--- Unknown SYSTEM Instructions ---");
                writer.println("Offset\tInstruction\tDecoded Instruction");
                writer.println("----------\t----------\t------------------");
                for (String unknownInstr : unknownSystemInstructions) {
                    writer.println(unknownInstr);
                }
            }

            if (bytesRead != -1 && bytesRead != 4) {
                String warning = "Warning: Incomplete instruction at end of file.";
                System.err.println(warning);
                writer.println("\n" + warning);
            }

            // Generate and write summary reports
            writeInstructionTypeSummary(writer);
            writeCSRAddressSummary(writer);

            System.out.println("Results written to " + outputFile.getAbsolutePath());

        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    private static String decodeSystemInstruction(int instr) {
        int funct3 = (instr >> 12) & 0x7;
        int imm12 = (instr >> 20) & 0xFFF;
        int rd = (instr >> 7) & 0x1F;
        int rs1 = (instr >> 15) & 0x1F;

        // Special cases (funct3 = 0)
        if (funct3 == 0) {
            switch (imm12) {
                case 0x000: return "ECALL";
                case 0x001: return "EBREAK";
                case 0x302: return "MRET";
                case 0x102: return "SRET";
                case 0x002: return "URET";
                default: return String.format("Unknown SYSTEM (funct3=000, imm=0x%03X)", imm12);
            }
        }

        // CSR instructions
        String csrName = getCSRName(funct3);
        if (csrName != null) {
            return String.format("%s (rd=x%d, csr=0x%03X, rs1/x=%d)", csrName, rd, imm12, rs1);
        }

        return "Unknown SYSTEM Instruction";
    }

    private static String getCSRName(int funct3) {
        switch (funct3) {
            case 0b001: return "CSRRW";
            case 0b010: return "CSRRS";
            case 0b011: return "CSRRC";
            case 0b101: return "CSRRWI";
            case 0b110: return "CSRRSI";
            case 0b111: return "CSRRCI";
            default: return null;
        }
    }

    private static String getBaseInstructionType(String fullInstruction) {
        // Extract just the instruction name without parameters
        if (fullInstruction.contains(" ")) {
            return fullInstruction.substring(0, fullInstruction.indexOf(" "));
        }
        return fullInstruction;
    }

    private static void incrementInstructionTypeCount(String instructionType) {
        instructionTypeCounts.put(instructionType,
                instructionTypeCounts.getOrDefault(instructionType, 0) + 1);
    }

    private static void incrementCSRCount(int csrAddress) {
        csrAddressCounts.put(csrAddress,
                csrAddressCounts.getOrDefault(csrAddress, 0) + 1);
    }

    private static void writeInstructionTypeSummary(PrintWriter writer) {
        writer.println("\n=== Instruction Type Summary ===");
        writer.println("Instruction Type\tCount");
        writer.println("----------------\t-----");

        // Convert to list for sorting
        List<Map.Entry<String, Integer>> entries = new ArrayList<>(instructionTypeCounts.entrySet());
        entries.sort(Map.Entry.<String, Integer>comparingByValue().reversed());

        int totalCount = 0;
        for (Map.Entry<String, Integer> entry : entries) {
            writer.printf("%s\t%d%n", entry.getKey(), entry.getValue());
            totalCount += entry.getValue();
        }

        writer.printf("Total\t%d%n", totalCount);
    }

    private static void writeCSRAddressSummary(PrintWriter writer) {
        writer.println("\n=== CSR Address Summary ===");
        writer.println("CSR Address\tPrivilege Level\tUse and Accessibility\tCount");
        writer.println("----------\t--------------\t-------------------\t-----");

        // Group CSRs by privilege level and accessibility
        Map<String, Map<String, Integer>> groupedCounts = new HashMap<>();

        for (Map.Entry<Integer, Integer> entry : csrAddressCounts.entrySet()) {
            int csrAddress = entry.getKey();
            int count = entry.getValue();
            String privilegeLevel = getPrivilegeLevel(csrAddress);
            String accessibility = getAccessibility(csrAddress);
            String key = privilegeLevel + "\t" + accessibility;

            if (!groupedCounts.containsKey(key)) {
                groupedCounts.put(key, new HashMap<>());
            }

            // Format the CSR address as a hex string
            String csrHex = String.format("0x%03X", csrAddress);
            groupedCounts.get(key).put(csrHex, count);
        }

        // Sort and print by privilege level
        List<String> keys = new ArrayList<>(groupedCounts.keySet());
        Collections.sort(keys);

        int totalCount = 0;
        int totalUniqueRegisters = 0;
        for (String key : keys) {
            String[] parts = key.split("\t");
            String privilegeLevel = parts[0];
            String accessibility = parts[1];

            Map<String, Integer> addresses = groupedCounts.get(key);
            List<Map.Entry<String, Integer>> entries = new ArrayList<>(addresses.entrySet());
            entries.sort(Map.Entry.comparingByKey());

            int subtotal = 0;
            for (Map.Entry<String, Integer> entry : entries) {
                writer.printf("%s\t%s\t%s\t%d%n",
                        entry.getKey(), privilegeLevel, accessibility, entry.getValue());
                subtotal += entry.getValue();
            }

            int uniqueRegisters = addresses.size();
            totalUniqueRegisters += uniqueRegisters;
            totalCount += subtotal;
            writer.printf("Subtotal for %s, %s: %d accesses across %d unique registers%n",
                    privilegeLevel, accessibility, subtotal, uniqueRegisters);
            writer.println();
        }

        writer.printf("Total CSR accesses: %d across %d unique registers%n", totalCount, totalUniqueRegisters);
    }

    private static void initializeCSRMaps() {
        // Unprivileged and User-Level CSRs (00 00)
        addCSRRange(0x000, 0x0FF, "Unprivileged and User-Level", "Standard read/write");
        addCSRRange(0x400, 0x4FF, "Unprivileged and User-Level", "Standard read/write");
        addCSRRange(0x800, 0x8FF, "Unprivileged and User-Level", "Custom read/write");
        addCSRRange(0xC00, 0xC7F, "Unprivileged and User-Level", "Standard read-only");
        addCSRRange(0xC80, 0xCBF, "Unprivileged and User-Level", "Standard read-only");
        addCSRRange(0xCC0, 0xCFF, "Unprivileged and User-Level", "Custom read-only");

        // Supervisor-Level CSRs (00 01)
        addCSRRange(0x100, 0x1FF, "Supervisor-Level", "Standard read/write");
        addCSRRange(0x500, 0x57F, "Supervisor-Level", "Standard read/write");
        addCSRRange(0x580, 0x5BF, "Supervisor-Level", "Standard read/write");
        addCSRRange(0x5C0, 0x5FF, "Supervisor-Level", "Custom read/write");
        addCSRRange(0x900, 0x97F, "Supervisor-Level", "Standard read/write");
        addCSRRange(0x980, 0x9BF, "Supervisor-Level", "Standard read/write");
        addCSRRange(0x9C0, 0x9FF, "Supervisor-Level", "Custom read/write");
        addCSRRange(0xD00, 0xD7F, "Supervisor-Level", "Standard read-only");
        addCSRRange(0xD80, 0xDBF, "Supervisor-Level", "Standard read-only");
        addCSRRange(0xDC0, 0xDFF, "Supervisor-Level", "Custom read-only");

        // Hypervisor and VS CSRs (00 10)
        addCSRRange(0x200, 0x2FF, "Hypervisor and VS", "Standard read/write");
        addCSRRange(0x600, 0x67F, "Hypervisor and VS", "Standard read/write");
        addCSRRange(0x680, 0x6BF, "Hypervisor and VS", "Standard read/write");
        addCSRRange(0x6C0, 0x6FF, "Hypervisor and VS", "Custom read/write");
        addCSRRange(0xA00, 0xA7F, "Hypervisor and VS", "Standard read/write");
        addCSRRange(0xA80, 0xABF, "Hypervisor and VS", "Standard read/write");
        addCSRRange(0xAC0, 0xAFF, "Hypervisor and VS", "Custom read/write");
        addCSRRange(0xE00, 0xE7F, "Hypervisor and VS", "Standard read-only");
        addCSRRange(0xE80, 0xEBF, "Hypervisor and VS", "Standard read/write");
        addCSRRange(0xEC0, 0xEFF, "Hypervisor and VS", "Custom read/write");

        // Machine-Level CSRs (00 11)
        addCSRRange(0x300, 0x3FF, "Machine-Level", "Standard read/write");
        addCSRRange(0x700, 0x77F, "Machine-Level", "Standard read/write");
        addCSRRange(0x780, 0x79F, "Machine-Level", "Standard read/write");
        addCSRRange(0x7A0, 0x7AF, "Machine-Level", "Standard read/write/debug CSRs");
        addCSRRange(0x7B0, 0x7BF, "Machine-Level", "Debug-mode-only CSRs");
        addCSRRange(0x7C0, 0x7FF, "Machine-Level", "Custom read/write");
        addCSRRange(0xB00, 0xB7F, "Machine-Level", "Standard read/write");
        addCSRRange(0xB80, 0xBBF, "Machine-Level", "Standard read/write");
        addCSRRange(0xBC0, 0xBFF, "Machine-Level", "Custom read/write");
        addCSRRange(0xF00, 0xF7F, "Machine-Level", "Standard read-only");
        addCSRRange(0xF80, 0xFBF, "Machine-Level", "Standard read/write");
        addCSRRange(0xFC0, 0xFFF, "Machine-Level", "Custom read/write");
    }

    private static void addCSRRange(int start, int end, String privilegeLevel, String accessibility) {
        for (int i = start; i <= end; i++) {
            privilegeLevelMap.put(i, privilegeLevel);
            accessibilityMap.put(i, accessibility);
        }
    }

    private static String getPrivilegeLevel(int csrAddress) {
        return privilegeLevelMap.getOrDefault(csrAddress, "Unknown");
    }

    private static String getAccessibility(int csrAddress) {
        return accessibilityMap.getOrDefault(csrAddress, "Unknown");
    }
}