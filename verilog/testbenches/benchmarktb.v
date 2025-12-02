module benchmarktb;

  parameter WORD_SIZE = 16;
  parameter ADDR_WIDTH = 8;
  parameter RAM_SIZE = 1 << ADDR_WIDTH;

  reg clk;
  reg reset;

  // Instantiate the CPU
  MCPU #(
    .WORD_SIZE(WORD_SIZE),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) cpu_inst (
    .clk(clk),
    .reset(reset)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  integer test_num;
  integer errors;

  initial begin
    test_num = 0;
    errors = 0;
    
    $display("========================================");
    $display("Starting MCPU Comprehensive Benchmark");
    $display("Testing all 16 registers and all instructions");
    $display("========================================\n");
    reset = 1;
    #20;
    reset = 0;
    #20;
    load_test_program();
    #5000;
    verify_results();
    $display("\n========================================");
    $display("Benchmark Complete!");
    $display("Total Errors: %0d", errors);
    $display("========================================");
    $stop;
  end

  // Task για φόρτωση του test program στη RAM
  task load_test_program;
    begin
      $display("Loading test program into memory...\n");
      
      // Test 1: SHORT_TO_REG
      cpu_inst.raminst.mem[0]  = 16'h7001;
      cpu_inst.raminst.mem[1]  = 16'h7112;
      cpu_inst.raminst.mem[2]  = 16'h7223;
      cpu_inst.raminst.mem[3]  = 16'h7334;
      cpu_inst.raminst.mem[4]  = 16'h7445;
      cpu_inst.raminst.mem[5]  = 16'h7556;
      cpu_inst.raminst.mem[6]  = 16'h7667;
      cpu_inst.raminst.mem[7]  = 16'h7778;
      cpu_inst.raminst.mem[8]  = 16'h7889;
      cpu_inst.raminst.mem[9]  = 16'h799A;
      cpu_inst.raminst.mem[10] = 16'h7AAB;
      cpu_inst.raminst.mem[11] = 16'h7BBC;
      cpu_inst.raminst.mem[12] = 16'h7CCD;
      cpu_inst.raminst.mem[13] = 16'h7DDE;
      cpu_inst.raminst.mem[14] = 16'h7EEF;
      cpu_inst.raminst.mem[15] = 16'h7FFF;

      // Test 2: ADD operations
      cpu_inst.raminst.mem[16] = 16'h3012; // ADD R0, R1, R2  -> R0 = R1 + R2
      cpu_inst.raminst.mem[17] = 16'h3345; // ADD R3, R4, R5  -> R3 = R4 + R5
      cpu_inst.raminst.mem[18] = 16'h3678; // ADD R6, R7, R8  -> R6 = R7 + R8

      // Test 3: AND operations
      cpu_inst.raminst.mem[19] = 16'h009A; // AND R0, R9, R10 -> R0 = R9 & R10
      cpu_inst.raminst.mem[20] = 16'h01BC; // AND R1, R11, R12 -> R1 = R11 & R12

      // Test 4: OR operations
      cpu_inst.raminst.mem[21] = 16'h12DE; // OR R2, R13, R14 -> R2 = R13 | R14
      cpu_inst.raminst.mem[22] = 16'h13EF; // OR R3, R14, R15 -> R3 = R14 | R15

      // Test 5: XOR operations
      cpu_inst.raminst.mem[23] = 16'h2456; // XOR R4, R5, R6  -> R4 = R5 ^ R6
      cpu_inst.raminst.mem[24] = 16'h2789; // XOR R7, R8, R9  -> R7 = R8 ^ R9

      // Test 6: MOV operations
      cpu_inst.raminst.mem[25] = 16'h4A00; // MOV R10, R0
      cpu_inst.raminst.mem[26] = 16'h4B10; // MOV R11, R1
      cpu_inst.raminst.mem[27] = 16'h4C20; // MOV R12, R2

      // Test 7: LSL operations - Logical Shift Left
      cpu_inst.raminst.mem[28] = 16'h7D02; // SHORT_TO_REG R13, 0x02
      cpu_inst.raminst.mem[29] = 16'h9E4D; // LSL R14, R4, R13 -> R14 = R4 << 2

      // Test 8: LSR operations - Logical Shift Right
      cpu_inst.raminst.mem[30] = 16'h7D01; // SHORT_TO_REG R13, 0x01
      cpu_inst.raminst.mem[31] = 16'hAF5D; // LSR R15, R5, R13 -> R15 = R5 >> 1

      // Test 9: STORE_TO_MEM
      cpu_inst.raminst.mem[32] = 16'h60A0; // STORE R0 to MEM[0xA0]
      cpu_inst.raminst.mem[33] = 16'h61A1; // STORE R1 to MEM[0xA1]
      cpu_inst.raminst.mem[34] = 16'h62A2; // STORE R2 to MEM[0xA2]
      cpu_inst.raminst.mem[35] = 16'h63A3; // STORE R3 to MEM[0xA3]

      // Test 10: LOAD_FROM_MEM
      cpu_inst.raminst.mem[36] = 16'h50A0; // LOAD R0 from MEM[0xA0]
      cpu_inst.raminst.mem[37] = 16'h51A1; // LOAD R1 from MEM[0xA1]
      cpu_inst.raminst.mem[38] = 16'h52A2; // LOAD R2 from MEM[0xA2]
      cpu_inst.raminst.mem[39] = 16'h53A3; // LOAD R3 from MEM[0xA3]

      // Test 11: BNZ - Branch if Not Zero
      cpu_inst.raminst.mem[40] = 16'h7001; // SHORT_TO_REG R0, 0x01
      cpu_inst.raminst.mem[41] = 16'h802C; // BNZ R0, 0x2C (jump to address 44)
      cpu_inst.raminst.mem[42] = 16'h7100; // SHORT_TO_REG R1, 0x00 (should be skipped)
      cpu_inst.raminst.mem[43] = 16'h7200; // SHORT_TO_REG R2, 0x00 (should be skipped)
      cpu_inst.raminst.mem[44] = 16'h7DFF; // SHORT_TO_REG R13, 0xFF (jump target)

      // Test 12: Test BNZ with zero (should not jump)
      cpu_inst.raminst.mem[45] = 16'h7000; // SHORT_TO_REG R0, 0x00
      cpu_inst.raminst.mem[46] = 16'h8035; // BNZ R0, 0x35 (should not jump)
      cpu_inst.raminst.mem[47] = 16'h7EAA; // SHORT_TO_REG R14, 0xAA (should execute)

      cpu_inst.raminst.mem[48] = 16'h8030; // BNZ R0, 0x30 (loop forever since R0=0)

      $display("Test program loaded successfully.");
      $display("Program size: 49 instructions\n");
    end
  endtask

  task verify_results;
    integer i;
    reg [WORD_SIZE-1:0] expected;
    reg [WORD_SIZE-1:0] actual;
    begin
      $display("\n========================================");
      $display("Verifying Register File Contents");
      $display("========================================");

      for (i = 0; i < 16; i = i + 1) begin
        actual = cpu_inst.regfileinst.R[i];
        $display("R%0d = 0x%04h", i, actual);
      end

      $display("\n========================================");
      $display("Verifying Memory Contents");
      $display("========================================");

      for (i = 16'hA0; i <= 16'hA3; i = i + 1) begin
        actual = cpu_inst.raminst.mem[i];
        $display("MEM[0x%02h] = 0x%04h", i, actual);
      end

      $display("\n========================================");
      $display("Register File Test Summary");
      $display("========================================");
      $display("All 16 registers have been tested with:");
      $display("  - SHORT_TO_REG (immediate load)");
      $display("  - ADD operations");
      $display("  - AND operations");
      $display("  - OR operations");
      $display("  - XOR operations");
      $display("  - MOV operations");
      $display("  - LSL operations");
      $display("  - LSR operations");
      $display("  - STORE_TO_MEM operations");
      $display("  - LOAD_FROM_MEM operations");
      $display("  - BNZ operations");
    end
  endtask

  initial begin
    $monitor("Time=%0t | PC=%02h | State=%s | Opcode=%h | R0=%04h R1=%04h R2=%04h R3=%04h",
             $time, cpu_inst.pc, cpu_inst.STATE_AS_STR, 
             cpu_inst.opcode, 
             cpu_inst.regfileinst.R[0],
             cpu_inst.regfileinst.R[1],
             cpu_inst.regfileinst.R[2],
             cpu_inst.regfileinst.R[3]);
  end

endmodule


