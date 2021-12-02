module alu(input [31:0] rs1,
           input [31:0] rs2,
           input [4:0] alu_ctrl,
           output logic [31:0]alu_out,
           output logic zero_flag);

always @(*) begin
    case(alu_ctrl)
    5'd0: begin
      alu_out=rs2;
      zero_flag=0;
    end
    5'd1: begin
      alu_out = rs1+rs2;
      zero_flag=0;
    end
    5'd2: begin
      alu_out = rs1-rs2;
      zero_flag=0;
    end
    5'd3: begin
      alu_out = rs1&rs2;
      zero_flag=0;
    end
    5'd4: begin
      alu_out = rs1 | rs2;
      zero_flag=0;
    end
    5'd5: begin
      alu_out = rs1 ^ rs2;
      zero_flag=0;
    end
    5'd6: begin
      alu_out = rs1<<rs2[4:0];
      zero_flag=0;
    end
    5'd7: begin
      if ($signed(rs1) < $signed(rs2))begin
        alu_out=1;
        zero_flag=0;
      end
      else begin 
        alu_out=0;
        zero_flag=0;
      end
    end
    5'd8: begin
      if (rs1 < rs2)begin
        alu_out=1;
        zero_flag=0;
      end
      else begin 
        alu_out=0;
        zero_flag=0;
      end
    end
    5'd9: begin 
      alu_out = rs1 >> rs2[4:0]; 
      zero_flag = 0; 
    end
    5'd10: begin
      alu_out = $signed(rs1) >>> rs2[4:0];
      zero_flag = 0;
    end
    5'd11: begin
      alu_out = 0;
      if (rs1 == rs2) zero_flag=1;
      else zero_flag=0;
    end
    5'd12: begin
      alu_out = 0;
      if(rs1 != rs2)zero_flag=1;
      else zero_flag=0;
    end
    5'd13: begin
      alu_out = 0;
      if($signed(rs1) < $signed(rs2)) zero_flag=1;
      else zero_flag=0;
    end
    5'd14: begin
      alu_out = 0;
      if($signed(rs1) >= $signed(rs2)) zero_flag=1;
      else zero_flag=0;
    end
    5'd15: begin
       alu_out = 0;
      if(rs1<rs2)zero_flag=1;
      else zero_flag=0;
    end
    5'd16: begin
       alu_out = 0;
      if(rs1>=rs2)zero_flag=1;
      else zero_flag=0;
    end
    5'd17: begin
        alu_out = (rs1 + rs2) & {28'hfffffff,4'b1110};//jalr
		zero_flag = 1'b0;
    end
    default: begin
        alu_out = 32'd0;
        zero_flag = 1'b0;
    end
    endcase
end
endmodule

