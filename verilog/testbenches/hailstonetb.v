module MCPUtb_hailstone();
reg reset, clk;
MCPU cpuinst (clk, reset);

initial begin
  reset=1;
  #10  reset=0;
end

always begin
  #5 clk=0; 
  #5 clk=1; 
end

integer file, i;
reg[cpuinst.WORD_SIZE-1:0] memi;

parameter  [cpuinst.OPERAND_SIZE-1:0]  R0  = 4'd0;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R1  = 4'd1;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R2  = 4'd2;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R3  = 4'd3;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R4  = 4'd4;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R5  = 4'd5;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R6  = 4'd6;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R7  = 4'd7;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R8  = 4'd8;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R9  = 4'd9;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R10 = 4'd10;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R11 = 4'd11;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R12 = 4'd12;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R13 = 4'd13;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R14 = 4'd14;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R15 = 4'd15;

initial
begin
    for(i=0;i<256;i=i+1) cpuinst.raminst.mem[i]=0;
    for(i=0;i<16;i=i+1) cpuinst.regfileinst.R[i]=0;

    i=0;
    cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R1, 8'd21};             // R1 = 21
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R2, 8'd8};       // R2 = 8
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LSL, R1, R1, R2};              // R1 = 5376
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R2, 8'd8};       // R2 = 8
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R1, R1, R2};              // R1 = 5384
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R1, 8'd100};     // mem[100] = 5384
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R3, 8'd1};       // R3 = 1
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R4, 8'd1};       // R4 = 1
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R5, 8'd101};     // R5 = 101
    
    // LOOP_START: address 9
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_XOR, R6, R1, R3};              // R6 = R1 XOR 1
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_BNZ, R6, 8'd12};               // if R6 != 0, continue
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_BNZ, R3, 8'd30};               // Jump to END
    
    // CHECK_ODD: address 12
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_AND, R7, R1, R3};              // R7 = R1 & 1
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_BNZ, R7, 8'd19};               // NEW: jump to ODD_CASE (21-2=19)
    
    // EVEN_CASE: address 14
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LSR, R1, R1, R4};              // R1 = R1 >> 1
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R1, R5, 4'b0000}; // mem[R5] = n
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R5, R5, R3};              // R5++
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R0, 8'd1};       // R0 = 1
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_BNZ, R0, 8'd9};                // Jump back to LOOP_START
    
    // ODD_CASE: address 19
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R8, R1, R1};              // R8 = 2n
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R8, R8, R1};              // R8 = 3n
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R1, R8, R3};              // R1 = 3n + 1
    
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R1, R5, 4'b0000}; // mem[R5] = n
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R5, R5, R3};              // R5++
    
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R0, 8'd1};       // R0 = 1
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_BNZ, R0, 8'd9};                // Jump back to LOOP_START
    
    // END: address 30
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R1, 8'd200};     // Final value
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R0, 8'd0};       // R0 = 0
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_BNZ, R0, 8'd31};               // infinite loop to address 31
end

endmodule
