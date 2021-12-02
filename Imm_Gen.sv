module Imm_Gen (
    input [31:0] imm_in,
    output logic [31:0] imm_out
);

always_comb begin
    
    if(imm_in[6:0]!=7'b0110011)begin
        case(imm_in[6:0])
            {7'b0000011},
            {7'b0010011},
            {7'b1100111}:begin //I
                imm_out={{20{imm_in[31]}},imm_in[31:20]};
            end
            {7'b0100011}:begin //S
                imm_out={{20{imm_in[31]}},imm_in[31:25],imm_in[11:7]};
            end
            {7'b1100011}:begin //B
                imm_out={{19{imm_in[31]}},imm_in[31],imm_in[7],imm_in[30:25],imm_in[11:8],1'b0};
            end
            {7'b0010111},
            {7'b0110111}:begin //U
                imm_out={imm_in[31:12],12'b0};
            end
            {7'b1101111}:begin //J
                imm_out={{12{imm_in[31]}},imm_in[19:12],imm_in[20],imm_in[30:21],1'b0};
            end
	        default: imm_out = {{20{imm_in[31]}},imm_in[31:20]};
        endcase	
        

    end

    else imm_out = {{20{imm_in[31]}},imm_in[31:20]};
    
end 

endmodule