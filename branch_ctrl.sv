module Branch_ctrl(input [1:0] sel,
                   input zero_flag,
                   output logic[1:0] branchctrl);
always_comb begin
    
      if(sel==2'b00)
        branchctrl=2'b10;
      
      else if (sel==2'b01 & zero_flag==1'b1)
        branchctrl=2'b01;
      
      else if(sel==2'b01 & zero_flag==1'b0) branchctrl=2'b10;
      else if(sel==2'b10) branchctrl=2'b00;
      else  branchctrl=2'b01;

end
      
endmodule