`include "global.v"

module row_complete(
	input wire 								    clk,
	input wire                                  rst,
	input wire                                  state_rst,
	input wire                                  beat,
	input wire 								    pause,
	input wire                                  delete,
	input wire  [`BLOCKS_ROW * `BLOCKS_COL-1:0] game_board,
	output reg  [2:0]                           ko,
	output reg  [5:0]                           line_sended,
	output reg  [`BITS_Y_POS-1:0]			    row,
	output reg								    enabled,
	output wire                                 send,
	output reg  [`BITS_Y_POS-1:0]               send_line
);

    assign send = enabled;
    
	always @(row or game_board) begin
	    enabled = &game_board[row * `BLOCKS_ROW +: `BLOCKS_ROW];
    end 
	
	always @(posedge clk or posedge rst) begin
	    if(rst) begin
	        send_line   <= 0;
	        ko          <= 0;
	        line_sended <= 0;
	    end else if(state_rst) begin
	        send_line   <= 0;
            ko          <= 0;
            line_sended <= 0;
	    end else if(beat) begin
	        send_line <= 0;
	        ko        <= ko + 1;
	    end else if (!pause) begin
            if(send) begin
                send_line   <= send_line + 1;
                line_sended <= line_sended + 1;
            end else if(delete && send_line >= 1) begin
                send_line <= send_line - 1;
            end
        end
    end
        
	always @(posedge clk) begin
	    if(pause) begin
	        row <= 0;
	    end else begin
			if(row == `BLOCKS_COL-1) begin
				row <= 0;
			end else begin
				row <= row + 1;
			end
		end
	end

endmodule