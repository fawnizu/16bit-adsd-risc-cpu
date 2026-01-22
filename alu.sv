// Verilog code for ALU
module ALU(       
  input          [3:0]      aluop,     //function sel through opcode
  input          [15:0]     operand1,         //src1
  input          [15:0]     operand2,         //src2
  input 		 	[3:0]			imm4,    	//4-bit immediate unsigned value
  output bit   [15:0]     	out, 	 		//result
  output zero,	//zero flag=1 when output is zero
  output neg,   //negative flag=1 when output is negative
  output ovf);  //overflow flag=1 when add/sub output overflows
  
  wire [15:0] imm4_to16;
  assign imm4_to16 = {{12{1'b0}}, imm4}; //sign extend unsigned value
  
  always_comb 
    begin   
      case(aluop)
		//R-type instructions
        4'b0000: out = operand1 + operand2; // add
        4'b0001: out = operand1 - operand2; // sub
        4'b0010: out = operand1 | operand2; // or
        4'b0011: out = operand1 & operand2; // and
        
        //S-type instructions
        4'b0100: out = operand1 <<< imm4;	//arithmetic Shl by imm4 bits
        4'b0101: out = operand1 >>> imm4;	//arithmetic Shr by imm4 bits
        4'b0110: out = {operand1[14:0], operand1[15]};	//Rol
        4'b0111: out = {operand1[0], operand1[15:1]};	//Ror  
        4'b1000: out = ~operand1;			//bitwise not  
        
        //B-type instructions
        // perform subtraction only. out is ignored. update flags below
        4'b1001: out = operand1 - operand2;	//beq
        4'b1010: out = operand1 - operand2;	//blt
        4'b1011: out = operand1 - operand2;	//bgt
          
        //L-type instructions
        // Calculate operand1 + imm4, to be used as the destination address 
        // for load and store
        4'b1100: out = operand1 + imm4_to16;
        4'b1101: out = operand1 + imm4_to16;
        
        default: out = operand1 + operand2;  // default to add. out will be ignored
      endcase  
		
    end  
  assign zero = (out == 16'd0) ? 1'b1 : 1'b0; //zero flag
  assign neg = (out[15] == 1'b1) ? 1'b1 : 1'b0; //negative flag
  assign ovf = (aluop == 4'b0000 && ((operand1[15] && operand2[15] && !out[15]) || (!operand1[15] && !operand2[15] && out[15]))) 
				 || (aluop == 4'b0001 && ((!operand1[15] && operand2[15] && out[15]) || (operand1[15] && !operand2[15] && !out[15])));
endmodule  