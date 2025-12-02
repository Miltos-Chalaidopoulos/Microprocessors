module d1s5384tb();
reg tb_a;
reg tb_b;
reg tb_c;
reg d_correct;

wire tb_d;
wire [2:0] tb_dut_inputs;

d1s5384 dut(tb_a, tb_b, tb_c, tb_d);

assign tb_dut_inputs = {tb_a, tb_b, tb_c};

initial begin
    {tb_a, tb_b, tb_c} = 3'b000;
    forever #5 {tb_a, tb_b, tb_c} = {tb_a, tb_b, tb_c} + 1;
end

always #1 begin
    d_correct = (tb_d == (tb_a & tb_b & ~tb_c)) ? 1'b1 : 1'b0;
end

endmodule


