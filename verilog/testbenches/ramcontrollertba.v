module ramcontrollertba;

  parameter WORD_SIZE = 16;
  parameter ADDR_WIDTH = 8;
  parameter RAM_SIZE = 1 << ADDR_WIDTH;
  reg we, re;
  reg [WORD_SIZE-1:0] datawr;
  reg [ADDR_WIDTH-1:0] addr;
  reg [ADDR_WIDTH-1:0] instraddr;
  wire [WORD_SIZE-1:0] datard;
  wire [WORD_SIZE-1:0] instrrd;

  MCPU_RAMController #(
      .WORD_SIZE(WORD_SIZE),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) ram_inst (
      .we(we),
      .datawr(datawr),
      .re(re),
      .addr(addr),
      .datard(datard),
      .instraddr(instraddr),
      .instrrd(instrrd)
  );

  reg [WORD_SIZE-1:0] mem_local [0:RAM_SIZE-1];

  integer i;

  initial begin
    we = 0; re = 0; datawr = 0; addr = 0; instraddr = 0;
    for(i=0; i<RAM_SIZE; i=i+1)
      mem_local[i] = 0;  
    $display("Starting memory write test...");
    for(i=0; i<RAM_SIZE; i=i+1) begin
      we = 1;
      addr = i;
      datawr = $random;
      mem_local[i] = datawr;
      #5;
      $display("Write addr=%0h data=%0h", addr, datawr);
    end
    we = 0;   
    $display("Starting data read test...");
    re = 1;
    for(i=0; i<RAM_SIZE; i=i+1) begin
      addr = i;
      #5;
      if(datard !== mem_local[i])
        $display("ERROR: datard mismatch at addr=%0h, got=%0h expected=%0h", addr, datard, mem_local[i]);
      else
        $display("Read addr=%0h data=%0h OK", addr, datard);
    end
    re = 0;  
    $display("Starting instruction read test...");
    for(i=0; i<RAM_SIZE; i=i+1) begin
      instraddr = i;
      #5;
      if(instrrd !== mem_local[i])
        $display("ERROR: instrrd mismatch at addr=%0h, got=%0h expected=%0h", instraddr, instrrd, mem_local[i]);
      else
        $display("Instr read addr=%0h data=%0h OK", instraddr, instrrd);
    end

    $display("All tests completed.");
    $stop;
  end

endmodule

