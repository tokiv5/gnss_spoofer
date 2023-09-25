`timescale 1ps/1ps
module transmitter_write ();
  bit clk = 0;
  bit clk_div_2 = 0;
  bit rst;
  bit START = 0;
  bit ENDING;
  bit [3:0] address;
  bit [31:0] incr, prn_phase; 
  bit [15:0] signal_sca_i, signal_sca_q;
  integer fd;
  integer err;
  integer code;
  integer cnt = 0;
  bit [320:0] str;

  // bit [15:0] test_write = 16'habcd;
  // bit [15:0] test_read_1 = 16'h0000;
  // bit [15:0] test_read_2 = 16'h0000;
  // bit [15:0] test_read_3 = 16'h0000;
  // bit [15:0] test_read_4 = 16'h0000;

  always # 24437 clk = ~clk;
  always # 48874 clk_div_2 = ~clk_div_2;
  initial begin
    rst = 1;
    fd  = $fopen("./data/generation.bin", "wb");
    err = $ferror(fd, str);  
    $display("File1 descriptor is: %h.", fd );//non-0
    $display("Error1 number is: %h.", err );  //0
    $display("Error2 info is: %s.", str );    //0
    // $fwrite(fd, "%u", test_write);
    
    // $fclose(fd);

    // fd  = $fopen("./data/generation.bin", "rb");
    // if (!$feof(fd)) begin
    //   //$fscanf(fd, "%d", test_read_1);
    //   $fread(test_read_1, fd);
    // end else begin
    //   $display("It is end of file");
    // end
    // if (!$feof(fd)) begin
    //   $fscanf(fd, "%d", test_read_2);
    // end else begin
    //   $display("It is end of file");
    // end
    // if (!$feof(fd)) begin
    //   $fscanf(fd, "%d", test_read_3);
    // end else begin
    //   $display("It is end of file");
    // end
    // if (!$feof(fd)) begin
    //   $fread(test_read_4, fd);
    // end else begin
    //   $display("It is end of file");
    // end
    // $fclose(fd);
    // $display("%h", test_read_1);
    // $display("%h", test_read_2);
    // $display("%h", test_read_3);
    // $display("%h", test_read_4);
    #100
    rst = 0;
    #500
    START = 1;
    // # 500
    // $fclose(fd) ;
  end

  always @(posedge clk) begin
    if (cnt == 20460) begin
      $fclose(fd);
    end else begin
      cnt = cnt + 1;    
      if (fd != 0) begin
        if (clk_div_2 == 0) begin
          //$display("i: %x", signal_sca_i);
          $fwrite(fd, "%c%c", signal_sca_i[7:0], signal_sca_i[15:8]);
        end else begin
          //$display("q: %x", signal_sca_q);
          $fwrite(fd, "%c%c", signal_sca_q[7:0], signal_sca_q[15:8]);
        end
      end

    end

  end

  transmitter uut(
    .clk(clk),
    .reset(rst),
    .START(START),
    .ENDING(ENDING),
    .address(address),
    .incr(incr),
    .prn_phase(prn_phase),
    .signal_sca_i(signal_sca_i),
    .signal_sca_q(signal_sca_q)
  );

  fake_memory ram(
    .clk(clk),
    .reset(rst),
    .address(address),
    .qa(incr),
    .qb(prn_phase)
  );
  
endmodule