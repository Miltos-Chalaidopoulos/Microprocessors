module MCPUtb();

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
    for(i=0;i<256;i=i+1)
    begin
      cpuinst.raminst.mem[i]=0;
    end
 
    for(i=0;i<16;i=i+1)
    begin
      cpuinst.regfileinst.R[i]=0;
    end
    
    
    i=0;   cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R3, 8'd2};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R2, 8'd9};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R4, 8'd1};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LSL, R4, R4, R3};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R4, 8'd1};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R5, 8'd8};   // R5 = 8  shift
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LSL, R4, R4, R5};          // R4 = 1 << 8 = 256
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R2, R2, R4};          // R2 = 9 + 256 = 265
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LSL, R1, R2, R3};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R1, 8'd100};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R3, 8'd3};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LSR, R6, R2, R3};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R6, 8'd101};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R7, 8'd53};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R8, 8'd84};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R7, 8'd102};  // mem[102] = 53
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R8, 8'd103};  // mem[103] = 84
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LOAD_FROM_MEM, R9, 8'd102};   // R9 = 53
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LOAD_FROM_MEM, R10, 8'd103};  // R10 = 84
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R15, 8'd2};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LSL, R11, R9, R15};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LSR, R12, R10, R15};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R11, 8'd104};  // mem[104] = 212
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R12, 8'd105};  // mem[105] = 21
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R13, 8'd8};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LSL, R14, R9, R13};    // R14 = 53 << 8 = 13568
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R14, R14, R10};   // R14 = 13568 + 84 = 13652
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R14, 8'd106};  // mem[106] = 13652
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R0, 8'd1};
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_BNZ, R0, 8'd31};  // Loop forever

end

endmodule

