module regfile(
	input clk,
	input rst,
	input [4:0] rs1num,
	input [4:0] rs2num,
	input [4:0] rd_num,
	input reg_w,
	input [31:0] rd_data,
	output logic [31:0] rs1_data,
	output logic [31:0] rs2_data
	
	);

reg [31:0] register [0:31];

always@(*) begin
		if(rst)
			for(integer i=0;i<32;i++)
				register[i]<=32'b0;
    	else begin
        	if(reg_w & rd_num!=0)
           	   register[rd_num]<=rd_data;
		end
		
end

assign rs1_data = register[rs1num];
assign rs2_data = register[rs2num];


endmodule
