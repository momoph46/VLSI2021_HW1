module IFID_reg(input clk,
                input rst,
                input IFID_regw,
                input [31:0] pc_in,
                input [31:0] instr,
                output logic [31:0] pc_out,
                output logic [31:0] instr_out);
always_ff@(posedge clk , posedge rst)begin
    if(rst)begin
        pc_out<=32'd0;
        instr_out<=32'd0;

    end
    else begin
        if(IFID_regw==1'b1)begin
          pc_out<=pc_in;
          instr_out<=instr;
        end
    end
end

endmodule




module IDEX_reg(
    input clk,
    input rst,
    input [31:0] pc,

    input [1:0] branch,
    input [2:0] alu_op,
    
    input alu_src,
    input pcsrc,
    input rdsrc,
    input mem_r,
    input mem_w,
    input mem2reg,
    input reg_w,
     
    input [31:0] rs1,
    input [31:0] rs2,
    input [31:0] immediate,
    input [2:0] funct3,
    input [6:0] funct7,
    input [4:0] rs1_num,
    input [4:0] rs2_num,
    input [4:0] rd_num,

    output logic [1:0] branch_out,
    output logic [2:0] aluop_out,
    
    output logic alusrc_out,
    output logic pcsrc_out,
    output logic rdsrc_out,
    output logic memr_out,
    output logic memw_out,
    output logic mem2reg_out,
    output logic regw_out,
    

    
    //output logic [6:0] opcode_out, 
    
    output logic [31:0] rs1_out,
    output logic [31:0] rs2_out,
    output logic [31:0] pc_out,
    output logic [31:0] immediate_out,
    output logic [2:0] funct3_out,
    output logic [6:0] funct7_out,
    output logic [4:0] rs1num_out,
    output logic [4:0] rs2num_out,
    output logic [4:0] rdnum_out
);

    always_ff@(posedge clk , posedge rst) begin
        if(rst) begin 
            mem2reg_out<=1'b0;
            regw_out<=1'b0;
            rdsrc_out<=1'b0;
            memr_out<=1'b0;
            memw_out<=1'b0;
            pcsrc_out<=1'b0;
            alusrc_out<=1'b0;

            branch_out<=2'd0;
            aluop_out<=3'd0;
            //opcode_out<=7'd0;

            pc_out<=32'd0;
            rs1_out<=32'd0;
            rs2_out<=32'd0;
            immediate_out<=32'd0;

            funct3_out<=3'd0;
            funct7_out<=7'd0;
            rdnum_out<=5'd0;
            rs1num_out<=5'd0;
            rs2num_out<=5'd0;
        end

        else begin
            mem2reg_out<=mem2reg;
            regw_out<=reg_w;
            rdsrc_out<= rdsrc;
            memr_out<=mem_r;
            memw_out<=mem_w;
            pcsrc_out<= pcsrc;
            alusrc_out<=alu_src;
            
            branch_out<=branch;
            aluop_out<=alu_op;
            //opcode_out<=opcode;

            pc_out<=pc;
            rs1_out<=rs1;
            rs2_out<=rs2;
            immediate_out<=immediate;
            
            funct3_out<=funct3;
            funct7_out<=funct7;
            rdnum_out<=rd_num;
            rs1num_out<=rs1_num;
            rs2num_out<=rs2_num;
           
        end
    end
endmodule


module EXMEM_reg(
    input clk,
    input rst,

    input rdsrc,
    input mem_r,
    input mem_w,
    
    input mem2reg,
    input reg_w,
    
    
    input [31:0] pc2reg,
    input [31:0] aluresult,
    input [31:0] rs2_data,
    input [4:0] rd_num,
    input [2:0] funct3,
    
    
    output logic memr_out,
    output logic memw_out,
    output logic mem2reg_out,
    output logic regw_out,
    output logic rdsrc_out,

    output logic [4:0] rdnum_out,
    output logic [2:0] funct3_out,
    output logic [31:0] pc2reg_out,
    output logic [31:0] aluresult_out,
    output logic [31:0] rs2data_out
    //output logic [4:0] rs2num_out
   
);
    always_ff@(posedge clk , posedge rst)begin
        if(rst)begin
            mem2reg_out<=1'b0;
            regw_out<=1'b0;
            rdsrc_out<=1'b0;
            memr_out<=1'b0;
            memw_out<=1'b0;
            funct3_out<=3'd0;
            pc2reg_out<=32'd0;
            aluresult_out<=32'd0;
            rs2data_out<=32'd0;
        
            rdnum_out<=5'd0;
        end
        else begin
            mem2reg_out<=mem2reg;
            regw_out<=reg_w;
            rdsrc_out<=rdsrc;
            memr_out<=mem_r;
            memw_out<=mem_w;
            funct3_out<=funct3;
            pc2reg_out<=pc2reg;
            aluresult_out<=aluresult;
            rs2data_out<=rs2_data;
            
            rdnum_out<=rd_num;
        end
    end
endmodule


module MEMWB_reg(
    input clk,
    input rst,
    input mem2reg,
    input reg_w,
    input [31:0] rd_data,
    input [31:0] DM_data,
    input [4:0] rd_num,
    output logic mem2reg_out,
    output logic regw_out,
    output logic [31:0] rd_data_out,
    output logic [31:0] DMdata_out,
    output logic [4:0] rdnum_out
);
    always_ff@(posedge clk , posedge rst) begin
        if(rst)begin
            mem2reg_out<=1'b0;
            regw_out<=1'b0;
            rd_data_out<=32'd0;
            DMdata_out<=32'd0;
            rdnum_out<=5'd0;
        end
        else begin
            mem2reg_out<= mem2reg;
            regw_out<=reg_w;
            rd_data_out<=rd_data;
            DMdata_out<=DM_data;
            rdnum_out<=rd_num;
        end
    end
endmodule

