module hazard_ctrl(input mem_r,
                   //input mem_w,
                   input [1:0] branchctrl,
                   input [4:0] rd_num,
                   input [4:0] rs1_num,
                   input [4:0] rs2_num,
                   
                   output reg pcwrite,
                   output reg IF_flush,
                   output reg IDEX_flush,
                   output reg IFID_regw
                   
                   );
    
always @(*) begin
    if(branchctrl!=2'b10)begin
      pcwrite=1'b1;
      IF_flush=1'b1;
      IDEX_flush=1'b1;
      IFID_regw=1'b1;
    end 
    else if(mem_r /*& mem_w==1'b0*/
      & (rd_num==rs1_num | rd_num==rs2_num))begin
        IFID_regw=1'b0;
        IDEX_flush=1'b1;
        pcwrite=1'b0;
        IF_flush=1'b0;
      end
    else begin
      pcwrite=1'b1;
      IF_flush=1'b0;
      IDEX_flush=1'b0;
      IFID_regw=1'b1;
    end
end
endmodule