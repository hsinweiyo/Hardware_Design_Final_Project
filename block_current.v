`include "global.v"

module block_current(
	input wire [`BITS_X_POS-1:0]	  pos_x,
    input wire [`BITS_Y_POS-1:0]	  pos_y,
    input wire [`BITS_ROT-1:0]		  rot,
    input wire [`BITS_PER_BLOCK-1:0]  block,
    output reg [`BITS_BLK_POS-1:0]	  blk_1,
    output reg [`BITS_BLK_POS-1:0]	  blk_2,
    output reg [`BITS_BLK_POS-1:0]	  blk_3,
    output reg [`BITS_BLK_POS-1:0]	  blk_4,
    output reg [2:0]				  block_width,
    output reg [2:0]                  block_height
);

	always @(*)begin
		case(block)
			`EMPTY_BLOCK: begin
				blk_1 = 0;
				blk_2 = 0;
				blk_3 = 0;
				blk_4 = 0;
				block_width  = 0;
				block_height = 0;
			end
			`I_BLOCK: begin
				if(rot == 0 || rot == 2) begin
					blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
					blk_2 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
					blk_3 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x;
					blk_4 = ((pos_y + 3) * `BLOCKS_ROW) + pos_x;
					block_width  = 1;
					block_height = 4;
				end else begin
					blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
					blk_2 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
					blk_3 = (pos_y * `BLOCKS_ROW) + pos_x + 2;
					blk_4 = (pos_y * `BLOCKS_ROW) + pos_x + 3;
					block_width  = 4;
					block_height = 1;
				end
			end
			`O_BLOCK: begin
				blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
				blk_2 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
				blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
				blk_4 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
				block_width  = 2;
				block_height = 2;
			end
			`T_BLOCK: begin
				case(rot)
					0: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
						blk_2 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
						blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
						blk_4 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 2;
						block_width  = 3;
						block_height = 2;
					end
					1: begin
						blk_1 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
						blk_2 = (pos_y * `BLOCKS_ROW) + pos_x;
						blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
						blk_4 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x;
						block_width  = 2;
						block_height = 3;
					end
					2: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
						blk_2 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
						blk_3 = (pos_y * `BLOCKS_ROW) + pos_x + 2;
						blk_4 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
						block_width  = 3;
						block_height = 2;
					end
					3: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
						blk_2 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
						blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
						blk_4 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x + 1;
						block_width  = 2;
						block_height = 3;
					end
				endcase
			end
			`S_BLOCK: begin
				if(rot == 0 || rot == 2) begin
					blk_1 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
					blk_2 = (pos_y * `BLOCKS_ROW) + pos_x + 2;
					blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
					blk_4 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
					block_width  = 3;
					block_height = 2;
				end else begin
					blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
					blk_2 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
					blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
					blk_4 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x + 1;
					block_width  = 2;
					block_height = 3;
				end
			end
			`Z_BLOCK: begin
				if(rot == 0 || rot == 2) begin
					blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
					blk_2 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
					blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
					blk_4 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 2;
					block_width  = 3;
					block_height = 2;
				end else begin
					blk_1 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
					blk_2 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
					blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
					blk_4 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x;
					block_width  = 2;
					block_height = 3;
				end
			end
			`J_BLOCK: begin
				case(rot)
					0: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
						blk_2 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
						blk_3 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x;
						blk_4 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x + 1;
						block_width  = 2;
						block_height = 3;
					end
					1: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
						blk_2 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
						blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
						blk_4 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 2;
						block_width  = 3;
						block_height = 2;
					end
					2: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
						blk_2 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
						blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
						blk_4 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x;
						block_width  = 2;
						block_height = 3;
					end
					3: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
						blk_2 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
						blk_3 = (pos_y * `BLOCKS_ROW) + pos_x + 2;
						blk_4 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 2;
						block_width  = 3;
						block_height = 2;
					end
				endcase
			end
			`L_BLOCK: begin
				case(rot)
					0: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
						blk_2 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
						blk_3 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x;
						blk_4 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x + 1;
						block_width  = 2;
						block_height = 3;
					end
					1: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
						blk_2 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
						blk_3 = (pos_y * `BLOCKS_ROW) + pos_x + 2;
						blk_4 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
						block_width  = 3;
						block_height = 2;
					end
					2: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x;
						blk_2 = (pos_y * `BLOCKS_ROW) + pos_x + 1;
						blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
						blk_4 = ((pos_y + 2) * `BLOCKS_ROW) + pos_x + 1;
						block_width  = 2;
						block_height = 3;
					end
					3: begin
						blk_1 = (pos_y * `BLOCKS_ROW) + pos_x + 2;
						blk_2 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x;
						blk_3 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 1;
						blk_4 = ((pos_y + 1) * `BLOCKS_ROW) + pos_x + 2;
						block_width  = 3;
						block_height = 2;
					end
				endcase
			end
		endcase
	end
endmodule

