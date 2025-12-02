module MCPU_Alutb();
  parameter CMD_SIZE = 2;
  parameter WORD_SIZE = 8;
  parameter CMD_AND = 2'b00;
  parameter CMD_OR  = 2'b01;
  parameter CMD_XOR = 2'b10;
  parameter CMD_ADD = 2'b11;
  
  reg [CMD_SIZE-1:0] opcode;
  reg [WORD_SIZE-1:0] r1;
  reg [WORD_SIZE-1:0] r2;
  wire [WORD_SIZE-1:0] out;
  wire OVERFLOW;
  reg iscorrect;
  reg [WORD_SIZE-1:0] expected_out;
  reg expected_CF;
  reg [CMD_SIZE-1:0] opcode_delayed;
  reg [WORD_SIZE-1:0] r1_delayed;
  reg [WORD_SIZE-1:0] r2_delayed;
  
  MCPU_Alu #(.CMD_SIZE(CMD_SIZE), .WORD_SIZE(WORD_SIZE)) 
  aluinst ( .cmd(opcode), .in1(r1), .in2(r2), .out(out), .CF(OVERFLOW));
  
  initial begin
    r1 = 5;
    r2 = 5;
    opcode = CMD_AND;
  end
  
  always begin
    #4 r1 = 5; 
    #4 r1 = 3; 
    #4 r1 = 8; 
    #4 r1 = 4;
  end
  
  always begin
    #4 r2 = 5; 
    #4 r2 = 3; 
    #4 r2 = 8; 
    #4 r2 = 4;
  end
  
  integer k;
  initial begin
    k = 0;
    forever begin
      #4 opcode = k % 4;
      k = k + 1;
    end
  end
  
  always @(opcode, r1, r2) begin
    opcode_delayed = opcode;
    r1_delayed = r1;
    r2_delayed = r2;
  end
  
  always @(opcode_delayed, r1_delayed, r2_delayed) begin
    #3; 
    case(opcode_delayed)
      CMD_AND: begin
        expected_out = r1_delayed & r2_delayed;
        expected_CF  = 0;
      end
      CMD_OR: begin
        expected_out = r1_delayed | r2_delayed;
        expected_CF  = 0;
      end
      CMD_XOR: begin
        expected_out = r1_delayed ^ r2_delayed;
        expected_CF  = 0;
      end
      CMD_ADD: begin
        {expected_CF, expected_out} = r1_delayed + r2_delayed;
      end
      default: begin
        expected_out = {WORD_SIZE{1'bx}};
        expected_CF  = 1'bx;
      end
    endcase
    
    if (opcode_delayed == CMD_ADD)
        iscorrect = (out == expected_out) && (OVERFLOW == expected_CF);
    else
        iscorrect = (out == expected_out);
  end
  
  //debug
  initial begin
    $monitor("%0t | opcode=%b r1=%h r2=%h | out=%h OVERFLOW=%b | expected=%h eCF=%b | iscorrect=%b",
             $time, opcode, r1, r2, out, OVERFLOW, expected_out, expected_CF, iscorrect);
  end
endmodule

