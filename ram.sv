// data memory
module RAM  
  (  
	  input 					clk,  
    input 					CS, 	 //chip select (enable=1)
    input 					RW_,   //read(1) write(0) signal
    input     [15:0]        addr,  
    input     [15:0]        data_in,  
    output reg [15:0]       data_out  
  );
  
  integer i;  
  reg  [7:0] ram [0:15]; 			//1K nos of 8-bit memory reg
  wire [9:0] ram_addr; 				//10-bit internal address for 1K memory
  assign ram_addr = addr[9:0];  	//mapping global 16-bit addr to internal 10-bit address
  
  // initialize memory, good for simulation only. We're not using this for FPGA implementation
  // For FPGA implementation, we don't really need to do a memory reset.
/*  initial begin  
    for(i=0; i<1023; i=i+1)
      ram[i] <= 0;
  end
*/
  
  // Write mode
  always @(posedge clk)
  begin
	 if (CS && !RW_ && (ram_addr <= 15)) begin
      ram[ram_addr] <= data_in[15:8];     	//write MSB to lower address
      ram[ram_addr+1] <= data_in[7:0];  			//write LSB to higher address
      // following big-endian storage with least significant byte at highest address
    end
  end

	// Read transaction	 
	always @(*) begin
	  if (CS && RW_ && (ram_addr <= 15)) 
	    data_out = {ram[ram_addr], ram[ram_addr+1]};
	  else
	    data_out = 16'bz;
	end  
  
endmodule
