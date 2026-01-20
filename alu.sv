// Verilog code for ALU
module ALU(       
  input          [3:0]      ctrl_aluop,     //function sel through opcode
  input          [15:0]     rs,         //src1
  input          [15:0]     rt,         //src2
  input 		 [3:0]		imm4,    	//4-bit immediate unsigned value
  output bit   [15:0]     rd, 	 	//result
  output zero,	//zero flag=1 when output is zero
  output neg,   //negative flag=1 when output is negative
  output ovf);  //overflow flag=1 when add/sub output overflows
  
  wire [15:0] imm4_to16;
  assign imm4_to16 = {{12{1'b0}}, imm4}; //sign extend unsigned value
  
  always_comb 
    begin   
      case(ctrl_aluop)
		//R-type instructions
        4'b0000: rd = rs + rt; // add
        4'b0001: rd = rs - rt; // sub
        4'b0010: rd = rs | rt; // or
        4'b0011: rd = rs & rt; // and
        
        //S-type instructions
        4'b0100: rd = rs <<< imm4;	//arithmetic Shl by imm4 bits
        4'b0101: rd = rs >>> imm4;	//arithmetic Shr by imm4 bits
        4'b0110: rd = {rs[14:0], rs[15]};	//Rol
        4'b0111: rd = {rs[0], rs[15:1]};	//Ror  
        4'b1000: rd = ~rs;			//bitwise not  
        
        //B-type instructions
        // perform subtraction only. rd is ignored. update flags below
        4'b1001: rd = rs - rt;	//beq
        4'b1010: rd = rs - rt;	//blt
        4'b1011: rd = rs - rt;	//bgt
          
        //L-type instructions
        // Calculate rs + imm4, to be used as the destination address 
        // for load and store
        4'b1100: rd = rs + imm4_to16;
        4'b1101: rd = rs + imm4_to16;
        
        default: rd = rs + rt;  // default to add. rd will be ignored
      endcase  
		
    end  
  assign zero = (rd == 16'd0) ? 1'b1 : 1'b0; //zero flag
  assign neg = (rd[15] == 1'b1) ? 1'b1 : 1'b0; //negative flag
  assign ovf = (ctrl_aluop == 4'b0000 && ((rs[15] && rt[15] && !rd[15]) || (!rs[15] && !rt[15] && rd[15]))) 
				 || (ctrl_aluop == 4'b0001 && ((!rs[15] && rt[15] && rd[15]) || (rs[15] && !rt[15] && !rd[15])));
endmodule  