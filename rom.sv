// instruction memory
// Initialized to some assembly programs using the 16-bit ADSD RISC ISA.
module ROM
  (  
    input   [15:0]   addr,
    input 			   OE,
    output  [15:0]  	data_out
  );  
  wire [8:0] rom_addr = addr[8:0];  //double-byte address mapping
  reg [15:0] rom[0:50]; //1K byte in 512 double byte form
  
  initial 
    begin
	 	// PROGRAM 1 --left and right shift continuously
      rom[0]  = 16'b1111_0000_0101_0001;  // addi r0, r5 , 0001  //r5=1, for decrementing r1
      rom[1]  = 16'b1000_0000_1110_xxxx;  // not r14, r0 , xxxx  //r14=0xffff, for LED display 
      rom[2]  = 16'b1111_0000_0010_0111;  // addi r0, r2 , 0111  //r2=111, for LED display 
      rom[3]  = 16'b1111_0000_0001_0111;  // addi r0, r1 , 0111  //r1=7, count=7
      rom[4]  = 16'b0011_1110_0010_1111;  // and r14, r2 , r15   //r15=r2 write to LED port using AND
      rom[5]  = 16'b0000_0000_0000_0000;  // sw 	// 
      rom[6]  = 16'b1001_0000_0001_0100;  // beq r0, r1 , 4      //if (r1==0), goto 2      
      rom[7]  = 16'b0001_0001_0101_0001;  // sub r1, r5, r1      //r1--
      rom[8]  = 16'b0100_0010_0010_0001;  // shl r2, r2, 1       //r2<<1
      rom[9]  = 16'b1110_0000_0000_0100;  // jmp 4    			  //goto 2
      rom[10] = 16'b0000_0000_0000_0000;  // unused
      rom[11] = 16'b1111_0000_0011_0110;  // addi r0, r3, 0110   //r3=6, count = 7
      rom[12] = 16'b0010_0000_0010_1111;  // or r0, r2, r15      //write to LED port using OR
      rom[13] = 16'b1011_0001_0011_0011;  // bgt r1, r3, 3
      rom[14] = 16'b0000_0001_0101_0001;  // add r1, r5, r1      //r1++
      rom[15] = 16'b0101_0010_0010_0001;  // shr r2, r2, 1       //r2>>1
      rom[16] = 16'b1110_0000_0000_1100;  // jmp 12
      rom[17] = 16'b1110_0000_0000_0011;  // jmp 3
      rom[18] = 16'b0000_0000_0000_0000;  // unused
 
		// PROGRAM 2 --left shift only
      rom[20] = 16'b1111_0000_0101_0001;  // addi r0, r5 , 0001 //r5=1, to be used for decrementing r1
      rom[21] = 16'b1111_0000_0010_0111;  // addi r0, r2 , 0111 //r2=0000111 for LED display pattern
      rom[22] = 16'b1111_0000_0001_0111;  // addi r0, r1 , 0111 //r1=7
      rom[23] = 16'b0000_0000_0010_1111;  // add r0, r2 , r15   //r15=r2 write to LED port
      rom[24] = 16'b1001_0000_0001_1100;  // beq r0, r1 , -4    //if (r1==0), goto 2      
      rom[25] = 16'b0001_0001_0101_0001;  // sub r1, r5, r1     //r1=r1-1
      rom[26] = 16'b0100_0010_0010_0001;  // shl r2, r2, 1      //r2<<1
      rom[27] = 16'b1110_0000_0001_0111;  // jmp 23    //if (r1==0), goto 23
      rom[28] = 16'b0000_0000_0000_0000;  // unused
      rom[29] = 16'b0000_0000_0000_0000;  

		// PROGRAM 3 ---R type test
      rom[30] = 16'b1111_0000_0001_0001;  // addi r0, r1 , 0001 //1
      rom[31] = 16'b1111_0000_0010_0011;  // addi r0, r2 , 0011 //3
      rom[32] = 16'b1111_0000_0011_0111;  // addi r0, r3 , 0111 //7
      rom[33] = 16'b1111_0000_0100_1111;  // addi r0, r4 , 1111 //15
      rom[34] = 16'b0100_0100_0101_0100;  // shl r4, r5, 4      //r5=1111 0000
      rom[35] = 16'b0101_0101_0110_0010;  // shr r5, r6, 2      //r6=0011 1100
      rom[36] = 16'b0011_0010_0100_0001;  // and r2, r4, r1     //r1=0000 1100 
      rom[37] = 16'b1111_0000_0101_0011;  // addi r0, r5, 3     //r5=0000 0011
      rom[38] = 16'b1011_0101_0001_0001;  // bgt r6, r2, 1      //pc=0
      rom[39] = 16'b1001_0001_0010_1010;  // beq r1, r2, -6     //pc=4
      rom[40] = 16'b1110_0000_0001_1110;  // jmp 30				 //pc=4 
      rom[41] = 16'b0000_0000_0000_0000;
      rom[42] = 16'b0000_0000_0000_0000;
    end    
  
  assign data_out   = rom[rom_addr];
  
endmodule   




