//Parallel in and parallel out register 
//with load
module PIPO (output reg 	[15:0] 	dout, 
             input 			[15:0] 	din, 
             input 					ld, clk, rst);
  
  always @(posedge clk)
    if (!rst)
      dout <= 16'd20;
    else if (ld) 
      dout <= din;

endmodule


// 16-bit 2-to-1 multiplexer
module mux21_16b(output [15:0] dout, 
             input [15:0] in0, in1, 
             input sel);

  assign dout = (sel) ? in1 : in0;
endmodule

// 4-bit 2-to-1 multiplexer
module mux21_4b(output [3:0] dout, 
                input [3:0] in0, in1, 
                input sel);

  assign dout = (sel) ? in1 : in0;
endmodule