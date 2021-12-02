module MUX3to1(
	input [31:0] in1,
	input [31:0] in2,
	input [31:0] in3,
	input [1:0] sel,
	output logic [31:0] result
	);

    always@(*) begin
    case (sel)
        2'b00:
            result = in1;
        2'b01:
            result = in2;
        2'b10:
            result = in3;
    endcase
end
endmodule


module add_imm(
    input [31:0] data,
    input [31:0] imm,
    output logic [31:0] result
);
always@(*) begin
    result = data + imm;
end

endmodule

module MUX2to1(
    input [31:0] data1,
    input [31:0] data2,
    input sel,
    output logic [31:0] result
);
always@(*) begin
    case (sel)
        1'b0:
            result = data1;
        1'b1:
            result = data2;
    endcase
end

endmodule


module MUX_signal(
    input [11:0] in,
    input sel,
    output logic [11:0] result
);
always_comb begin
    case (sel)
        1'b0:
            result = in;
        1'b1:
            result = 12'b0;
    endcase
end
endmodule

