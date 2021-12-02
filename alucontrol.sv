module ALUCtrol(input mem_r,
                   input [2:0] funct3,
                   input [2:0] alu_op,
                   input [6:0] funct7,
                   output logic[4:0] ALUCtrl);

//alu_op: R 000  S 010 U 100
//        I 001  B 011 J 101
/*
`define no_op  5'd0;
`define add    5'd1;
`define sub    5'd2;
`define and_op 5'd3;
`define or_op  5'd4;
`define xor_op 5'd5;
`define sll    5'd6; //rd = rs1 shift left logic 
`define slt    5'd7; //rd set 1 if less than (signed)
`define sltu   5'd8; //rd set 1 if less than (unsigned)
`define srl    5'd9; //rd = rs1 shift right logic
`define sra   5'd10; //rd = rs1 shift right (signed)
`define beq    5'd11;
`define bne    5'd12;
`define blt    5'd13;
`define bge    5'd14;
`define bltu   5'd15;
`define bgeu   5'd16;

*/

always_comb begin
    case( {alu_op,funct3})
    6'b000000:begin
      if(funct7[5] == 0) begin
            ALUCtrl = 5'd1; 
        end else begin
            ALUCtrl = 5'd2;
      end
    end
    6'b000111: begin
        ALUCtrl = 5'd3;
    end
    6'b000110: begin
        ALUCtrl = 5'd4; 
    end
    6'b000100: begin
        ALUCtrl = 5'd5; 
    end
    6'b000001: begin
        ALUCtrl = 5'd6;
    end
    6'b000010: begin
        ALUCtrl = 5'd7; 
    end
    6'b000011: begin
        ALUCtrl = 5'd8;
    end
    6'b000101: begin
         if(funct7[5] == 0) begin
            ALUCtrl = 5'd9; 
        end else begin
            ALUCtrl = 5'd10; 
        end
    end
    6'b001000: begin
        ALUCtrl = 5'd1;
    end

    6'b001010: begin
      ALUCtrl = 5'd7;
    end
    6'b001011: begin
        ALUCtrl = 5'd8; 
    end
    6'b001100: begin
        ALUCtrl = 5'd5; 
    end
    6'b001110: begin
        ALUCtrl = 5'd4;
    end
    6'b001111: begin
        ALUCtrl = 5'd3;
    end
    6'b001001: begin
        ALUCtrl = 5'd6;
    end
    6'b001101: begin
        if(funct7[5] == 0) begin
            ALUCtrl = 5'd9; 
        end else begin
            ALUCtrl = 5'd10; 
        end
    end
    
    {6'b010010},
    {6'b010000},
    {6'b010001},
    {6'b010101},
    {6'b010100}: begin
        ALUCtrl = 5'd1; // lw&sw 
    end

    6'b011000: begin
        ALUCtrl = 5'd11; 
    end
    6'b011001: begin
        ALUCtrl = 5'd12; 
    end
    6'b011100: begin
        ALUCtrl = 5'd13;
    end
    6'b011101: begin
        ALUCtrl = 5'd14;
    end
    6'b011110: begin
        ALUCtrl = 5'd15; 
    end
    6'b011111: begin
        ALUCtrl = 5'd16; 
    end
    6'b100000: begin  //    JALR
        ALUCtrl = 5'd17;
    end
    default: begin
        ALUCtrl = 5'd0; // No operation
    end
    endcase
end


endmodule