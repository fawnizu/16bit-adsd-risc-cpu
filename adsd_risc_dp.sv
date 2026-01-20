// In this file, we just include all the subfiles

//`include "ram.sv"
//`include "rom.sv"
//`include "register.sv"
//`include "alu.sv"
//`include "pipo.sv"

//Datapath for one cycle computer
module adsd_risc_dp (input clk, 
							rst, 
							pc_ld, 
                     ctrl_branch,
                     ctrl_jump,
                     ctrl_i_mem_oe, 
                     ctrl_rf_rd_sel,
                     ctrl_rf_write_en,
                     ctrl_alu_in2_sel,
                     ctrl_d_mem_rw_,
                     ctrl_d_mem_cs,
                     ctrl_wdata_sel,
                     input [3:0] ctrl_aluop,
							output [3:0] opcode,
                     output ctrl_zero,
                     output ctrl_neg,
                     output ctrl_ovf,
							output [7:0] LEDport);

  wire [15:0] pc, i_mem_addr, alu_in2, alu_out;
  wire [15:0] ir, rf_data_in, rf_rs_data_out, rf_rt_data_out; //rf
  wire [15:0] d_mem_addr, d_mem_data_out;	//d-mem
  wire [3:0] rf_rs, rf_rt, rf_rd, imm4;
  wire [15:0] pc_next, pc_plus1;//, pc_plus1_plus_imm4_to16;
  wire [15:0] mux_branch_to_mux_jump;
  wire [11:0] imm12;
  wire [15:0] imm12_to16;
  //wire [15:0] imm4_to16;
  
  shortint imm4_to16, pc_plus1_plus_imm4_to16;
        
  assign opcode = ir[15:12];
  assign rf_rs = ir[11:8];
  assign rf_rt = ir[7:4];

  //assign rf_rd = (rd_sel)? ir[3:0] : ir[7:4]; //need to do assignment with mux

  assign imm4 = ir[3:0];
  assign imm12 = ir[11:0];
  assign imm4_to16  = {{12{imm4[3]}}, imm4}; 	//sign_ext(imm4)
  assign imm12_to16 = {{4{imm12[11]}}, imm12}; 	//sign_ext(imm12)
  assign i_mem_addr = pc;
  assign d_mem_addr = alu_out;

  //Two possible valuesof next PC
  assign pc_plus1 = pc + 16'b1;			//pc+1 since IMEM is 16-bit wide, if branch not taken

  //Two's complement addition to allow branching to lower address
  assign pc_plus1_plus_imm4_to16 = pc_plus1 + imm4_to16; //if branch is taken

  
  PIPO PC (.dout(pc), 
           .din(pc_next), 
           .ld(pc_ld), 
           .clk(clk),
           .rst(rst));
			  
  ROM IMEM (.addr(i_mem_addr), 
            .OE(ctrl_i_mem_oe), 
            .data_out(ir));
				
  mux21_4b mux_rf_rd (.dout(rf_rd), 
							 .in0(ir[7:4]), 
							 .in1(ir[3:0]), 
							 .sel(ctrl_rf_rd_sel));
  
  REGISTER RF (.clk(clk),
               .rst(rst), 
               .write_en(ctrl_rf_write_en), 
               .rd(rf_rd), 
               .data_in(rf_data_in), 
               .rs(rf_rs),
               .rs_data_out(rf_rs_data_out),
               .rt(rf_rt),
               .rt_data_out(rf_rt_data_out),
					.r15(LEDport));
  
  mux21_16b mux_alu_in2 (.dout(alu_in2), 
								 .in0(rf_rt_data_out), 
								 .in1(imm4_to16), 
								 .sel(ctrl_alu_in2_sel));
  
  ALU ALU1 (.ctrl_aluop(ctrl_aluop),
				.rs(rf_rs_data_out),
            .rt(alu_in2),
            .imm4(imm4),
            .rd(alu_out),
            .zero(ctrl_zero),
 			   .neg(ctrl_neg),
            .ovf(ctrl_ovf));
  
  RAM DMEM (.clk(clk),
				.CS(ctrl_d_mem_cs),
            .RW_(ctrl_d_mem_rw_),
            .addr(d_mem_addr),
            .data_in(rf_rt_data_out),
            .data_out(d_mem_data_out));
  
  mux21_16b mux_rf_data_in (.dout(rf_data_in), 
									 .in0(d_mem_data_out), 
									 .in1(alu_out), 
									 .sel(ctrl_wdata_sel));
  
  mux21_16b mux_branch (.dout(mux_branch_to_mux_jump), 
                        .in0(pc_plus1), 
                        .in1(pc_plus1_plus_imm4_to16), 
                        .sel(ctrl_branch));
  
  mux21_16b mux_jump (.dout(pc_next), 
                      .in0(mux_branch_to_mux_jump), 
                      .in1(imm12_to16), 
                      .sel(ctrl_jump));
  
endmodule