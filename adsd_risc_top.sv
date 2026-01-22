// In Quartus, there is no need to "include" subfiles
// All files in the project are already "included", so can comment 
// the lines below which was needed in edaplayground

//`include "adsd_risc_dp.sv"
//`include "adsd_risc_ctrl.sv"

module adsd_risc_top (input rst, clk, output [7:0] LEDport);
  wire [3:0] ctrl_opcode, opcode;
  wire pc_ld; 
  wire ctrl_branch; 
  wire ctrl_jump;
  wire ctrl_i_mem_oe;
  wire ctrl_rf_rd_sel;
  wire ctrl_rf_write_en;
  wire ctrl_alu_in2_sel;
  wire ctrl_d_mem_rw_;
  wire ctrl_d_mem_cs; 
  wire ctrl_wdata_sel; 
  wire [3:0] ctrl_aluop;
  wire zero, neg, ovf;
  wire clk_slow;
  
  //clk_divider clkdiv(clk, clk_slow);

  //adsd_risc_dp dp (.clk(clk_slow), .rst(rst),  //for FPGA, we use ~4 Hz clock so we can see the LED shifting
  adsd_risc_dp dp (.clk(clk), .rst(rst),     //for simulation, we use the normal clock
                   .pc_ld					(pc_ld), 
                   .ctrl_branch			(ctrl_branch),
                   .ctrl_jump				(ctrl_jump),
                   .ctrl_i_mem_oe		(ctrl_i_mem_oe), 
                   .ctrl_rf_rd_sel		(ctrl_rf_rd_sel),
                   .ctrl_rf_write_en	(ctrl_rf_write_en),
                   .ctrl_alu_in2_sel	(ctrl_alu_in2_sel),
                   .ctrl_d_mem_rw_		(ctrl_d_mem_rw_),
                   .ctrl_d_mem_cs		(ctrl_d_mem_cs),
                   .ctrl_wdata_sel		(ctrl_wdata_sel),
                   .ctrl_aluop			(ctrl_aluop),
						 .opcode					(opcode),
                   .ctrl_zero				(zero),
                   .ctrl_neg				(neg),
                   .ctrl_ovf				(ovf),
						 .LEDport				(LEDport));
  
  adsd_risc_ctrl ctrl (.rst					(rst),
                       .opcode 				(opcode),
                       .pc_ld 				(pc_ld), 
                       .ctrl_branch 		(ctrl_branch),
                       .ctrl_jump			(ctrl_jump),
                       .ctrl_i_mem_oe		(ctrl_i_mem_oe), 
                       .ctrl_rf_rd_sel		(ctrl_rf_rd_sel),
                       .ctrl_rf_write_en	(ctrl_rf_write_en),
                       .ctrl_alu_in2_sel	(ctrl_alu_in2_sel),
                       .ctrl_d_mem_rw_		(ctrl_d_mem_rw_),
                       .ctrl_d_mem_cs		(ctrl_d_mem_cs),
                       .ctrl_wdata_sel		(ctrl_wdata_sel),
                       .ctrl_aluop			(ctrl_aluop),
                       .zero					(zero),
                       .neg					(neg),
							  .ovf					(ovf));
endmodule
