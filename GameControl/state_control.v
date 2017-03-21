`include "global.v"

module state_control(
    input                               clk,
    input                               CLK,
    input                               rst,
    input wire                          state_rst,
    input wire                          time_up,
    input wire                          game_clk,
    input wire                          p1_left,
    input wire                          p1_right,
    input wire                          p1_rotate,
    input wire                          p1_change,
    input wire                          p1_speed,
    input wire                          p1_drop,
    input wire                          enter,
    input wire                          pause,
    input wire [3:0]                    bomb_pos,
    input wire [2:0]                    state,
    input wire [`BITS_Y_POS-1:0]        get_line,
    input wire [`BITS_PER_BLOCK-1:0]    next_block,
    input wire [`BITS_BLK_POS-1:0]      cur_blk_1,
    input wire [`BITS_BLK_POS-1:0]      cur_blk_2,
    input wire [`BITS_BLK_POS-1:0]      cur_blk_3,
    input wire [`BITS_BLK_POS-1:0]      cur_blk_4,
    input wire [`BITS_BLK_POS-1:0]      next_blk_1,
    input wire [`BITS_BLK_POS-1:0]      next_blk_2,
    input wire [`BITS_BLK_POS-1:0]      next_blk_3,
    input wire [`BITS_BLK_POS-1:0]      next_blk_4,
    input wire [2:0]                    cur_width,
    input wire [2:0]                    cur_height,
    input wire [2:0]                    next_width,
    input wire [2:0]                    next_height,
    input wire [`BITS_Y_POS-1:0]        remove_row_y,
    input wire                          remove_row_en,
    input wire                          send_en,
    output reg                          game_rst,
    output reg                          clear_en,
    output wire                         game_over,
    output reg [`BITS_PER_BLOCK-1:0]    cur_piece,
    output reg [`BITS_PER_BLOCK-1:0]    hold_block,
    output reg [`BITS_PER_BLOCK-1:0]    show_block,
    output reg [`BLOCKS_ROW*`BLOCKS_COL-1:0] game_board,
    output reg [`MODE_BITS-1:0]         mode,
    output reg [`BITS_X_POS-1:0]        cur_pos_x,
    output reg [`BITS_Y_POS-1:0]        cur_pos_y,
    output reg [`BITS_ROT-1:0]          cur_rot,
    output [31:0]tone_1
    //output [31:0]tone_1_2
    //output [31:0]tone_2
);
    wire [3:0] bomb = `BLOCKS_ROW * (`BLOCKS_COL-1-get_line) + bomb_pos;
    wire reach = game_board[next_blk_1] || game_board[next_blk_2] || game_board[next_blk_3] || game_board[next_blk_4]
                 || ((next_blk_1) >= `BLOCKS_ROW * (`BLOCKS_COL-get_line)) || ((next_blk_2) >= `BLOCKS_ROW * (`BLOCKS_COL-get_line))
                 || ((next_blk_3) >= `BLOCKS_ROW * (`BLOCKS_COL-get_line)) || ((next_blk_4) >= `BLOCKS_ROW * (`BLOCKS_COL-get_line));
    assign game_over = (cur_pos_y == 0) && ( game_board[cur_blk_1] || game_board[cur_blk_2] || game_board[cur_blk_3] || game_board[cur_blk_4]
                     || ((cur_blk_1) > `BLOCKS_ROW * (`BLOCKS_COL-get_line)) || ((cur_blk_2) > `BLOCKS_ROW * (`BLOCKS_COL-get_line))
                     || ((cur_blk_3) > `BLOCKS_ROW * (`BLOCKS_COL-get_line)) || ((cur_blk_4) > `BLOCKS_ROW * (`BLOCKS_COL-get_line)) );

    reg [31:0] timer;
    
    reg [`BITS_PER_BLOCK-1:0] prev_block;
	reg [`BITS_Y_POS-1:0] shift_row;
    reg [`BITS_Y_POS-1:0] add_row;
    reg [`BITS_Y_POS-1:0] clear_row;
    reg [`MODE_BITS-1:0]  prev_mode;
    
/* ========================= main game control part ================================== */
    
    reg isrot;
    wire isrot_1;
    wire clk21;
    wire [31:0]t1;
    clock_divider ckck(.clk21(clk21),.clk(CLK));
    OnePulse opop(.signal_single_pulse(isrot_1),
        .signal(isrot),
        .clock(clk21));
    //assign t1 = (isrot_1)?32'd150:32'd20000;
    
    reg ismov;
    wire ismov_1;
    wire [31:0]t2;
    //wire clk22;
    OnePulse opop1(.signal_single_pulse(ismov_1),
        .signal(ismov),
        .clock(clk21));
    //assign t2 = (ismov_1)?32'd700:32'd20000;
    
    assign tone_1=(isrot_1)?32'd150:(ismov_1)?32'd700:32'd20000;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            reset_gameboard();
        end else if(time_up || state_rst) begin
            reset_gameboard();
        end else begin
            if(timer < `DROP_TIMER) begin
                timer <= timer+1;
            end
            game_rst <= 0;
            if(mode == `MODE_IDLE && enter) begin
                game_start();
            end else if(mode == `MODE_PLAY && game_over) begin
                /* start new block and clear the bomb */
                add_game_board();
                cur_piece <= 0;
                game_start();
            end else if(mode == `MODE_PLAY && pause) begin
                /* save the prev mode */
                mode <= `MODE_PAUSE;
                prev_mode <= mode;
            end else if(mode == `MODE_PAUSE && enter) begin
                /* back to prev mode */
                mode <= prev_mode;
            end else if(mode == `MODE_PLAY) begin
                if (game_clk) begin
                   /* y axis plus one per 0.25s */
                    move_down();
                end else if (p1_left) begin
                    /* x axis - 1 */
                    move_left();
                end else if (p1_right) begin
                    /* x axis + 1 */
                    move_right();
                end else if (p1_rotate) begin
                    /* rot + 1 */
                    rotate();
                end else if (p1_speed) begin
                    /* y axis + 1 */
                    move_down();
                end else if (p1_change) begin
                    /* switch with hold block */
                    change_block();
                end else if (p1_drop && timer == `DROP_TIMER) begin
                    /* change to drop mode */
                    drop_to_bottom();
                end else if (remove_row_en) begin
                    remove_row();
                end else if (send_en) begin
                    /* the other player is remove_en */
                    mode    <= `MODE_GET;
                    /* shift up from the bottom */
                    add_row <= 0;
                end
            end else if(mode == `MODE_DROP) begin
                /* keep move down until get new block */
                if (game_rst && !enter) begin
                    mode <= `MODE_PLAY;
                end else begin
                    move_down();
                end
            end else if(mode == `MODE_SHIFT) begin
                /* shift down until all the row are shift successful */
                if (shift_row == 0) begin
                    game_board[0 +: `BLOCKS_ROW] <= 0;
                    if(clear_en) clear_bomb();
                    else      mode <= `MODE_PLAY;
                end else begin
                    game_board[shift_row*`BLOCKS_ROW+: `BLOCKS_ROW] <= game_board[(shift_row - 1)*`BLOCKS_ROW +: `BLOCKS_ROW];
                    shift_row <= shift_row - 1;
                end
            end else if(mode == `MODE_CLEAR) begin
                /* clear the bomb drom the bottom */
                if (clear_row == 0) begin
                    game_board[0 +: `BLOCKS_ROW] <= 0;
                    mode <= `MODE_PLAY;
                end else begin
                    game_board[clear_row*`BLOCKS_ROW+: `BLOCKS_ROW] <= game_board[(clear_row - 1)*`BLOCKS_ROW +: `BLOCKS_ROW];
                    clear_row <= clear_row - 1;
                end
            end else if(mode == `MODE_GET) begin
                /* shift up from the bottom with the bomb */
                if (add_row == `BLOCKS_COL-1) begin
                    game_board[(`BLOCKS_COL-1)*`BLOCKS_ROW +: `BLOCKS_ROW] <= 0;
                    game_board[(`BLOCKS_COL-1)*`BLOCKS_ROW + bomb_pos] <= 1;
                    mode <= `MODE_PLAY;
                end else begin
                    game_board[add_row*`BLOCKS_ROW +: `BLOCKS_ROW] <= game_board[(add_row + 1)*`BLOCKS_ROW +: `BLOCKS_ROW];
                    add_row <= add_row + 1;
                end
            end
        end
    end 
        
    /* ========================== end of game control ==================================== */   
    
        
    /* initialize */
    task game_start;
        begin
            isrot <= 1'b0;
            ismov <= 1'b0;
            mode        <= `MODE_PLAY;
            game_board <= 0;
            get_new_block();
            if(next_block == 3'd7) cur_piece <= 3'd1;
            else cur_piece <= (next_block+1)%8;
        end
    endtask
    /* reset the timer, get random block and start from the middle top of the board */
    task get_new_block;
        begin
            isrot <= 1'b0;
            ismov <= 1'b0;
            timer <= 0;
            cur_piece  <= show_block;
            if(next_block == 3'd0) show_block <= 3'd1;
            else show_block <= next_block;
            /* appear at the middle of the board */
            cur_pos_x <= (`BLOCKS_ROW / 2) - 1;
            cur_pos_y <= 0;
            cur_rot <= 0;
            game_rst <= 1;
        end
    endtask
    
    /* reset the gameboard when needed */
    task reset_gameboard;
        begin
            timer      <= 0;
            mode       <= `MODE_IDLE;
            game_board <= 0;
            shift_row  <= 0;
            cur_piece  <= 0;
            cur_pos_x  <= 0;
            cur_pos_y  <= 0;
            cur_rot    <= 0;
            hold_block <= 0;
            show_block <= 0;
        end
    endtask        
    /* shift down from the complete row */
    task remove_row;
        begin
            isrot <= 1'b0;
            ismov <= 1'b1;
            mode      <= `MODE_SHIFT;
            shift_row <= remove_row_y;
        end
    endtask
    
    /* shift up */
    task get_row;
        begin
            isrot <= 1'b0;
            ismov <= 1'b0;
            mode <= `MODE_GET;
            add_row <= 0;
        end
    endtask
        
    /* shift down from the bottom */
    task clear_bomb;
        begin
            isrot <= 1'b0;
            ismov <= 1'b0;
            mode <= `MODE_CLEAR;
            clear_row <= `BLOCKS_COL-get_line-1;
        end
    endtask
    
    /* add falling blocks to the gameboard and store it with 1s */
    task add_game_board;
        begin
            isrot <= 1'b0;
            ismov <= 1'b0;
            game_board[cur_blk_1] <= 1;
            game_board[cur_blk_2] <= 1;
            game_board[cur_blk_3] <= 1;
            game_board[cur_blk_4] <= 1;
        end
    endtask
    
    
    
/* =========== if it is able to do the user's input command =========== */
    
    /* whether able to move left, yes then x axis minus one */
    task move_left;
        begin
            isrot <= 1'b0;
            ismov <= 1'b0;
            if (cur_pos_x > 0 && !reach) begin
                cur_pos_x <= cur_pos_x - 1;
            end
        end
    endtask
    
    /* whether able to move right, yes then x axis plus one */
    task move_right;
        begin
            isrot <= 1'b0;
            ismov <= 1'b0;
            if (cur_pos_x + cur_width < `BLOCKS_ROW && !reach) begin
                cur_pos_x <= cur_pos_x + 1;
            end
        end
    endtask
    
    /* whether able to rotate, yes then rotate */
    task rotate;
        begin
            if (cur_pos_x + next_width <= `BLOCKS_ROW && cur_pos_y + next_height <= `BLOCKS_COL && !reach) begin
                isrot <= 1'b1;
                ismov <= 1'b0;
                cur_rot <= cur_rot + 1;
            end
        end
    endtask
    
    
    /* whether able to move down, yes then current y axis plus one */
    task move_down;
        begin
            isrot <= 1'b0;
            ismov <= 1'b0;
            if (cur_pos_y + cur_height < `BLOCKS_COL && !reach) begin
                cur_pos_y <= cur_pos_y + 1;
            end else begin
                if(((next_blk_1 >= `BLOCKS_ROW * (`BLOCKS_COL-get_line)) && game_board[next_blk_1]) || 
                    ((next_blk_2 >= `BLOCKS_ROW * (`BLOCKS_COL-get_line)) && game_board[next_blk_2]) ||
                    ((next_blk_3 >= `BLOCKS_ROW * (`BLOCKS_COL-get_line)) && game_board[next_blk_3]) ||
                    ((next_blk_4 >= `BLOCKS_ROW * (`BLOCKS_COL-get_line)) && game_board[next_blk_4])) begin
                    clear_en <= 1;
                end else clear_en <= 0;
                add_game_board();
                get_new_block();
            end
        end
    endtask
    
    /* hold the block and switch */
    task change_block;
        begin
            isrot <= 1'b0;
            ismov <= 1'b0;
            if(!hold_block) begin
               /* first time hold*/
                hold_block <= cur_piece;
                get_new_block();
            end else begin
                /* swap the block here */
                hold_block <= cur_piece;
                cur_piece  <= hold_block;
            end
        end
    endtask
    
    /* change the mode to drop mode until the block reach the bottom */
    task drop_to_bottom;
        begin
            isrot <= 1'b0;
            ismov <= 1'b0;
            mode <= `MODE_DROP;
        end
    endtask

            
endmodule