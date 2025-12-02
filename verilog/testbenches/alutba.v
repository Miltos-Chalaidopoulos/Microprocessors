module MCPU_Alutba();
  parameter CMD_SIZE = 2;
  parameter WORD_SIZE = 2;
  localparam CMD_AND = 2'b00;
  localparam CMD_OR  = 2'b01;
  localparam CMD_XOR = 2'b10;
  localparam CMD_ADD = 2'b11;
  reg  [CMD_SIZE-1:0] opcode;
  reg  [WORD_SIZE-1:0] r1;
  reg  [WORD_SIZE-1:0] r2;
  wire [WORD_SIZE-1:0] out;
  wire OVERFLOW;
  reg  [WORD_SIZE-1:0] expected_out;
  reg  expected_CF;
  reg  isCorrect;
  reg  [CMD_SIZE-1:0] opcode_delayed;
  reg  [WORD_SIZE-1:0] r1_delayed;
  reg  [WORD_SIZE-1:0] r2_delayed;
  
  MCPU_Alu #(.CMD_SIZE(CMD_SIZE), .WORD_SIZE(WORD_SIZE))
  aluinst (opcode, r1, r2, out, OVERFLOW);
  genvar i;
  generate
    for (i = 0; i < WORD_SIZE; i = i + 1) begin : rand_bits
      always #4 r1[i] = $random;
      always #4 r2[i] = $random;
    end
  endgenerate
  generate
    for (i = 0; i < CMD_SIZE; i = i + 1) begin : rand_op
      always #4 opcode[i] = $random;
    end
  endgenerate
  
  always @(opcode, r1, r2) begin
    opcode_delayed = opcode;
    r1_delayed = r1;
    r2_delayed = r2;
  end
  
  always @(opcode_delayed, r1_delayed, r2_delayed) begin
    #3;
    case (opcode_delayed)
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
        isCorrect = (out == expected_out) && (OVERFLOW == expected_CF);
    else
        isCorrect = (out == expected_out);
  end
  
  // debug
  initial begin
    $monitor("%0t | opcode=%b r1=%b r2=%b | out=%b CF=%b | expected=%b eCF=%b | iscorrect=%b",
              $time, opcode, r1, r2, out, OVERFLOW, expected_out, expected_CF, isCorrect);
  end
endmodule

