module forward_ctrl(input regw_wb,
                    input mem_w,
                    input regw_mem,
                    input [4:0] rs1ex,
                    input [4:0] rs2ex,
                    input [4:0] rdwb,
                    input [4:0] rdmem,

                    output reg forward_rd,
                    output reg [1:0] forward_rs1,
                    output reg [1:0] forward_rs2

                    );


always_comb begin
    if ( regw_wb & (rdwb != 5'b0)
    & ( rs1ex == rdwb )
    & (! (regw_mem &  rdmem != 5'b0 & rs1ex == rdmem)) )
    begin    
        forward_rs1=2'b10;
    end
    else  if (regw_mem & rdmem!=5'd0 & rs1ex==rdmem)
    begin   
        forward_rs1=2'b01;
    end    
    else begin
        forward_rs1=2'b00;
    end

    if ( regw_wb & (rdwb != 5'b0)
    & ( rs2ex == rdwb )
    & (! (regw_mem &  rdmem != 5'b0 & rs2ex == rdmem)) )
    begin 
        forward_rs2=2'b10;
    end

    else if (regw_mem & rdmem!=5'd0 & rs2ex==rdmem)
    begin 
        forward_rs2=2'b01;
    end
    else begin
        forward_rs2=2'b00;
    end

    if ( regw_wb & mem_w
    & (rdwb == rdmem )) begin
        forward_rd = 1'b1;
    end else begin
        forward_rd = 1'b0;
    end

end
endmodule