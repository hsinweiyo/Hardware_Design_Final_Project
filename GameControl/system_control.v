`include "global.v"

module system_control(
    input wire        clk,
    input wire        rst,
    input wire [2:0]  ko,
    input wire [2:0]  ko_2,
    input wire [5:0]  line_sended,
    input wire [5:0]  line_sended_2,
    input wire        select_2P,
    input wire        select_1P,
    input wire        back,
    input wire        time_up,
    output reg        game_over,
    output reg [2:0]  state
);
    reg [2:0] next_state;
    
    always @(posedge clk or posedge rst) begin
        if(rst) state <= `STATE_READY;
        else    state <= next_state;
    end
    
    always @(*) begin
        next_state = state;
        case(state)
            `STATE_READY: begin
                if(select_2P) 
                    next_state = `STATE_GAME;
                else if(select_1P) 
                    next_state = `STATE_1P_GAME;
            end
            `STATE_GAME:
            begin
                if(time_up || (ko == 5) || (ko_2 == 5)) begin
                    if(ko > ko_2)       next_state = `STATE_P1_WINS;
                    else if(ko < ko_2)  next_state = `STATE_P2_WINS;
                    else begin
                        if(line_sended > line_sended_2)
                            next_state = `STATE_P1_WINS;
                        else
                            next_state = `STATE_P2_WINS;
                    end
                end     
            end
            `STATE_P1_WINS: if(back)    next_state = `STATE_READY;
            `STATE_P2_WINS: if(back)    next_state = `STATE_READY;
            `STATE_1P_GAME: if(time_up) next_state = `STATE_1P_OVER;
            `STATE_1P_OVER: if(back)    next_state = `STATE_READY;
        endcase
    end
    
    always @(*) begin
        if(rst) 
            game_over = 1'b0;
        else if(ko == 5 || ko_2 == 5) 
            game_over = 1'b1;
        else 
            game_over = 1'b0;
    end
endmodule