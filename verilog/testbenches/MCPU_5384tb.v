module MCPUtb5384();
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

integer i;
reg[cpuinst.WORD_SIZE-1:0] memi;

parameter  [cpuinst.OPERAND_SIZE-1:0]  R0  = 4'd0;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R1  = 4'd1;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R2  = 4'd2;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R3  = 4'd3;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R4  = 4'd4;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R5  = 4'd5;

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

    i=0;   cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R0, 8'd53};        // R0 = 53
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R1, 8'd84};        // R1 = 84
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R0, 8'd100};       // MEM[100] = 53
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R1, 8'd101};       // MEM[101] = 84
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LOAD_FROM_MEM, R2, 8'd100};      // R2 = MEM[100] = 53
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_LOAD_FROM_MEM, R3, 8'd101};      // R3 = MEM[101] = 84
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R4, R2, R3};                // R4 = R2 + R3 = 53 + 84 = 137
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_XOR, R5, R2, R3};                // R5 = R2 ^ R3 = 53 XOR 84 = 101
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R4, 8'd102};       // MEM[102] = ADD result (137)
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R5, 8'd103};       // MEM[103] = XOR result (101)
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R0, 8'd0};         // R0 = 0
    i=i+1; cpuinst.raminst.mem[i]={cpuinst.OP_BNZ, R0, 8'd11};                 // Loop forever (since R0=0, no jump)
    
end
endmodule

