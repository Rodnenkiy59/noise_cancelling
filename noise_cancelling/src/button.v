
module button (
    input  clk, 
    input  rstn, 
    input  in, 
    output out
);

reg in_reg0;
reg in_reg1;
reg in_reg2;
reg in_reg3;
reg in_reg4;


always @(posedge clk)
begin
    if(!rstn)
    begin
        in_reg0 <= 1'b1;
        in_reg1 <= 1'b1;
        in_reg2 <= 1'b1;
        in_reg3 <= 1'b1;
        in_reg4 <= 1'b1;
    end
    else
    begin
        in_reg0 <= in;
        in_reg1 <= in_reg0;
        in_reg2 <= in_reg1;
        in_reg3 <= in_reg2;
        in_reg4 <= (~in_reg2) & in_reg3;
    end
end

assign out = (~in_reg2) & in_reg3;

endmodule