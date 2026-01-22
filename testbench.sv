//Testbench
module testbench;

  reg clk;
  reg reset;  
  wire [7:0] LEDport;

  adsd_risc_top dut (.rst(reset), .clk(clk), .LEDport(LEDport));

  initial begin  
    clk = 1;  
    forever #5 clk = ~clk;  
  end  

  initial begin  
    $monitor ($time, " : pc=%2d, opcode=%b, r15=%b\t, LEDport=%b\t", 
              dut.dp.pc,
              dut.dp.opcode,
              dut.dp.RF.reg_array[15],
              dut.LEDport);  
    
    // Initialize Inputs
    reset = 0;  
    // Wait for global reset to finish   

    #38 reset = 1;

    #1300;
    $finish;
  end  

endmodule