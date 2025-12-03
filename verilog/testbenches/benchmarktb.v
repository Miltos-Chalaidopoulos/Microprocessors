module benchmarktb;

  parameter WORD_SIZE = 16;
  parameter ADDR_WIDTH = 8;
  parameter RAM_SIZE = 1 << ADDR_WIDTH;

  reg clk;
  reg reset;

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

  initial begin
    $display("Starting MCPU Benchmark Program");
    $display("Running test program...");
    
    reset = 1;
    #20;
    reset = 0;
    #20;
    load_test_program();
    #5000;
    $stop;
  end

  task load_test_program;
    begin
      // Test 1: SHORT_TO_REG - Initialize all registers
      cpu_inst.raminst.mem[0]  = 16'h7001; // R0 = 0x01
      cpu_inst.raminst.mem[1]  = 16'h7112; // R1 = 0x12
      cpu_inst.raminst.mem[2]  = 16'h7223; // R2 = 0x23
      cpu_inst.raminst.mem[3]  = 16'h7334; // R3 = 0x34
      cpu_inst.raminst.mem[4]  = 16'h7445; // R4 = 0x45
      cpu_inst.raminst.mem[5]  = 16'h7556; // R5 = 0x56
      cpu_inst.raminst.mem[6]  = 16'h7667; // R6 = 0x67
      cpu_inst.raminst.mem[7]  = 16'h7778; // R7 = 0x78
      cpu_inst.raminst.mem[8]  = 16'h7889; // R8 = 0x89
      cpu_inst.raminst.mem[9]  = 16'h799A; // R9 = 0x9A
      cpu_inst.raminst.mem[10] = 16'h7AAB; // R10 = 0xAB
      cpu_inst.raminst.mem[11] = 16'h7BBC; // R11 = 0xBC
      cpu_inst.raminst.mem[12] = 16'h7CCD; // R12 = 0xCD
      cpu_inst.raminst.mem[13] = 16'h7DDE; // R13 = 0xDE
      cpu_inst.raminst.mem[14] = 16'h7EEF; // R14 = 0xEF
      cpu_inst.raminst.mem[15] = 16'h7FFF; // R15 = 0xFF

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
      
      $display("Test program loaded into memory.");
    end
  endtask

endmodule

