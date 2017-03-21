`include "global.v"

module tetris(
	input wire 		  CLK,
	input wire 		  rst,
	inout wire 		  PS2_DATA,
	inout wire 		  PS2_CLK,
	output wire [3:0] vgaRed,
	output wire [3:0] vgaBlue,
	output wire [3:0] vgaGreen,
	output wire [5:0] line_sended,
    output wire [5:0] line_sended_2,
	output wire [6:0] seg,
	output wire [3:0] an,ㄋ
	output wire 	  hsync,
	output wire 	  vsync,
	output pmod_1,
    output pmod_2,
    output pmod_4,
    output se_1,
    output se_2,
    output se_4,
    output se_2_1,
    output se_2_2,
    output se_2_4
);
    wire time_up;
	wire clk;
	wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;
    wire p1_left;
    wire p1_right;
    wire p1_rotate;
    wire p1_change;
    wire p1_speed;
    wire p1_drop;
    wire p2_left;
    wire p2_right;
    wire p2_rotate;
    wire p2_change;
    wire p2_speed;
    wire p2_drop;
    wire enter;
    wire pause;
    wire [`BLOCKS_ROW * `BLOCKS_COL-1:0] game_board;
    wire [`BLOCKS_ROW * `BLOCKS_COL-1:0] game_board_2;
    wire [`BLOCKS_ROW * `BLOCKS_COL-1:0] game_board_3;
    wire [`BITS_PER_BLOCK-1:0] next_block;
    wire [`BITS_PER_BLOCK-1:0] next_block_2;
    wire [`BITS_PER_BLOCK-1:0] next_block_3;
    
    wire [`BITS_PER_BLOCK-1:0] cur_piece;
    wire [`BITS_PER_BLOCK-1:0] cur_piece_2;
    wire [`BITS_PER_BLOCK-1:0] cur_piece_3;
    
    wire [`BITS_X_POS-1:0]     cur_pos_x;
    wire [`BITS_X_POS-1:0]     cur_pos_x_2;
    wire [`BITS_X_POS-1:0]     cur_pos_x_3;
    
    wire [`BITS_Y_POS-1:0]     cur_pos_y;
    wire [`BITS_Y_POS-1:0]     cur_pos_y_2;
    wire [`BITS_Y_POS-1:0]     cur_pos_y_3;
    
    wire [`BITS_PER_BLOCK-1:0] show_block;
    wire [`BITS_PER_BLOCK-1:0] show_block_2;
    wire [`BITS_PER_BLOCK-1:0] show_block_3;
    
    wire [`BITS_ROT-1:0]       cur_rot;
    wire [`BITS_ROT-1:0]       cur_rot_2;
    wire [`BITS_ROT-1:0]       cur_rot_3;
    
    wire [`BITS_BLK_POS-1:0]   cur_blk_1;
    wire [`BITS_BLK_POS-1:0]   cur_blk_2;
    wire [`BITS_BLK_POS-1:0]   cur_blk_3;
    wire [`BITS_BLK_POS-1:0]   cur_blk_4;
    wire [`BITS_BLK_POS-1:0]   cur_2_blk_1;
    wire [`BITS_BLK_POS-1:0]   cur_2_blk_2;
    wire [`BITS_BLK_POS-1:0]   cur_2_blk_3;
    wire [`BITS_BLK_POS-1:0]   cur_2_blk_4;
    wire [`BITS_BLK_POS-1:0]   cur_3_blk_1;
    wire [`BITS_BLK_POS-1:0]   cur_3_blk_2;
    wire [`BITS_BLK_POS-1:0]   cur_3_blk_3;
    wire [`BITS_BLK_POS-1:0]   cur_3_blk_4;
        
    wire [`BITS_BLK_SIZE-1:0]  cur_width;
    wire [`BITS_BLK_SIZE-1:0]  cur_height;
    wire [`BITS_BLK_SIZE-1:0]  cur_2_width;
    wire [`BITS_BLK_SIZE-1:0]  cur_2_height;
    wire [`BITS_BLK_SIZE-1:0]  cur_3_width;
    wire [`BITS_BLK_SIZE-1:0]  cur_3_height;
    
    wire [`MODE_BITS-1:0] mode;
    wire [`MODE_BITS-1:0] mode_2;
    wire [`MODE_BITS-1:0] mode_3;
    
    wire [9:0] h_cnt;
    wire [9:0] v_cnt;
    wire vaild;

    wire game_clk;
    wire game_rst;
    wire game_clk_2;
    wire game_rst_2;
    wire game_clk_3;
    wire game_rst_3;
    
    wire [`BITS_X_POS-1:0] next_pos_x;
    wire [`BITS_Y_POS-1:0] next_pos_y;
    wire [`BITS_ROT-1:0]   next_rot;
    wire [`BITS_X_POS-1:0] next_pos_x_2;
    wire [`BITS_Y_POS-1:0] next_pos_y_2;
    wire [`BITS_ROT-1:0]   next_rot_2;
    wire [`BITS_X_POS-1:0] next_pos_x_3;
    wire [`BITS_Y_POS-1:0] next_pos_y_3;
    wire [`BITS_ROT-1:0]   next_rot_3;
    
    wire [`BITS_BLK_POS-1:0]   next_blk_1;
    wire [`BITS_BLK_POS-1:0]   next_blk_2;
    wire [`BITS_BLK_POS-1:0]   next_blk_3;
    wire [`BITS_BLK_POS-1:0]   next_blk_4;
    
    wire [`BITS_BLK_SIZE-1:0]  next_width;
    wire [`BITS_BLK_SIZE-1:0]  next_height;

    wire [`BITS_BLK_POS-1:0]   next_2_blk_1;
    wire [`BITS_BLK_POS-1:0]   next_2_blk_2;
    wire [`BITS_BLK_POS-1:0]   next_2_blk_3;
    wire [`BITS_BLK_POS-1:0]   next_2_blk_4;
    
    wire [`BITS_BLK_SIZE-1:0]  next_2_width;
    wire [`BITS_BLK_SIZE-1:0]  next_2_height;
    
    wire [`BITS_BLK_POS-1:0]   next_3_blk_1;
    wire [`BITS_BLK_POS-1:0]   next_3_blk_2;
    wire [`BITS_BLK_POS-1:0]   next_3_blk_3;
    wire [`BITS_BLK_POS-1:0]   next_3_blk_4;
        
    wire [`BITS_BLK_SIZE-1:0]  next_3_width;
    wire [`BITS_BLK_SIZE-1:0]  next_3_height;
   
    wire [`BITS_Y_POS-1:0] remove_row_y;
    wire [`BITS_Y_POS-1:0] remove_row_y_2;
    wire [`BITS_Y_POS-1:0] remove_row_y_3;
    
    wire [`BITS_Y_POS-1:0] send_line;
    wire [`BITS_Y_POS-1:0] send_line_2;
    wire [`BITS_Y_POS-1:0] send_line_3;
    
    wire [`BITS_Y_POS-1:0] add_line;
    wire [`BITS_Y_POS-1:0] add_line_2;
    wire [`BITS_Y_POS-1:0] add_line_3;
    
    wire remove_row_en;
    wire remove_row_en_2;
    wire remove_row_en_3;
    
    wire send_en;
    wire send_en_2;
    wire send_en_3;
    
    wire clear_en;
    wire clear_en_2;
    wire clear_en_3;
        
    wire game_over;
    wire game_over_2;
    wire game_over_3;
    
    wire [`BITS_PER_BLOCK-1:0] hold_block;
    wire [`BITS_PER_BLOCK-1:0] hold_block_2;
    wire [`BITS_PER_BLOCK-1:0] hold_block_3;
    
    wire [2:0] ko;
    wire [2:0] ko_2;
    wire [2:0] ko_3;
    wire       game_finish;
    
    wire [2:0] state;
    wire [3:0] bomb_pos;
    
    wire [31:0]tone_1;
    wire [31:0]tone_2;
    //wire [31:0]tone_1_2;
    //wire [31:0]tone_2_2;
    
    TOP TT(.clk(CLK), 
        .reset(rst), 
        .tone_1(tone_1), 
        .tone_2(tone_2), 
        .pmod_1(pmod_1), 
        .pmod_2(pmod_2), 
        .pmod_4(pmod_4), 
        .se_1(se_1), 
        .se_2(se_2), 
        .se_4(se_4), 
        .se_2_1(se_2_1), 
        .se_2_2(se_2_2), 
        .se_2_4(se_2_4)
    );
    
	clk_div clock_div(
	   .CLK(CLK),
	   .rst(rst),
	   .clk(clk)
	);
    
    CountDown_Timer count_down(
        .CLK        (CLK),
        .RESET      (rst),
        .game_over  (game_finish),
        .pause      (pause),
        .Start      (enter),
        .AN         (an),
        .Seg        (seg),
        .time_up    (time_up)
    );
    
	KeyboardDecoder key_de (
		.key_down    (key_down),
		.last_change (last_change),
		.key_valid   (been_ready),
		.PS2_DATA    (PS2_DATA),
		.PS2_CLK     (PS2_CLK),
		.rst         (rst),
		.clk 		 (clk)
	);
	
    keyboard_select key_sel(
        .key_down    (key_down),
        .been_ready  (been_ready),
        .p1_left     (p1_left),
        .p1_right    (p1_right),
        .p1_rotate   (p1_rotate),
        .p1_change   (p1_change),
        .p1_speed    (p1_speed),
        .p1_drop     (p1_drop),
        .enter       (enter),
        .p2_left     (p2_left),
        .p2_right    (p2_right),
        .p2_rotate   (p2_rotate),
        .p2_change   (p2_change),
        .p2_speed    (p2_speed),
        .p2_drop     (p2_drop),
        .pause       (pause)
    );
    
	randomizer random_block (
    	.clk    (clk),
    	.random (next_block)
	);

    randomizer random_block_2 (
        .clk    (CLK),
        .random (next_block_2)
    );
    
    randomizer random_block_3 (
        .clk    (CLK),
        .random (next_block_3)
    );
    
    random_bomb rand_bomb(
        .clk    (clk),
        .random (bomb_pos)
    );
    
	system_control system_con(
        .clk            (CLK),
        .rst            (rst),
        .ko             (ko),
        .ko_2           (ko_2),
        .line_sended    (line_sended),
        .line_sended_2  (line_sended),
        .select_2P      (enter),
        .select_1P      (p1_left),
        .back           (p2_drop),
        .time_up        (time_up),
        .game_over      (game_finish),
        .state          (state)
    );

    block_current current_blk (
    	.pos_x         (cur_pos_x),
   		.pos_y         (cur_pos_y),
    	.rot           (cur_rot),
    	.block         (cur_piece),
    	.blk_1         (cur_blk_1),
    	.blk_2         (cur_blk_2),
    	.blk_3         (cur_blk_3),
    	.blk_4         (cur_blk_4),
    	.block_width   (cur_width),
    	.block_height  (cur_height)
    );

    block_current current_blk_2 (
        .pos_x        (cur_pos_x_2),
        .pos_y        (cur_pos_y_2),
        .rot          (cur_rot_2),
        .block        (cur_piece_2),
        .blk_1        (cur_2_blk_1),
        .blk_2        (cur_2_blk_2),
        .blk_3        (cur_2_blk_3),
        .blk_4        (cur_2_blk_4),
        .block_width  (cur_2_width),
        .block_height (cur_2_height)
    );
    
    block_current current_blk_3 (
        .pos_x        (cur_pos_x_3),
        .pos_y        (cur_pos_y_3),
        .rot          (cur_rot_3),
        .block        (cur_piece_3),
        .blk_1        (cur_3_blk_1),
        .blk_2        (cur_3_blk_2),
        .blk_3        (cur_3_blk_3),
        .blk_4        (cur_3_blk_4),
        .block_width  (cur_3_width),
        .block_height (cur_3_height)
    );
    
     vga_controller display (
         .pclk  (clk),
         .reset (rst),
         .hsync (hsync),
         .vsync (vsync),
         .valid (valid),
         .h_cnt (h_cnt),
         .v_cnt (v_cnt)
     );

     pixel_gen pix_gen (
         .clk           (CLK),
         .h_cnt         (h_cnt),
         .v_cnt         (v_cnt),
         .rst           (rst),
         .state         (state),
         .get_line      (send_line_2),
         .get_line_2    (send_line),
         .cur_piece     (cur_piece),
         .hold_block    (hold_block),
         .show_block    (show_block),
         .cur_blk_1     (cur_blk_1),
         .cur_blk_2     (cur_blk_2),
         .cur_blk_3     (cur_blk_3),
         .cur_blk_4     (cur_blk_4),
         .game_board    (game_board),
         .cur_piece_2   (cur_piece_2),
         .hold_block_2  (hold_block_2),
         .show_block_2  (show_block_2),
         .cur_2_blk_1   (cur_2_blk_1),
         .cur_2_blk_2   (cur_2_blk_2),
         .cur_2_blk_3   (cur_2_blk_3),
         .cur_2_blk_4   (cur_2_blk_4),
         .game_board_2  (game_board_2),
         .cur_piece_3   (cur_piece_3),
         .hold_block_3  (hold_block_3),
         .show_block_3  (show_block_3),
         .cur_3_blk_1   (cur_3_blk_1),
         .cur_3_blk_2   (cur_3_blk_2),
         .cur_3_blk_3   (cur_3_blk_3),
         .cur_3_blk_4   (cur_3_blk_4),
         .game_board_3  (game_board_3),
         .ko            (ko),
         .ko_2          (ko_2),
         .valid         (valid),
         .vgaRed        (vgaRed),
         .vgaGreen      (vgaGreen),
         .vgaBlue       (vgaBlue)
      );

	game_clock gameclk(
    	.clk      (clk),
    	.rst      (game_rst),
    	.pause    (mode != `MODE_PLAY),
    	.game_clk (game_clk)
	);
    
    game_clock gameclk_2(
        .clk      (clk),
        .rst      (game_rst_2),
        .pause    (mode_2 != `MODE_PLAY),
        .game_clk (game_clk_2)
    );
    
    game_clock gameclk_3(
        .clk      (clk),
        .rst      (game_rst_3),
        .pause    (mode_3 != `MODE_PLAY),
        .game_clk (game_clk_3)
    );

    block_next blk_next(
		.mode 		(mode),
		.game_clk   (game_clk),
		.p1_left    (p1_left),
		.p1_right   (p1_right),
		.p1_rotate  (p1_rotate),
		.p1_change  (p1_change),
		.p1_speed   (p1_speed),
		.p1_drop    (p1_drop),
		.pos_x 	    (cur_pos_x),
    	.pos_y	    (cur_pos_y),
    	.rot        (cur_rot),
    	.next_pos_x (next_pos_x),
    	.next_pos_y (next_pos_y),
    	.next_rot	(next_rot)
	);

    block_next blk_next_2(
        .mode       (mode_2),
        .game_clk   (game_clk_2),
        .p1_left    (p2_left),
        .p1_right   (p2_right),
        .p1_rotate  (p2_rotate),
        .p1_change  (p2_change),
        .p1_speed   (p2_speed),
        .p1_drop    (p2_drop),
        .pos_x      (cur_pos_x_2),
        .pos_y      (cur_pos_y_2),
        .rot        (cur_rot_2),
        .next_pos_x (next_pos_x_2),
        .next_pos_y (next_pos_y_2),
        .next_rot   (next_rot_2)
    );
    
    block_next blk_next_3(
        .mode       (mode_3),
        .game_clk   (game_clk_3),
        .p1_left    (p2_left),
        .p1_right   (p2_right),
        .p1_rotate  (p2_rotate),
        .p1_change  (p2_change),
        .p1_speed   (p2_speed),
        .p1_drop    (p2_drop),
        .pos_x      (cur_pos_x_3),
        .pos_y      (cur_pos_y_3),
        .rot        (cur_rot_3),
        .next_pos_x (next_pos_x_3),
        .next_pos_y (next_pos_y_3),
        .next_rot   (next_rot_3)
    );

    block_current next_blk (
    	.pos_x (next_pos_x),
   		.pos_y (next_pos_y),
    	.rot   (next_rot),
    	.block (cur_piece),
    	.blk_1 (next_blk_1),
    	.blk_2 (next_blk_2),
    	.blk_3 (next_blk_3),
    	.blk_4 (next_blk_4),
    	.block_width  (next_width),
    	.block_height (next_height)
    );
    
    block_current next_2_block (
        .pos_x        (next_pos_x_2),
        .pos_y        (next_pos_y_2),
        .rot          (next_rot_2),
        .block        (cur_piece_2),
        .blk_1        (next_2_blk_1),
        .blk_2        (next_2_blk_2),
        .blk_3        (next_2_blk_3),
        .blk_4        (next_2_blk_4),
        .block_width  (next_2_width),
        .block_height (next_2_height)
    );
    
    block_current next_3_block (
        .pos_x        (next_pos_x_3),
        .pos_y        (next_pos_y_3),
        .rot          (next_rot_3),
        .block        (cur_piece_3),
        .blk_1        (next_3_blk_1),
        .blk_2        (next_3_blk_2),
        .blk_3        (next_3_blk_3),
        .blk_4        (next_3_blk_4),
        .block_width  (next_3_width),
        .block_height (next_3_height)
    );
    
    row_complete com_row (
        .clk         (clk),
        .rst         (rst),
        .state_rst   (state != `STATE_GAME),
        .beat        (game_over_2),
        .pause       (mode != `MODE_PLAY),
        .delete      (remove_row_en_2 && clear_en_2),
        .game_board  (game_board),
        .ko          (ko),
        .line_sended (line_sended),
        .row         (remove_row_y),
        .enabled     (remove_row_en),
        .send        (send_en),
        .send_line   (send_line)
    );

    row_complete com_row_2 (
        .clk         (clk),
        .rst         (rst),
        .state_rst   (state != `STATE_GAME),
        .beat        (game_over),
        .pause       (mode_2 != `MODE_PLAY),
        .delete      (remove_row_en && clear_en),
        .game_board  (game_board_2),
        .ko          (ko_2),
        .line_sended (line_sended_2),
        .row         (remove_row_y_2),
        .enabled     (remove_row_en_2),
        .send        (send_en_2),
        .send_line  (send_line_2)
    );
    
    row_complete com_row_3 (
        .clk         (clk),
        .rst         (rst),
        .state_rst   (state != `STATE_1P_GAME),
        .beat        (1'b0),
        .pause       (mode_3 != `MODE_PLAY),
        .delete      (1'b0),
        .game_board  (game_board_3),
        .ko          (ko_3),
        .line_sended (line_sended_3),
        .row         (remove_row_y_3),
        .enabled     (remove_row_en_3),
        .send        (send_en_3),
        .send_line   (send_line_3)
    );
    
    state_control state_p1(
        .clk            (clk),
        .CLK            (CLK),
        .rst            (rst),
        .state_rst      (state != `STATE_GAME),
        .time_up        (time_up),
        .game_clk       (game_clk),
        .game_rst       (game_rst),
        .p1_left        (p1_left),
        .p1_right       (p1_right),
        .p1_rotate      (p1_rotate),
        .p1_change      (p1_change),
        .p1_speed       (p1_speed),
        .p1_drop        (p1_drop),
        .enter          (enter),
        .pause          (pause),
        .bomb_pos       (bomb_pos),
        .state          (state),
        .get_line       (send_line_2),
        .cur_piece      (cur_piece),
        .next_block     (next_block),
        .cur_blk_1      (cur_blk_1),
        .cur_blk_2      (cur_blk_2),
        .cur_blk_3      (cur_blk_3),
        .cur_blk_4      (cur_blk_4),
        .next_blk_1     (next_blk_1),
        .next_blk_2     (next_blk_2),
        .next_blk_3     (next_blk_3),
        .next_blk_4     (next_blk_4),
        .cur_width      (cur_width),
        .cur_height     (cur_height),
        .next_width     (next_width),
        .next_height    (next_height),
        .remove_row_y   (remove_row_y),
        .remove_row_en  (remove_row_en),
        .send_en        (send_en_2),
        .game_over      (game_over),
        .clear_en       (clear_en),
        .game_board     (game_board),
        .hold_block     (hold_block),
        .show_block     (show_block),
        .mode           (mode),
        .cur_pos_x      (cur_pos_x),
        .cur_pos_y      (cur_pos_y),
        .cur_rot        (cur_rot),
        .tone_1(tone_1)
    );
    
    state_control_2 state_p2(
            .clk            (clk),
            .CLK            (CLK),
            .rst            (rst),
            .state_rst      (state != `STATE_GAME),
            .time_up        (time_up),
            .game_clk       (game_clk_2),
            .game_rst       (game_rst_2),
            .p1_left        (p2_left),
            .p1_right       (p2_right),
            .p1_rotate      (p2_rotate),
            .p1_change      (p2_change),
            .p1_speed       (p2_speed),
            .p1_drop        (p2_drop),
            .enter          (enter),
            .pause          (pause),
            .bomb_pos       (bomb_pos),
            .state          (state),
            .get_line       (send_line),
            .cur_piece      (cur_piece_2),
            .next_block     (next_block_2),
            .cur_blk_1      (cur_2_blk_1),
            .cur_blk_2      (cur_2_blk_2),
            .cur_blk_3      (cur_2_blk_3),
            .cur_blk_4      (cur_2_blk_4),
            .next_blk_1     (next_2_blk_1),
            .next_blk_2     (next_2_blk_2),
            .next_blk_3     (next_2_blk_3),
            .next_blk_4     (next_2_blk_4),
            .cur_width      (cur_2_width),
            .cur_height     (cur_2_height),
            .next_width     (next_2_width),
            .next_height    (next_2_height),
            .remove_row_y   (remove_row_y_2),
            .remove_row_en  (remove_row_en_2),
            .send_en        (send_en),
            .game_over      (game_over_2),
            .clear_en       (clear_en_2),
            .hold_block     (hold_block_2),
            .show_block     (show_block_2),
            .game_board     (game_board_2),
            .mode           (mode_2),
            .cur_pos_x      (cur_pos_x_2),
            .cur_pos_y      (cur_pos_y_2),
            .cur_rot        (cur_rot_2),
            .tone_2(tone_2)
     );
     
     state_control state_1P(
         .clk            (clk),
         .CLK            (CLK),
         .rst            (rst),
         .state_rst      (state != `STATE_1P_GAME),
         .time_up        (time_up),
         .game_clk       (game_clk_3),
         .game_rst       (game_rst_3),
         .p1_left        (p2_left),
         .p1_right       (p2_right),
         .p1_rotate      (p2_rotate),
         .p1_change      (p2_change),
         .p1_speed       (p2_speed),
         .p1_drop        (p2_drop),
         .enter          (enter),
         .pause          (pause),
         .bomb_pos       (bomb_pos),
         .state          (state),
         .get_line       (send_line),
         .cur_piece      (cur_piece_3),
         .next_block     (next_block_3),
         .cur_blk_1      (cur_3_blk_1),
         .cur_blk_2      (cur_3_blk_2),
         .cur_blk_3      (cur_3_blk_3),
         .cur_blk_4      (cur_3_blk_4),
         .next_blk_1     (next_3_blk_1),
         .next_blk_2     (next_3_blk_2),
         .next_blk_3     (next_3_blk_3),
         .next_blk_4     (next_3_blk_4),
         .cur_width      (cur_3_width),
         .cur_height     (cur_3_height),
         .next_width     (next_3_width),
         .next_height    (next_3_height),
         .remove_row_y   (remove_row_y_3),
         .remove_row_en  (remove_row_en_3),
         .send_en        (1'b0),
         .game_over      (game_over_3),
         .clear_en       (clear_en_3),
         .hold_block     (hold_block_3),
         .show_block     (show_block_3),
         .game_board     (game_board_3),
         .mode           (mode_3),
         .cur_pos_x      (cur_pos_x_3),
         .cur_pos_y      (cur_pos_y_3),
         .cur_rot        (cur_rot_3)
    );
// ========================= end of row_complete =======================================

endmodule