module random_bomb(
    input wire       clk,
    output reg [3:0] random
);

    //select when user input
    always @(posedge clk) begin
        if (random == 9) begin
            random <= 0;
        end else begin
            random <= random + 1;
        end
    end

endmodule