// This is for lab4 exercise.
module  adsd_risc_ctrl (input rst, 
                        input [3:0] opcode,
                        output reg pc_ld, 
                        ctrl_branch,
                        ctrl_jump,
                        ctrl_i_mem_oe, 
                        ctrl_rf_rd_sel,
                        ctrl_rf_write_en,
                        ctrl_alu_in2_sel,
                        ctrl_d_mem_rw_,
                        ctrl_d_mem_cs,
                        ctrl_wdata_sel,
                        output reg [3:0] ctrl_aluop,
                        input zero, neg, ovf);

  always @(*)
    begin
      if (!rst) begin
        pc_ld = 1'b0;
        ctrl_i_mem_oe = 1'b0;
        ctrl_rf_rd_sel = 1'b1;
        ctrl_rf_write_en = 1'b0;
        ctrl_alu_in2_sel = 1'b0;
        ctrl_d_mem_rw_ = 1'b0;
        ctrl_d_mem_cs = 1'b0;
        ctrl_wdata_sel = 1'b1;
        ctrl_aluop = 4'b0000;
		  ctrl_branch = 1'b0;
        ctrl_jump = 1'b0;
      end

      else begin
        // Reset everything every single instruction
          pc_ld = 1'b0;
          ctrl_i_mem_oe = 1'b0;
          ctrl_rf_rd_sel = 1'b1;
          ctrl_rf_write_en = 1'b0;
          ctrl_alu_in2_sel = 1'b0;
          ctrl_d_mem_rw_ = 1'b0;
          ctrl_d_mem_cs = 1'b0;
          ctrl_wdata_sel = 1'b1;
			 ctrl_aluop = 4'b0000;
          ctrl_branch = 1'b0;
          ctrl_jump = 1'b0;        
        
        
        case (opcode)
          //===============================R-type Arithmetic Instructions====================================
          4'b0000: begin //Add
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b1;
            ctrl_rf_write_en = 1'b1;
            ctrl_alu_in2_sel = 1'b0;
            ctrl_wdata_sel = 1'b1;
            ctrl_aluop = 4'b0000;
          end

          4'b0001: begin //Sub
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b1;
            ctrl_rf_write_en = 1'b1;
            ctrl_alu_in2_sel = 1'b0;
            ctrl_wdata_sel = 1'b1;
            ctrl_aluop = 4'b0001;
          end

          4'b0010: begin //Or
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b1;
            ctrl_rf_write_en = 1'b1;
            ctrl_alu_in2_sel = 1'b0;
            ctrl_wdata_sel = 1'b1;
            ctrl_aluop = 4'b0010;
          end

          4'b0011: begin //And
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b1;
            ctrl_rf_write_en = 1'b1;
            ctrl_alu_in2_sel = 1'b0;
            ctrl_wdata_sel = 1'b1;
            ctrl_aluop = 4'b0011;
          end

          //===============================S-type Shift Instructions====================================
          4'b0100: begin //Shl
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b0;
            ctrl_rf_write_en = 1'b1;
            ctrl_alu_in2_sel = 1'b1;
            ctrl_wdata_sel = 1'b1;
            ctrl_aluop = 4'b0100;
          end
          
          4'b0101: begin //Shr
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b0;
            ctrl_rf_write_en = 1'b1;
            ctrl_alu_in2_sel = 1'b1;
            ctrl_wdata_sel = 1'b1;
            ctrl_aluop = 4'b0101;
          end
          
          4'b0110: begin //Rol
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b0;
            ctrl_rf_write_en = 1'b1;
            ctrl_alu_in2_sel = 1'b1;
            ctrl_wdata_sel = 1'b1;
            ctrl_aluop = 4'b0110;
          end
          
          4'b0111: begin //Ror
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b0;
            ctrl_rf_write_en = 1'b1;
            ctrl_alu_in2_sel = 1'b1;
            ctrl_wdata_sel = 1'b1;
            ctrl_aluop = 4'b0111;
          end
          
          4'b1000: begin //Not
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b0;
            ctrl_rf_write_en = 1'b1;
            ctrl_wdata_sel = 1'b1;
            ctrl_aluop = 4'b1000;
          end
          
          4'b1111: begin //Addi     -----------new instruction----------------
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b0;
            ctrl_rf_write_en = 1'b1;
            ctrl_alu_in2_sel = 1'b1;
            ctrl_wdata_sel = 1'b1;
            ctrl_aluop = 4'b0000;
          end          
          
          //===============================B-type Conditional Branch Instructions====================================          
        
          4'b1001: begin //Beq
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_alu_in2_sel = 1'b0;
            ctrl_aluop = 4'b0001; // subtract rs - rt
            if (zero)
              ctrl_branch = 1'b1;    // branch if the result is zero, i.e. rs==rt
          end
          
          4'b1010: begin //Blt
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_alu_in2_sel = 1'b0;
            ctrl_aluop = 4'b0001; // subtract rs - rt
            if (neg)
              ctrl_branch = 1'b1;    // branch if the result is negative, i.e. rs < rt
          end
          
          4'b1011: begin //Bgt
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_alu_in2_sel = 1'b0;
            ctrl_aluop = 4'b0001; // subtract rs - rt
            if (!zero && !neg)
              ctrl_branch = 1'b1;    // branch if the result is not zero and not neg, i.e. rs > rt
          end
          
          
           //===============================L-type Loand/Store Instructions====================================                    
          
          4'b1100: begin //Ld
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'b0;   //select rt
            ctrl_rf_write_en = 1'b1;
            ctrl_alu_in2_sel = 1'b1; // add rs + imm4
            ctrl_d_mem_rw_ = 1'b1;   // read mode
            ctrl_d_mem_cs = 1'b1;
            ctrl_wdata_sel = 1'b0;   //take data from DMEM
            ctrl_aluop = 4'b0000; 
          end
          
          4'b1101: begin //St
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_rf_rd_sel = 1'bx;   // not used
            ctrl_rf_write_en = 1'b0; // write mode
            ctrl_alu_in2_sel = 1'b1; // add rs + imm4
            ctrl_d_mem_rw_ = 1'b0;   // read mode
            ctrl_d_mem_cs = 1'b1;
            ctrl_wdata_sel = 1'bx;   //not used
            ctrl_aluop = 4'b0000;
          end
          
           //===============================J-type Jump Instruction====================================          
        
          4'b1110: begin //Jmp
            pc_ld = 1'b1;
            ctrl_i_mem_oe = 1'b1;
            ctrl_alu_in2_sel = 1'b0;
            ctrl_jump = 1'b1;    
          end
          
        endcase

      end
    end      
endmodule