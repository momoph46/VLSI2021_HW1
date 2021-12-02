`include "cpu.sv"
`include "SRAM_wrapper.sv"

module top(input clk,
	       input rst
	      );
logic MEM_Memread, MEM_Memwrite;
logic [3:0] wen;
logic [13:0] IMaddr,DMaddr;
logic [31:0] IMinstr,DMdata,datatoDM;
cpu CPU(clk,rst,
		IMinstr,
		DMdata,
	
		MEM_Memread,MEM_Memwrite,
		wen, datatoDM,
		IMaddr,DMaddr
		);


//SRAM_wrapper IM1(~clk,1'b1,1'b1,4'b1111,pc_out[15:2],32'd0,IMinstr);
SRAM_wrapper IM1(~clk,1'b1,1'b1,4'b1111,IMaddr,32'd0,IMinstr);

//SRAM_wrapper DM1(~clk,MEM_Memread|MEM_Memwrite,MEM_Memread,wen,MEM_alu_out[15:2],datatoDM,DMdata); 
SRAM_wrapper DM1(~clk,MEM_Memread|MEM_Memwrite,MEM_Memread,wen,DMaddr,datatoDM,DMdata); 

endmodule