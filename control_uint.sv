module control_unit(input [6:0] opcode,
                    output logic [2:0] ALUop,
                    output logic [1:0] Branch,
                    output logic ALUSrc,
                    output logic RDSrc,
                    output logic PCtoRegSrc,
                    output logic RegWrite,
                    output logic MemRead,
                    output logic MemWrite,
                    output logic MemtoReg);


always@(*)begin
	case(opcode)
		7'b0110011:begin//Rtype			
		ALUop= 3'b000;
		Branch= 2'b00;
		ALUSrc= 0;
		RDSrc= 1;
		PCtoRegSrc= 0;
		RegWrite= 1;
		MemRead= 0;
		MemWrite= 0;
		MemtoReg= 0;
			
		end
		7'b0000011:begin//lw
            ALUop=3'b010;
            Branch=2'b00;
            ALUSrc=1;
            RDSrc=1;
            PCtoRegSrc=0;
            RegWrite=1;
            MemRead=1;
            MemWrite=0;
            MemtoReg=1;
		end
		7'b0010011:begin//I-TYPE
            ALUop=3'b001;
            Branch=2'b00;
            ALUSrc=1;
            RDSrc=1;
            PCtoRegSrc=0;
            RegWrite=1;
            MemRead=0;
            MemWrite=0;
            MemtoReg=0;
		end
		7'b1100111:begin//I-TYPE JALR
		ALUop= 3'b100;	
            Branch= 2'b10;
            ALUSrc= 1;
            RDSrc= 0;
            PCtoRegSrc= 1;
            RegWrite= 1;
            MemRead= 0;
            MemWrite= 0;
            MemtoReg= 0;
		end
		7'b0100011:begin//S-TYPE
            ALUop=3'b010;
            Branch=2'b00;   
            ALUSrc=1;
            RDSrc=1;
            PCtoRegSrc=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=1;
            MemtoReg=0;
		end
		7'b1100011:begin//B-TYPE
            ALUop= 3'b011;
            Branch= 2'b01;
            
            ALUSrc=0;
            RDSrc=1;
            PCtoRegSrc=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=0;
            MemtoReg=0;
		end
		7'b0010111:begin//U-TYPE AUIPC
		ALUop=3'b111;
                        Branch=2'b00;
                        
                        ALUSrc=1;
                        RDSrc=0;
                        PCtoRegSrc=0;
                        RegWrite=1;
                        MemRead=0;
                        MemWrite=0;
                        MemtoReg=0;
		end
		7'b0110111:begin//U-TYPE LUI
			ALUop=3'b111;
                  Branch=2'b00;
                  
                  ALUSrc=1;
                  RDSrc=1;
                  PCtoRegSrc=0;
                  RegWrite=1;
                  MemRead=0;
                  MemWrite=0;
                  MemtoReg=0;
		end
		7'b1101111:begin//J-TYPE
			ALUop = 3'b110;
                  Branch = 2'b11;

                  ALUSrc = 1;
                  RDSrc = 0;
                  PCtoRegSrc = 1;
                  RegWrite = 1;
                  MemRead = 0;
                  MemWrite = 0;
                  MemtoReg = 0;
		end
		default:begin
                  ALUop=3'b000;
                  Branch=2'b00;
                  
                  ALUSrc=0;
                  RDSrc=0;
                  PCtoRegSrc=0;
                  RegWrite=0;
                  MemRead=0;
                  MemWrite=0;
                  MemtoReg=0;
		end
	endcase
end
endmodule	
