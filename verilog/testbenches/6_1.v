module MCPUtb6_1a();

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
parameter [3:0] R0 = 0;
parameter [3:0] R1 = 1;
parameter [3:0] R2 = 2;
parameter [3:0] R3 = 3;
parameter [3:0] R4 = 4;
parameter [3:0] R5 = 5;

initial
begin
    for(i=0;i<256;i=i+1)
    begin
      cpuinst.raminst.mem[i]=0;
    end
    for(i=0;i<16;i=i+1)
    begin
      cpuinst.regfileinst.R[i] = 0;
    end
   
    // 5384 = 0x1508 = 0001 0101 0000 1000
    cpuinst.regfileinst.R[0] = 16'b0000000000010101; // MSB 0x0015 = 21
    cpuinst.regfileinst.R[1] = 16'b0000000000001000; // LSB 0x0008 = 8
    
    i=0;
    cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R4, 8'b00001000};   
    i=i+1;
    
    cpuinst.raminst.mem[i]={cpuinst.OP_LSL, R2, R0, R4};   
    i=i+1;

    cpuinst.raminst.mem[i]={cpuinst.OP_OR, R3, R2, R1}; 
    i=i+1;
    
    cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R5, 8'b00000010};   
    i=i+1;
    
    // R3 = R3 << 2
    cpuinst.raminst.mem[i]={cpuinst.OP_LSL, R3, R3, R5};   
    i=i+1;
    
    // R3 = R3 >> 2
    cpuinst.raminst.mem[i]={cpuinst.OP_LSR, R3, R3, R5};   
    i=i+1;
    cpuinst.raminst.mem[i]=0;
    
end

endmodule

