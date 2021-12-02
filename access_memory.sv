module storemem_ctrl(
    input mem_w,
    input [2:0] funct3,
    input [31:0] r_mem_addr,
    input [31:0] write_data,
    output logic [31:0] data_out,
    output logic [3:0] write_en

); 
    always_comb begin
            //STORE DATA
            if(mem_w) begin
                //SB
               if(funct3==3'b000)begin
                  case(r_mem_addr[1:0])
                    2'b00: begin
                        write_en = 4'b1110;
                        data_out = {24'd0, write_data[7:0]};
                    end
                    2'b01: begin
                        write_en = 4'b1101;
                        data_out = {16'd0, write_data[7:0], 8'd0};
                    end
                    2'b10: begin
                        write_en = 4'b1011;
                        data_out = {8'd0, write_data[7:0], 16'd0};
                    end
                    2'b11: begin
                        write_en = 4'b0111;
                        data_out = {write_data[7:0], 24'd0};
                    end 
                    endcase
               end
                //SH
                else if(funct3==3'b001)begin
                  case(r_mem_addr[1])
                    1'b0: begin
                        write_en = 4'b1100;
                        data_out = {16'd0, write_data[15:0]};
                    end
                    1'b1: begin
                        write_en = 4'b0011;
                        data_out = {write_data[15:0], 16'd0};
                    end
                  endcase
                end

                else begin
                    write_en=4'b0000;
                    data_out=write_data; 
                end
            end
            else begin // not store data to memory
                write_en = 4'b1111;
                data_out = write_data;
            end
            
    end
endmodule


            




module loadreg_ctrl(
    input mem_r,
    input [2:0] funct3,
    //input [1:0] addr,
    input [31:0] data,
    output logic [31:0]data_out
);
    always_comb begin
        if(mem_r)begin
            //LB
            if(funct3==3'b000) begin
                data_out = {{24{data[7]}}, data[7:0]};

            end
            //LBU
            else if(funct3==3'b100) begin
               
                data_out = {24'b0, data[7:0]};
                   
            end
            //LH
            else if(funct3==3'b001) begin
               
                data_out = {{16{data[15]}}, data[15:0]};
            
            end
            //LHU
            else if(funct3==3'b101) begin
              
                data_out = {16'b0, data[15:0]};
                    
            end
            else if (funct3==3'b010) begin
                data_out = data;
            end
            

        end//IF

        else begin
            data_out = 32'd0;
        end
    end//ALWAYS
endmodule