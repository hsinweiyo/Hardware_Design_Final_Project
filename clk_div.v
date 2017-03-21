module clk_div(
    input      CLK,
    input      rst,
    output reg clk
);
    reg [1:0] count;
    
    always @(posedge CLK or posedge rst) begin
        if(rst) count <= 2'd0;
        else if(count == 2'd3) begin
            count <= 2'd0;
        end else begin
            count <= count + 2'd1;
        end
    end
    
    always @(posedge CLK or posedge rst) begin
        if(rst) clk = 0;
        else if(count < 2'd2) begin
            clk = 0;
        end else begin
            clk = 1;
        end
    end

endmodule
