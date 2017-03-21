`include "global.v"

module block_next(
	input wire [`MODE_BITS-1:0]  mode,
	input wire					 game_clk,
	input wire					 p1_left,
	input wire					 p1_right,
	input wire					 p1_rotate,
	input wire					 p1_change,
	input wire					 p1_speed,
	input wire					 p1_drop,
	input wire [`BITS_X_POS-1:0] pos_x,
    input wire [`BITS_Y_POS-1:0] pos_y,
    input wire [`BITS_ROT-1:0]   rot,
    output reg [`BITS_X_POS-1:0] next_pos_x,
    output reg [`BITS_Y_POS-1:0] next_pos_y,
    output reg [`BITS_ROT-1:0]   next_rot
);

	always @(*) begin
		if(mode == `MODE_PLAY) begin
			if(game_clk) begin
				next_pos_x = pos_x;
				next_pos_y = pos_y + 1;
				next_rot   = rot;
			end else if(p1_right) begin
				next_pos_x = pos_x + 1;
				next_pos_y = pos_y;
				next_rot   = rot;
			end else if(p1_left) begin
				next_pos_x = pos_x - 1;
				next_pos_y = pos_y;
				next_rot = rot;
			end else if(p1_speed) begin
				next_pos_x = pos_x;
				next_pos_y = pos_y + 1;
				next_rot   = rot;
			end else if(p1_drop) begin
				next_pos_x = pos_x;
				next_pos_y = pos_y;
				next_rot   = rot;
			end else if(p1_rotate) begin
				next_pos_x = pos_x;
				next_pos_y = pos_y;
				next_rot   = rot + 1;
			end else begin
				next_pos_x = pos_x;
				next_pos_y = pos_y;
				next_rot   = rot;
			end
		end else if(mode == `MODE_DROP) begin
			if(game_clk) begin
				next_pos_x = pos_x;
				next_pos_y = pos_y + 1;
				next_rot   = rot;
			end else begin
				next_pos_x = pos_x;
				next_pos_y = pos_y + 1;
				next_rot   = rot;
			end
		end else begin
			next_pos_x = pos_x;
			next_pos_y = pos_y + 1;
			next_rot   = rot;
		end
	end
endmodule