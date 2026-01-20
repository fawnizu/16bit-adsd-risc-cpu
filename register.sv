// register file
module REGISTER 
  (  
    input                    clk, rst,  
    // write port  
    input                    write_en,  
    input          [3:0]     rd,  
    input          [15:0]    data_in,  
    //read port 1  
    input          [3:0]     rs,  
    output         [15:0]    rs_data_out,  
    //read port 2  
    input          [3:0]     rt,  
    output         [15:0]    rt_data_out,
	 //output port for r15
	 output 			 [7:0]	  r15
  );  
  
  reg     [15:0]     reg_array [15:0];  

  always @(posedge clk) begin  
    if(!rst) begin  
      reg_array[0] <= 16'd0;  
      reg_array[1] <= 16'd0;  
      reg_array[2] <= 16'd0;  
      reg_array[3] <= 16'd0;  
      reg_array[4] <= 16'd0;  
      reg_array[5] <= 16'd0;  
      reg_array[6] <= 16'd0;  
      reg_array[7] <= 16'd0;       
      reg_array[8] <= 16'd0;  
      reg_array[9] <= 16'd0;  
      reg_array[10] <= 16'd0;  
      reg_array[11] <= 16'd0;  
      reg_array[12] <= 16'd0;  
      reg_array[13] <= 16'd0;  
      reg_array[14] <= 16'd0;  
      reg_array[15] <= 16'd0;   
    end  
    
/*  always @(posedge clk) begin  
    if(rst) begin  
      reg_array[0] <= 16'd0;  
      reg_array[1] <= 16'd1;  
      reg_array[2] <= 16'd2;  
      reg_array[3] <= 16'd3;  
      reg_array[4] <= 16'd4;  
      reg_array[5] <= 16'd5;  
      reg_array[6] <= 16'd6;  
      reg_array[7] <= 16'd7;       
      reg_array[8] <= 16'd8;  
      reg_array[9] <= 16'd9;  
      reg_array[10] <= 16'd10;  
      reg_array[11] <= 16'd11;  
      reg_array[12] <= 16'd12;  
      reg_array[13] <= 16'd13;  
      reg_array[14] <= 16'd14;  
      reg_array[15] <= 16'd15;   
    end      
*/    
    else begin  
      if(write_en) begin  
        if (rd) //skip if rd=0 since it's a special read-only register
          reg_array[rd] <= data_in;  
        else
          reg_array[rd] <= 16'd0;
      end  
    end  
    
  end  
  
  assign rs_data_out = reg_array[rs];  
  assign rt_data_out = reg_array[rt];  
  assign r15 = reg_array[15][7:0];
endmodule   
