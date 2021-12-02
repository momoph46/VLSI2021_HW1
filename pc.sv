module program_counter(
    input clk,
    input rst,
    input [31:0] pc_in, 
    input pc_write, 
    output logic [31:0]pc_out
);


always @(posedge clk) begin
    if(rst)begin 
        pc_out<=32'b0;
    end
    else if (pc_write) begin 
        pc_out <= pc_in;
    end
end

endmodule