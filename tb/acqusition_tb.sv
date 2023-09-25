module acqusition_tb ();
  bit clk = 0;
  bit clk_div_2 = 0;
  bit rst;
  integer fd;
  integer err;
  integer code;
  integer isEOF;
  bit [320:0] str;

  logic [15:0] data_i;
  logic [15:0] data_i_inv = 0;
  logic [15:0] data_q;
  logic [15:0] data_q_inv = 0;
  logic [31:0] SAT;

  always # 5 clk = ~clk;
  always # 10 clk_div_2 = ~clk_div_2;
  initial begin
    rst = 1;
    fd  = $fopen("./data/sim100.bin", "rb");
    err = $ferror(fd, str);  
    $display("File1 descriptor is: %h.", fd );//non-0
    $display("Error1 number is: %h.", err );  //0
    $display("Error2 info is: %s.", str );    //0
    #3
    rst = 0;
    // # 500
    // $fclose(fd) ;
  end

  // always @(posedge clk) begin
  //   clk_div_2 = ~clk_div_2;
  // end
  assign data_i[7:0] = data_i_inv[15:8];
  assign data_i[15:8] = data_i_inv[7:0];
  assign data_q[7:0] = data_q_inv[15:8];
  assign data_q[15:8] = data_q_inv[7:0];
  
  always @(posedge clk) begin
    if (clk_div_2 == 0) begin
      code = $fread(data_i_inv, fd);
    end else begin
      code = $fread(data_q_inv, fd);
    end
    isEOF = $feof(fd);
    if (isEOF == 1) begin
      $display("It is end of file");
    end else begin
      //$display("$fread read i-channel data %h", data_i) ;
      //$display("$fread read q-channel data %h", data_q) ;
    end
    
  end

  acquisition uut(
    .clk(clk),
    .reset(rst),
    .i_in(data_i),
    .q_in(data_q),
    .detectedSAT(SAT),
    .enable(1'b1)
    //.dopplerSAT(),
    //.phaseSAT()
  );

endmodule