//`include "SRAM_wrapper.sv"
`include "mux.sv"
`include "control_uint.sv"
`include "stageregister.sv"
`include "access_memory.sv"
`include "pc.sv"
`include "Imm_Gen.sv"
`include "forward_ctrl.sv"
`include "regfile.sv"
`include "hazard_ctrl.sv"
`include "alu.sv"
`include "alucontrol.sv"
`include "branch_ctrl.sv"


/*
module top(input clk,
            input rst);
*/    
module cpu(input clk,
           input rst,
           input [31:0] IMinstr,
           input [31:0] DMdata,
           output MEM_Memread,
           output MEM_Memwrite,
           output logic [3:0] wen,
           output logic [31:0] datatoDM,
           output logic [13:0] IMaddr,
           output logic [13:0] DMaddr
           );
  
    logic [31:0] pc_in,pc_out,pc_add_4,EX_pcaddimm;
    //logic [31:0] IMinstr;
    logic flush,signalflush,IFIDwrite,PCwrite;
    logic [1:0] branchsel;
    logic [31:0] EX_aluout,EX_pc,EX_imm;

  
    add_imm pcaddfour(pc_out,32'd4,pc_add_4);
   
    MUX3to1 muxpc(EX_aluout,EX_pcaddimm,pc_add_4,branchsel,pc_in);	


    
    program_counter pc(clk,rst,pc_in,PCwrite,pc_out);
    //SRAM_wrapper IM1(~clk,1'b1,1'b1,4'b1111,pc_out[15:2],32'd0,IMinstr);
    assign IMaddr = pc_out[15:2];
	
    logic [31:0] instr;
    MUX2to1 flushmux(IMinstr,32'd0,flush,instr);    
    logic [1:0] Branch;
    logic zeroflag;



    logic [31:0] ID_insresult,ID_instr;
    logic [31:0] ID_pc;
    logic[4:0] IDrd,IDrs1,IDrs2;
    logic[2:0] funct3;
    logic[6:0] funct7;
    logic[31:0] imm;
    logic[31:0] rs1data,rs2data;
    
    IFID_reg IFIDstage(clk,rst,
                IFIDwrite,
                pc_out,
                instr,
                
                ID_pc,
                ID_instr);
    
    
    MUX2to1 flushIDmux(ID_instr,32'd0,flush,ID_insresult);   
    assign IDrd=ID_insresult[11:7];
    assign funct3=ID_insresult[14:12];
    assign IDrs1=ID_insresult[19:15];
    assign IDrs2=ID_insresult[24:20];
    assign funct7=ID_insresult[31:25];

    
    Imm_Gen immediate_gen(ID_insresult,imm);

    logic [2:0] Aluop;
    logic Alusrc,Memread,Memwrite,Memtoreg,Regwrite,PCtoregsrc,RDsrc;
    
    control_unit CtrlUnit(ID_insresult[6:0],
                          Aluop,
                          Branch,
                         
                          Alusrc,
                          RDsrc,
                          PCtoregsrc,
                          Regwrite,
                          Memread,
                          Memwrite,
                          Memtoreg);

    logic WB_Regwrite;
    logic [4:0] WB_rdnum;
    logic [31:0] WB_wb_data;

    regfile rf(clk,rst,IDrs1,IDrs2,WB_rdnum,WB_Regwrite,WB_wb_data,rs1data,rs2data);

    logic [11:0] signalout;
    MUX_signal muxsignal({Branch,Aluop,Alusrc,PCtoregsrc,RDsrc,
                        Memread,Memwrite,Memtoreg,Regwrite},
                        signalflush,signalout);

                        
    logic [31:0] EX_rs1_data,EX_rs2_data;
    logic [2:0] EX_funct3;
    logic [6:0] EX_funct7;
    logic [1:0] EX_Branch;
    logic [4:0] EXrs1,EXrs2,EXrd;
    logic [2:0] EX_Aluop;
    logic EX_Alusrc,EX_Memread,EX_Memwrite,EX_Memtoreg,EX_Regwrite,EX_PCtoregsrc,EX_RDsrc;
    //logic [31:0] EX_forward_rs2_data;
    


    IDEX_reg IDEXstage(clk,rst,
        ID_pc,
		signalout[11:10],
        signalout[9:7],
        signalout[6],
        signalout[5],
        signalout[4],
        signalout[3],
        signalout[2],
        signalout[1],
        signalout[0],

        rs1data,rs2data,imm,
        funct3,funct7,
        IDrs1,IDrs2,IDrd,
        EX_Branch,
        EX_Aluop,
        
		EX_Alusrc,
        EX_PCtoregsrc,
        EX_RDsrc,
        EX_Memread,
        EX_Memwrite,
        EX_Memtoreg,
        EX_Regwrite,
        
        EX_rs1_data,EX_rs2_data,EX_pc,
        EX_imm,EX_funct3,EX_funct7,
        EXrs1,EXrs2,EXrd);


    Branch_ctrl BranchControl(EX_Branch,zeroflag,branchsel);
    logic [4:0] aluctrl;
    ALUCtrol ALUControl(EX_Memread,EX_funct3,EX_Aluop,EX_funct7,aluctrl);
    
    logic [1:0] forwardrs1src,forwardrs2src;
    logic forwardrdsrc;
    logic [31:0] alusrca,alusrcb;
    logic [31:0] pc2reg;
    logic [31:0] EX_pcadd4src;
    add_imm ADDpc4(EX_pc,32'd4,EX_pcadd4src);
    add_imm ADDpcimm(EX_pc,EX_imm,EX_pcaddimm);
    MUX2to1 muxpc2reg(EX_pcaddimm,EX_pcadd4src,EX_PCtoregsrc,pc2reg);
    logic [31:0] MEM_rd_data;


    MUX3to1 muxex1(EX_rs1_data,MEM_rd_data,WB_wb_data,forwardrs1src,alusrca);
    MUX3to1 muxex2(EX_rs2_data,MEM_rd_data,WB_wb_data,forwardrs2src,alusrcb);


    logic [31:0] alusrcb2;
    
    MUX2to1 muxalu(alusrcb,EX_imm,EX_Alusrc,alusrcb2);
    alu AlU(alusrca,alusrcb2,aluctrl,EX_aluout,zeroflag);
	

    logic /*MEM_Memread,MEM_Memwrite,*/
          MEM_Memtoreg,MEM_Regwrite,
          MEM_PCtoregsrc,MEM_RDsrc;
    
    logic [4:0] MEM_rdnum;
    logic [31:0] MEM_pc2reg,MEM_alu_out;
    logic [31:0] MEM_data_in;
    logic [31:0] MEM_forward_rs2_data;
   
    logic [2:0] MEM_funct3; 
    //assign EX_forward_rs2_data=alusrcb;

    EXMEM_reg EXMEMstage(
        clk,rst,
        EX_RDsrc,
        EX_Memread,EX_Memwrite,EX_Memtoreg,EX_Regwrite,
        pc2reg,
        EX_aluout,
        alusrcb,
        EXrd,
	    EX_funct3,

        MEM_Memread,MEM_Memwrite,MEM_Memtoreg,MEM_Regwrite,MEM_RDsrc,
        MEM_rdnum,
	    MEM_funct3,
        MEM_pc2reg,
        MEM_alu_out,
        MEM_forward_rs2_data
        
    );

    


    logic WB_Memtoreg;
    logic [31:0] WB_rd_data, WB_data_out;
    logic [31:0] DMdata2;

    //logic [2:0] WB_funct3;
    
    MUX2to1 muxrddata(MEM_pc2reg,MEM_alu_out,MEM_RDsrc,MEM_rd_data);
   
    MEMWB_reg MEMWBstage(
        clk,rst,
        MEM_Memtoreg,MEM_Regwrite,
        MEM_rd_data,
        DMdata2,
        MEM_rdnum,
	    WB_Memtoreg,WB_Regwrite,
        WB_rd_data,
        WB_data_out,
        WB_rdnum,
    );
    
 
        



    MUX2to1 muxwbdata(WB_rd_data,WB_data_out,WB_Memtoreg,WB_wb_data);
    
    MUX2to1 muxmemdatain(MEM_forward_rs2_data,WB_wb_data,forwardrdsrc,MEM_data_in);

   
    //logic [3:0] wen; 
    //logic [31:0] datatoDM;
    

    /*DMdata2*/
    loadreg_ctrl LWctrl(MEM_Memread,MEM_funct3,
    DMdata,DMdata2);

    storemem_ctrl SWctrl(MEM_Memwrite,
                         MEM_funct3,
                         MEM_alu_out,
                         MEM_data_in,
                         datatoDM,wen); 


    //SRAM_wrapper DM1(~clk,MEM_Memread|MEM_Memwrite,MEM_Memread,wen,MEM_alu_out[15:2],datatoDM,DMdata);        
    assign DMaddr = MEM_alu_out[15:2];

    hazard_ctrl HZ(EX_Memread,branchsel,EXrd,IDrs1,IDrs2,PCwrite,flush,signalflush,IFIDwrite);
    
    forward_ctrl ForwardUnit(.regw_wb(WB_Regwrite),
                      .mem_w(MEM_Memwrite),
                      .regw_mem(MEM_Regwrite),
                      .rs1ex(EXrs1),
                      .rs2ex(EXrs2),
                      .rdwb(WB_rdnum),
                      .rdmem(MEM_rdnum),
                      
                      .forward_rd(forwardrdsrc),
                      .forward_rs1(forwardrs1src),
                      .forward_rs2(forwardrs2src));

    
    
    

endmodule
