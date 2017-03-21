`include "global.v"

module pixel_gen
(
  input wire                                 clk,
  input wire [9:0]                           h_cnt,
  input wire [9:0]                           v_cnt,
  input wire                                 rst,
  input wire [2:0]                           state,
  input wire [`BITS_Y_POS-1:0]               get_line,
  input wire [`BITS_Y_POS-1:0]               get_line_2,
  input wire [`BITS_PER_BLOCK-1:0]           cur_piece,
  input wire [`BITS_PER_BLOCK-1:0]           hold_block,
  input wire [`BITS_PER_BLOCK-1:0]           show_block,
  input wire [`BITS_BLK_POS-1:0]             cur_blk_1,
  input wire [`BITS_BLK_POS-1:0]             cur_blk_2,
  input wire [`BITS_BLK_POS-1:0]             cur_blk_3,
  input wire [`BITS_BLK_POS-1:0]             cur_blk_4,
  input wire [(`BLOCKS_ROW*`BLOCKS_COL)-1:0] game_board,
  input wire [`BITS_PER_BLOCK-1:0]           cur_piece_2,
  input wire [`BITS_PER_BLOCK-1:0]           hold_block_2,
  input wire [`BITS_PER_BLOCK-1:0]           show_block_2,
  input wire [`BITS_BLK_POS-1:0]             cur_2_blk_1,
  input wire [`BITS_BLK_POS-1:0]             cur_2_blk_2,
  input wire [`BITS_BLK_POS-1:0]             cur_2_blk_3,
  input wire [`BITS_BLK_POS-1:0]             cur_2_blk_4,
  input wire [(`BLOCKS_ROW*`BLOCKS_COL)-1:0] game_board_2,
  input wire [`BITS_PER_BLOCK-1:0]           cur_piece_3,
  input wire [`BITS_PER_BLOCK-1:0]           hold_block_3,
  input wire [`BITS_PER_BLOCK-1:0]           show_block_3,
  input wire [`BITS_BLK_POS-1:0]             cur_3_blk_1,
  input wire [`BITS_BLK_POS-1:0]             cur_3_blk_2,
  input wire [`BITS_BLK_POS-1:0]             cur_3_blk_3,
  input wire [`BITS_BLK_POS-1:0]             cur_3_blk_4,
  input wire [(`BLOCKS_ROW*`BLOCKS_COL)-1:0] game_board_3,
  input wire [2:0]                           ko,
  input wire [2:0]                           ko_2,
  input wire                                 valid,
  output wire [3:0]                          vgaRed,
  output wire [3:0]                          vgaGreen,
  output wire [3:0]                          vgaBlue
);

  reg [11:0] RGB;
  reg [25:0] count;
  reg [2:0]  diff;

  assign vgaRed   = RGB[11:8];
  assign vgaGreen = RGB[7:4];
  assign vgaBlue  = RGB[3:0];

  wire [9:0] cur_blk_index   = ((h_cnt-`BOARD_X)/`BLOCK_SIZE) + (((v_cnt-`BOARD_Y)/`BLOCK_SIZE)*`BLOCKS_ROW);
  wire [9:0] cur_blk_index_2 = ((h_cnt-`BOARD_X_2)/`BLOCK_SIZE) + (((v_cnt-`BOARD_Y_2)/`BLOCK_SIZE)*`BLOCKS_ROW);
  wire [9:0] cur_blk_index_3 = ((h_cnt-`BOARD_X_3)/`BLOCK_SIZE) + (((v_cnt-`BOARD_Y_3)/`BLOCK_SIZE)*`BLOCKS_ROW);
    
    always @(posedge clk) begin
      if (rst) begin
        count <= 26'd0;
      end else begin
        count <= count + 1;
      end
    end
  
    assign DCLK = count[25];

    always @ (posedge DCLK)begin
      if(rst) begin
        diff <= 0;
      end else begin
        if(diff == 0)         diff <= 3'd6;
        else if(diff == 3'd6) diff <= 0;
      end
    end

    always @(*) begin
        if(!valid) RGB = 12'h0;
        else begin
            if(state == `STATE_READY) begin
                if(!DCLK)begin
                    if(((h_cnt >= 160 && h_cnt <= 240) && (v_cnt >= 120 && v_cnt <= 140))||((h_cnt >= 160 && h_cnt <= 180) && (v_cnt >= 140 && v_cnt <= 220))||((h_cnt >= 180 && h_cnt <= 240) && (v_cnt >= 160 && v_cnt <= 180))) // F
                      RGB = 12'h12f;
                    else if(((h_cnt >= 260 && h_cnt <= 280) && (v_cnt >= 120 && v_cnt <= 220))||((h_cnt >= 320 && h_cnt <= 340) && (v_cnt >= 120 && v_cnt <= 220))||((h_cnt >= 280 && h_cnt <= 320) && (v_cnt >= 200 && v_cnt <= 220))) // U
                      RGB = 12'h16f;
                    else if(((h_cnt >= 360 && h_cnt <= 380) && (v_cnt >= 120 && v_cnt <= 220))||((h_cnt >= 440 && h_cnt <= 460) && (v_cnt >= 120 && v_cnt <= 220))||((h_cnt >= 380 && h_cnt <= 400) && (v_cnt >= 140 && v_cnt <= 160))||((h_cnt >= 400 && h_cnt <= 420) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 420 && h_cnt <= 440) && (v_cnt >= 180 && v_cnt <= 200)))
                      RGB = 12'h1af;
                    else if(((h_cnt >= 60  && h_cnt <= 160) && (v_cnt >= 260 && v_cnt <= 280))||((h_cnt >= 100 && h_cnt <= 120) && (v_cnt >= 280 && v_cnt <= 360)))
                      RGB = 12'h71f;
                    else if(((h_cnt >= 180 && h_cnt <= 200) && (v_cnt >= 260 && v_cnt <= 360))||((h_cnt >= 200 && h_cnt <= 260) && (v_cnt >= 260 && v_cnt <= 280))||((h_cnt >= 200 && h_cnt <= 260) && (v_cnt >= 300 && v_cnt <= 320))||((h_cnt >= 200 && h_cnt <= 260) && (v_cnt >= 340 && v_cnt <= 360)))
                      RGB = 12'h75f;
                    else if(((h_cnt >= 280 && h_cnt <= 380) && (v_cnt >= 260 && v_cnt <= 280))||((h_cnt >= 320 && h_cnt <= 340) && (v_cnt >= 280 && v_cnt <= 360)))
                      RGB = 12'h79f;
                    else if(((h_cnt >= 400 && h_cnt <= 420) && (v_cnt >= 260 && v_cnt <= 360))||((h_cnt >= 460 && h_cnt <= 480) && (v_cnt >= 260 && v_cnt <= 320))||((h_cnt >= 420 && h_cnt <= 460) && (v_cnt >= 260 && v_cnt <= 280))||((h_cnt >= 420 && h_cnt <= 460) && (v_cnt >= 300 && v_cnt <= 320))||((h_cnt >= 440 && h_cnt <= 460) && (v_cnt >= 320 && v_cnt <= 340))||((h_cnt >= 460 && h_cnt <= 480) && (v_cnt >= 340 && v_cnt <= 360)))
                      RGB = 12'h7df;
                    else if(((h_cnt >= 500 && h_cnt <= 520) && (v_cnt >= 260 && v_cnt <= 360)))
                      RGB = 12'h7d2;
                    else if(((h_cnt >= 540 && h_cnt <= 620) && (v_cnt >= 260 && v_cnt <= 280))||((h_cnt >= 540 && h_cnt <= 560) && (v_cnt >= 280 && v_cnt <= 300))||((h_cnt >= 540 && h_cnt <= 620) && (v_cnt >= 300 && v_cnt <= 320))||((h_cnt >= 600 && h_cnt <= 620) && (v_cnt >= 320 && v_cnt <= 340))||((h_cnt >= 540 && h_cnt <= 620) && (v_cnt >= 340 && v_cnt <= 360)))
                      RGB = 12'h090;
                    else 
                      RGB = 12'h0; 
                  end else begin
                    RGB = 12'h0;
                  end
              end else if(state == `STATE_P1_WINS) begin
                  if(DCLK)begin
                    if(((h_cnt >= 30 && h_cnt <= 50) && (v_cnt >= 160 && v_cnt <= 240))||((h_cnt >= 50 && h_cnt <= 70) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 70 && h_cnt <= 90) && (v_cnt >= 160 && v_cnt <= 240))||((h_cnt >= 90 && h_cnt <= 110) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 110 && h_cnt <= 130) && (v_cnt >= 160 && v_cnt <= 240)))
                      RGB = 12'hd20;    
                    else if(((h_cnt >= 150 && h_cnt <= 170) && (v_cnt >= 160 && v_cnt <= 260)))
                      RGB = 12'hd60; 
                    else if(((h_cnt >= 190 && h_cnt <= 210) && (v_cnt >= 160 && v_cnt <= 260))||((h_cnt >= 210 && h_cnt <= 230) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 230 && h_cnt <= 250) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 250 && h_cnt <= 270) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 270 && h_cnt <= 290) && (v_cnt >= 160 && v_cnt <= 260)))
                      RGB = 12'hde0; 
                    else if(((h_cnt >= 345 && h_cnt <= 365) && (v_cnt >= 160 && v_cnt <= 260))||((h_cnt >= 365 && h_cnt <= 405) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h1d0; 
                    else if(((h_cnt >= 415 && h_cnt <= 435) && (v_cnt >= 180 && v_cnt <= 240))||((h_cnt >= 435 && h_cnt <= 455) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 435 && h_cnt <= 455) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 455 && h_cnt <= 475) && (v_cnt >= 180 && v_cnt <= 240)))
                      RGB = 12'h1df; 
                    else if(((h_cnt >= 485 && h_cnt <= 545) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 485 && h_cnt <= 505) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 485 && h_cnt <= 545) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 525 && h_cnt <= 545) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 485 && h_cnt <= 545) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h11f; 
                    else if(((h_cnt >= 555 && h_cnt <= 615) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 555 && h_cnt <= 575) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 555 && h_cnt <= 615) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 555 && h_cnt <= 575) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 555 && h_cnt <= 615) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h609; 
                    else
                      RGB = 12'h0; 
                end else begin
                    if(((h_cnt >= 30 && h_cnt <= 50) && (v_cnt >= 160 && v_cnt <= 240))||((h_cnt >= 50 && h_cnt <= 70) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 70 && h_cnt <= 90) && (v_cnt >= 160 && v_cnt <= 240))||((h_cnt >= 90 && h_cnt <= 110) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 110 && h_cnt <= 130) && (v_cnt >= 160 && v_cnt <= 240)))
                      RGB = 12'hfff;    
                    else if(((h_cnt >= 150 && h_cnt <= 170) && (v_cnt >= 160 && v_cnt <= 260)))
                      RGB = 12'hfff; 
                    else if(((h_cnt >= 190 && h_cnt <= 210) && (v_cnt >= 160 && v_cnt <= 260))||((h_cnt >= 210 && h_cnt <= 230) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 230 && h_cnt <= 250) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 250 && h_cnt <= 270) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 270 && h_cnt <= 290) && (v_cnt >= 160 && v_cnt <= 260)))
                      RGB = 12'hfff; 
                    else if(((h_cnt >= 345 && h_cnt <= 365) && (v_cnt >= 160 && v_cnt <= 260))||((h_cnt >= 365 && h_cnt <= 405) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h0; 
                    else if(((h_cnt >= 415 && h_cnt <= 435) && (v_cnt >= 180 && v_cnt <= 240))||((h_cnt >= 435 && h_cnt <= 455) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 435 && h_cnt <= 455) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 455 && h_cnt <= 475) && (v_cnt >= 180 && v_cnt <= 240)))
                      RGB = 12'h0; 
                    else if(((h_cnt >= 485 && h_cnt <= 545) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 485 && h_cnt <= 505) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 485 && h_cnt <= 545) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 525 && h_cnt <= 545) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 485 && h_cnt <= 545) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h0; 
                    else if(((h_cnt >= 555 && h_cnt <= 615) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 555 && h_cnt <= 575) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 555 && h_cnt <= 615) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 555 && h_cnt <= 575) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 555 && h_cnt <= 615) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h0;
                    else 
                      RGB = 12'h360; 
                  end
              end else if(state == `STATE_P2_WINS) begin
                  if(DCLK)begin
                    if(((h_cnt >= 350 && h_cnt <= 370) && (v_cnt >= 160 && v_cnt <= 240))||((h_cnt >= 370 && h_cnt <= 390) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 390 && h_cnt <= 410) && (v_cnt >= 160 && v_cnt <= 240))||((h_cnt >= 410 && h_cnt <= 430) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 430 && h_cnt <= 450) && (v_cnt >= 160 && v_cnt <= 240)))
                      RGB = 12'hd20;    
                    else if(((h_cnt >= 470 && h_cnt <= 490) && (v_cnt >= 160 && v_cnt <= 260)))
                      RGB = 12'hd60; 
                    else if(((h_cnt >= 510 && h_cnt <= 530) && (v_cnt >= 160 && v_cnt <= 260))||((h_cnt >= 530 && h_cnt <= 550) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 550 && h_cnt <= 570) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 570 && h_cnt <= 590) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 590 && h_cnt <= 610) && (v_cnt >= 160 && v_cnt <= 260)))
                      RGB = 12'hde0; 
                    else if(((h_cnt >= 95  && h_cnt <= 115) && (v_cnt >= 160 && v_cnt <= 260))||((h_cnt >= 115 && h_cnt <= 155) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h1d0; 
                    else if(((h_cnt >= 165 && h_cnt <= 185) && (v_cnt >= 180 && v_cnt <= 240))||((h_cnt >= 185 && h_cnt <= 205) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 185 && h_cnt <= 205) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 205 && h_cnt <= 225) && (v_cnt >= 180 && v_cnt <= 240)))
                      RGB = 12'h1df; 
                    else if(((h_cnt >= 235 && h_cnt <= 295) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 235 && h_cnt <= 255) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 235 && h_cnt <= 295) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 275 && h_cnt <= 295) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 235 && h_cnt <= 295) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h11f; 
                    else if(((h_cnt >= 305 && h_cnt <= 365) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 305 && h_cnt <= 325) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 305 && h_cnt <= 365) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 305 && h_cnt <= 325) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 305 && h_cnt <= 365) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h609; 
                    else
                      RGB = 12'h0; 
                end else begin
                    if(((h_cnt >= 350 && h_cnt <= 370) && (v_cnt >= 160 && v_cnt <= 240))||((h_cnt >= 370 && h_cnt <= 390) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 390 && h_cnt <= 410) && (v_cnt >= 160 && v_cnt <= 240))||((h_cnt >= 410 && h_cnt <= 430) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 430 && h_cnt <= 450) && (v_cnt >= 160 && v_cnt <= 240)))
                      RGB = 12'hfff;    
                    else if(((h_cnt >= 470 && h_cnt <= 490) && (v_cnt >= 160 && v_cnt <= 260)))
                      RGB = 12'hfff; 
                    else if(((h_cnt >= 510 && h_cnt <= 530) && (v_cnt >= 160 && v_cnt <= 260))||((h_cnt >= 530 && h_cnt <= 550) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 550 && h_cnt <= 570) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 570 && h_cnt <= 590) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 590 && h_cnt <= 610) && (v_cnt >= 160 && v_cnt <= 260)))
                      RGB = 12'hfff; 
                    else if(((h_cnt >= 25  && h_cnt <= 45) && (v_cnt >= 160 && v_cnt <= 260))||((h_cnt >= 45 && h_cnt <= 85) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h0; 
                    else if(((h_cnt >= 95  && h_cnt <= 155) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 95 && h_cnt <= 155) && (v_cnt >= 240 && v_cnt <= 260))||((h_cnt >= 95 && h_cnt <= 115) && (v_cnt >= 180 && v_cnt <= 240))||((h_cnt >= 135 && h_cnt <= 155) && (v_cnt >= 180 && v_cnt <= 240)))
                      RGB = 12'h0; 
                    else if(((h_cnt >= 165 && h_cnt <= 225) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 165 && h_cnt <= 185) && (v_cnt >= 180 && v_cnt <= 200))||((h_cnt >= 165 && h_cnt <= 225) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 205 && h_cnt <= 225) && (v_cnt >= 220 && v_cnt <= 240))||((h_cnt >= 165 && h_cnt <= 225) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h0; 
                    else if(((h_cnt >= 235 && h_cnt <= 255) && (v_cnt >= 160 && v_cnt <= 260))||((h_cnt >= 255 && h_cnt <= 295) && (v_cnt >= 160 && v_cnt <= 180))||((h_cnt >= 255 && h_cnt <= 295) && (v_cnt >= 200 && v_cnt <= 220))||((h_cnt >= 255 && h_cnt <= 295) && (v_cnt >= 240 && v_cnt <= 260)))
                      RGB = 12'h0; 
                    else
                      RGB = 12'h360; 
                end
            end else if(state == `STATE_1P_GAME) begin
                if(((h_cnt >= 148 && h_cnt <= 151) && (v_cnt >= 140 && v_cnt <= 160))||       // next 1 next 2
                   ((h_cnt >= 161 && h_cnt <= 164) && (v_cnt >= 140 && v_cnt <= 160))||
                   ((h_cnt >= 151 && h_cnt <= 154) && (v_cnt >= 144 && v_cnt <= 148))||
                   ((h_cnt >= 154 && h_cnt <= 157) && (v_cnt >= 148 && v_cnt <= 152))||
                   ((h_cnt >= 157 && h_cnt <= 161) && (v_cnt >= 152 && v_cnt <= 156)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 166 && h_cnt <= 182) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 166 && h_cnt <= 182) && (v_cnt >= 148 && v_cnt <= 152))||
                            ((h_cnt >= 166 && h_cnt <= 182) && (v_cnt >= 156 && v_cnt <= 160))||
                            ((h_cnt >= 166 && h_cnt <= 169) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 166 && h_cnt <= 169) && (v_cnt >= 152 && v_cnt <= 156)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 184 && h_cnt <= 187) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 187 && h_cnt <= 190) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 190 && h_cnt <= 193) && (v_cnt >= 148 && v_cnt <= 152))||
                            ((h_cnt >= 193 && h_cnt <= 196) && (v_cnt >= 152 && v_cnt <= 156))||
                            ((h_cnt >= 196 && h_cnt <= 199) && (v_cnt >= 156 && v_cnt <= 160))||
                            ((h_cnt >= 196 && h_cnt <= 199) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 193 && h_cnt <= 196) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 187 && h_cnt <= 190) && (v_cnt >= 152 && v_cnt <= 156))||
                            ((h_cnt >= 184 && h_cnt <= 187) && (v_cnt >= 156 && v_cnt <= 160)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 201 && h_cnt <= 216) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 207 && h_cnt <= 210) && (v_cnt >= 144 && v_cnt <= 160)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 428 && h_cnt <= 431) && (v_cnt >= 320 && v_cnt <= 340))||
                            ((h_cnt >= 440 && h_cnt <= 443) && (v_cnt >= 320 && v_cnt <= 340))||
                            ((h_cnt >= 431 && h_cnt <= 440) && (v_cnt >= 328 && v_cnt <= 332)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 445 && h_cnt <= 460) && (v_cnt >= 320 && v_cnt <= 324))||
                            ((h_cnt >= 445 && h_cnt <= 460) && (v_cnt >= 336 && v_cnt <= 340))||
                            ((h_cnt >= 445 && h_cnt <= 448) && (v_cnt >= 324 && v_cnt <= 336))||
                            ((h_cnt >= 457 && h_cnt <= 460) && (v_cnt >= 324 && v_cnt <= 336)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 462 && h_cnt <= 465) && (v_cnt >= 320 && v_cnt <= 340))||
                            ((h_cnt >= 466 && h_cnt <= 477) && (v_cnt >= 336 && v_cnt <= 340)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 479 && h_cnt <= 491) && (v_cnt >= 320 && v_cnt <= 324))||
                            ((h_cnt >= 479 && h_cnt <= 491) && (v_cnt >= 336 && v_cnt <= 340))||
                            ((h_cnt >= 479 && h_cnt <= 482) && (v_cnt >= 324 && v_cnt <= 336))||
                            ((h_cnt >= 491 && h_cnt <= 494) && (v_cnt >= 324 && v_cnt <= 336)))begin
                    RGB = 12'hfff;
                end else if( h_cnt >= `BOARD_X_3 && h_cnt <= `BOARD_X_3 + `GAMEBOARD_WIDTH  && 
                    v_cnt <= `BOARD_Y_3 + `GAMEBOARD_HEIGHT && v_cnt >= `BOARD_Y_3) begin
                    if(h_cnt == `BOARD_X_3 || h_cnt == `BOARD_X_3 + `GAMEBOARD_WIDTH || 
                       v_cnt == `BOARD_Y_3 || v_cnt == `BOARD_Y_3 + `GAMEBOARD_HEIGHT) begin 
                        RGB = 12'h444;
                    end else begin
                        if(((h_cnt+1)%20 == 0) || ((v_cnt+11)%20 == 0)) begin
                           RGB = 12'h111;
                        end else begin
                            if(cur_blk_index_3 == cur_3_blk_1 || cur_blk_index_3 == cur_3_blk_2 ||
                               cur_blk_index_3 == cur_3_blk_3 || cur_blk_index_3 == cur_3_blk_4) begin
                                if(((h_cnt+1)%20 == 0) || ((v_cnt+11)%20 == 0) || ((h_cnt+2)%20 == 0) || ((v_cnt+12)%20 == 0)|| 
                                   ((h_cnt+3)%20 == 0) || ((v_cnt+13)%20 == 0) || ((h_cnt+4)%20 == 0) || ((v_cnt+14)%20 == 0) ) begin
                                    case(cur_piece_3)
                                        3'd0: RGB = 12'haab;
                                        3'd1: RGB = 12'h07b;
                                        3'd2: RGB = 12'hcb0;
                                        3'd3: RGB = 12'h74a;
                                        3'd4: RGB = 12'h292;
                                        3'd5: RGB = 12'hc04;
                                        3'd6: RGB = 12'h10c;
                                        3'd7: RGB = 12'hc70; 
                                    endcase
                                end else begin
                                    case(cur_piece_3)
                                        3'd0: RGB = 12'haab;
                                        3'd1: RGB = 12'h29d;
                                        3'd2: RGB = 12'hed2;
                                        3'd3: RGB = 12'h96c;
                                        3'd4: RGB = 12'h4b4;
                                        3'd5: RGB = 12'he26;
                                        3'd6: RGB = 12'h43f;
                                        3'd7: RGB = 12'he91; 
                                    endcase
                                end
                            end else begin
                                RGB = game_board_3[cur_blk_index_3] ? 12'h444 : 12'haab;
                            end
                        end
                    end
                end else if(h_cnt >= 420 && h_cnt < 500 && v_cnt <= 430 && v_cnt >= 350) begin
                    case(hold_block_3)
                        3'd0: begin
                            RGB = 12'h000;
                        end
                        3'd1: begin 
                            if(h_cnt >= 450 && h_cnt < 470 && v_cnt >= 350 && v_cnt <= 430) begin
                                RGB = 12'h29d;
                            end else RGB = 12'h000;
                        end
                        3'd2: begin
                            if(h_cnt >= 440 && h_cnt < 480 && v_cnt >= 370 && v_cnt < 410) begin
                                RGB = 12'hed2;
                            end else RGB = 12'h000; 
                        end        
                        3'd3: begin
                            if((h_cnt >= 450 && h_cnt < 470 && v_cnt >= 370 && v_cnt < 390) ||
                               (h_cnt >= 430 && h_cnt < 490 && v_cnt >= 390 && v_cnt < 410)) begin
                                RGB = 12'h96c;
                            end else RGB = 12'h000;
                        end
                        3'd4: begin
                            if((h_cnt >= 450 && h_cnt < 490 && v_cnt >= 370 && v_cnt < 390) ||
                               (h_cnt >= 430 && h_cnt < 470 && v_cnt >= 390 && v_cnt < 410)) begin
                                RGB = 12'h4b4;
                            end else RGB = 12'h000;
                        end
                        3'd5: begin
                            if((h_cnt >= 430 && h_cnt < 490 && v_cnt >= 370 && v_cnt < 390) ||
                              (h_cnt >= 450 && h_cnt < 490 && v_cnt >= 390 && v_cnt < 410)) begin
                                RGB = 12'he26;
                            end else RGB = 12'h000;
                        end
                        3'd6: begin
                            if((h_cnt >= 440 && h_cnt < 460 && v_cnt >= 400 && v_cnt < 420) ||
                               (h_cnt >= 560 && h_cnt < 480 && v_cnt >= 360 && v_cnt < 420)) begin
                                RGB = 12'h43f;
                            end else RGB = 12'h000;
                        end
                        3'd7: begin
                            if((h_cnt >= 460 && h_cnt < 480 && v_cnt >= 400 && v_cnt < 420) ||
                               (h_cnt >= 440 && h_cnt < 460 && v_cnt >= 360 && v_cnt < 420)) begin
                                RGB = 12'he91; 
                            end else RGB = 12'h000;
                        end
                    endcase
                end else if(h_cnt >= 140 && h_cnt < 220 && v_cnt <= 130 && v_cnt > `BOARD_Y) begin
                    case(show_block_3)
                        3'd0: begin
                            RGB = 12'h000;
                        end
                        3'd1: begin 
                            if(h_cnt >= 170 && h_cnt < 190 && v_cnt >= 50 && v_cnt <= 130) begin
                                RGB = 12'h29d;
                            end else RGB = 12'h000;
                        end
                        3'd2: begin
                            if(h_cnt >= 160 && h_cnt < 200 && v_cnt >= 70 && v_cnt < 110) begin
                                RGB = 12'hed2;
                            end else RGB = 12'h000; 
                        end        
                        3'd3: begin
                            if((h_cnt >= 170 && h_cnt < 190 && v_cnt >= 70 && v_cnt < 90) ||
                               (h_cnt >= 150 && h_cnt < 210 && v_cnt >= 90 && v_cnt < 110)) begin
                                RGB = 12'h96c;
                            end else RGB = 12'h000;
                        end
                        3'd4: begin
                            if((h_cnt >= 170 && h_cnt < 210 && v_cnt >= 70 && v_cnt < 90) ||
                               (h_cnt >= 150 && h_cnt < 190 && v_cnt >= 90 && v_cnt < 110)) begin
                                RGB = 12'h4b4;
                            end else RGB = 12'h000;
                        end
                        3'd5: begin
                            if((h_cnt >= 150 && h_cnt < 190 && v_cnt >= 70 && v_cnt < 90) ||
                               (h_cnt >= 170 && h_cnt < 210 && v_cnt >= 90 && v_cnt < 110)) begin
                                RGB = 12'he26;
                            end else RGB = 12'h000;
                        end
                        3'd6: begin
                            if((h_cnt >= 160 && h_cnt < 180 && v_cnt >= 100 && v_cnt < 120) ||
                               (h_cnt >= 180 && h_cnt < 200 && v_cnt >= 60 && v_cnt < 120)) begin
                                RGB = 12'h43f;
                            end else RGB = 12'h000;
                        end
                        3'd7: begin
                            if((h_cnt >= 180 && h_cnt < 200 && v_cnt >= 100 && v_cnt < 120) ||
                               (h_cnt >= 160 && h_cnt < 180 && v_cnt >= 60 && v_cnt < 120)) begin
                                RGB = 12'he91; 
                            end else RGB = 12'h000;
                        end
                    endcase
                end else begin
                    RGB = 12'h000;
                end
            end else if(state == `STATE_1P_OVER) begin
                if(((h_cnt >= 130+diff && h_cnt <= 210+diff) && (v_cnt >= 120+diff && v_cnt <= 140+diff))||((h_cnt >= 130+diff && h_cnt <= 150+diff) && (v_cnt >= 140+diff && v_cnt <= 220+diff))||((h_cnt >= 150+diff && h_cnt <= 210+diff) && (v_cnt >= 200+diff && v_cnt <= 220+diff))||((h_cnt >= 190+diff && h_cnt <= 210+diff) && (v_cnt >= 160+diff && v_cnt <= 200+diff))||((h_cnt >= 170+diff && h_cnt <= 190+diff) && (v_cnt >= 160+diff && v_cnt <= 180+diff)))
                    RGB = 12'h5d0;
                else if(((h_cnt >= 250+diff && h_cnt <= 290+diff) && (v_cnt >= 120+diff && v_cnt <= 140+diff))||((h_cnt >= 250+diff && h_cnt <= 290+diff) && (v_cnt >= 200+diff && v_cnt <= 220+diff))||((h_cnt >= 230+diff && h_cnt <= 250+diff) && (v_cnt >= 140+diff && v_cnt <= 200+diff))||((h_cnt >= 290+diff && h_cnt <= 310+diff) && (v_cnt >= 140+diff && v_cnt <= 200+diff)))
                    RGB = 12'h5d0;
                else if(((h_cnt >= 350+diff && h_cnt <= 390+diff) && (v_cnt >= 120+diff && v_cnt <= 140+diff))||((h_cnt >= 350+diff && h_cnt <= 390+diff) && (v_cnt >= 200+diff && v_cnt <= 220+diff))||((h_cnt >= 330+diff && h_cnt <= 350+diff) && (v_cnt >= 140+diff && v_cnt <= 200+diff))||((h_cnt >= 390+diff && h_cnt <= 410+diff) && (v_cnt >= 140+diff && v_cnt <= 200+diff)))  
                    RGB = 12'h5d0;
                else if(((h_cnt >= 430+diff && h_cnt <= 450+diff) && (v_cnt >= 120+diff && v_cnt <= 220+diff))||((h_cnt >= 430+diff && h_cnt <= 490+diff) && (v_cnt >= 120+diff && v_cnt <= 140+diff))||((h_cnt >= 450+diff && h_cnt <= 490+diff) && (v_cnt >= 200+diff && v_cnt <= 220+diff))||((h_cnt >= 490+diff && h_cnt <= 510+diff) && (v_cnt >= 140+diff && v_cnt <= 200+diff)))
                    RGB = 12'h5d0;
                else if(((h_cnt >= 170+diff && h_cnt <= 270+diff) && (v_cnt >= 260+diff && v_cnt <= 280+diff))||((h_cnt >= 210+diff && h_cnt <= 230+diff) && (v_cnt >= 280+diff && v_cnt <= 360+diff))||((h_cnt >= 170+diff && h_cnt <= 230+diff) && (v_cnt >= 340+diff && v_cnt <= 360+diff)))
                    RGB = 12'hff0;
                else if(((h_cnt >= 310+diff && h_cnt <= 350+diff) && (v_cnt >= 260+diff && v_cnt <= 280+diff))||((h_cnt >= 310+diff && h_cnt <= 350+diff) && (v_cnt >= 340+diff && v_cnt <= 360+diff))||((h_cnt >= 290+diff && h_cnt <= 310+diff) && (v_cnt >= 280+diff && v_cnt <= 340+diff))||((h_cnt >= 350+diff && h_cnt <= 370+diff) && (v_cnt >= 280+diff && v_cnt <= 340+diff)))
                    RGB = 12'hff0;
                else if(((h_cnt >= 390+diff && h_cnt <= 410+diff) && (v_cnt >= 260+diff && v_cnt <= 360+diff))||((h_cnt >= 410+diff && h_cnt <= 450+diff) && (v_cnt >= 260+diff && v_cnt <= 280+diff))||((h_cnt >= 410+diff && h_cnt <= 450+diff) && (v_cnt >= 300+diff && v_cnt <= 320+diff))||((h_cnt >= 410+diff && h_cnt <= 450+diff) && (v_cnt >= 340+diff && v_cnt <= 360+diff))||((h_cnt >= 450+diff && h_cnt <= 470+diff) && (v_cnt >= 280+diff && v_cnt <= 300+diff))||((h_cnt >= 450+diff && h_cnt <= 470+diff) && (v_cnt >= 320+diff && v_cnt <= 340+diff)))
                    RGB = 12'hff0;
                else 
                    RGB = 12'h0;
            end else begin
                    if(((h_cnt >= 290 && h_cnt <= 298) && (v_cnt >= 220 && v_cnt <= 244))||// ko
                       ((h_cnt >= 298 && h_cnt <= 306) && (v_cnt >= 228 && v_cnt <= 236))||
                       ((h_cnt >= 306 && h_cnt <= 314) && (v_cnt >= 220 && v_cnt <= 228))||
                       ((h_cnt >= 306 && h_cnt <= 314) && (v_cnt >= 236 && v_cnt <= 244)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 320 && h_cnt <= 328) && (v_cnt >= 220 && v_cnt <= 224))||
                            ((h_cnt >= 336 && h_cnt <= 344) && (v_cnt >= 220 && v_cnt <= 224))||
                            ((h_cnt >= 328 && h_cnt <= 336) && (v_cnt >= 220 && v_cnt <= 228))||
                            ((h_cnt >= 328 && h_cnt <= 336) && (v_cnt >= 236 && v_cnt <= 244)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 8 && h_cnt <= 11) && (v_cnt >= 140 && v_cnt <= 160))||       // next 1 next 2
                            ((h_cnt >= 21 && h_cnt <= 24) && (v_cnt >= 140 && v_cnt <= 160))||
                            ((h_cnt >= 11 && h_cnt <= 14) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 14 && h_cnt <= 17) && (v_cnt >= 148 && v_cnt <= 152))||
                            ((h_cnt >= 17 && h_cnt <= 21) && (v_cnt >= 152 && v_cnt <= 156)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 26 && h_cnt <= 42) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 26 && h_cnt <= 42) && (v_cnt >= 148 && v_cnt <= 152))||
                            ((h_cnt >= 26 && h_cnt <= 42) && (v_cnt >= 156 && v_cnt <= 160))||
                            ((h_cnt >= 26 && h_cnt <= 29) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 26 && h_cnt <= 29) && (v_cnt >= 152 && v_cnt <= 156)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 44 && h_cnt <= 47) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 47 && h_cnt <= 50) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 50 && h_cnt <= 53) && (v_cnt >= 148 && v_cnt <= 152))||
                            ((h_cnt >= 53 && h_cnt <= 56) && (v_cnt >= 152 && v_cnt <= 156))||
                            ((h_cnt >= 56 && h_cnt <= 59) && (v_cnt >= 156 && v_cnt <= 160))||
                            ((h_cnt >= 56 && h_cnt <= 59) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 53 && h_cnt <= 56) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 47 && h_cnt <= 50) && (v_cnt >= 152 && v_cnt <= 156))||
                            ((h_cnt >= 44 && h_cnt <= 47) && (v_cnt >= 156 && v_cnt <= 160)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 61 && h_cnt <= 76) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 67 && h_cnt <= 70) && (v_cnt >= 144 && v_cnt <= 160)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 568 && h_cnt <= 571) && (v_cnt >= 140 && v_cnt <= 160))||
                            ((h_cnt >= 580 && h_cnt <= 583) && (v_cnt >= 140 && v_cnt <= 160))||
                            ((h_cnt >= 571 && h_cnt <= 574) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 574 && h_cnt <= 577) && (v_cnt >= 148 && v_cnt <= 152))||
                            ((h_cnt >= 577 && h_cnt <= 580) && (v_cnt >= 152 && v_cnt <= 156)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 585 && h_cnt <= 600) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 585 && h_cnt <= 600) && (v_cnt >= 148 && v_cnt <= 152))||
                            ((h_cnt >= 585 && h_cnt <= 600) && (v_cnt >= 156 && v_cnt <= 160))||
                            ((h_cnt >= 585 && h_cnt <= 588) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 585 && h_cnt <= 588) && (v_cnt >= 152 && v_cnt <= 156)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 602 && h_cnt <= 605) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 605 && h_cnt <= 608) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 608 && h_cnt <= 611) && (v_cnt >= 148 && v_cnt <= 152))||
                            ((h_cnt >= 611 && h_cnt <= 614) && (v_cnt >= 152 && v_cnt <= 156))||
                            ((h_cnt >= 614 && h_cnt <= 617) && (v_cnt >= 156 && v_cnt <= 160))||
                            ((h_cnt >= 614 && h_cnt <= 617) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 611 && h_cnt <= 614) && (v_cnt >= 144 && v_cnt <= 148))||
                            ((h_cnt >= 605 && h_cnt <= 608) && (v_cnt >= 152 && v_cnt <= 156))||
                            ((h_cnt >= 602 && h_cnt <= 605) && (v_cnt >= 156 && v_cnt <= 160)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 619 && h_cnt <= 634) && (v_cnt >= 140 && v_cnt <= 144))||
                            ((h_cnt >= 625 && h_cnt <= 628) && (v_cnt >= 144 && v_cnt <= 160)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 8 && h_cnt <= 11) && (v_cnt >= 320 && v_cnt <= 340))||             // hold 1 hold 2
                            ((h_cnt >= 21 && h_cnt <= 24) && (v_cnt >= 320 && v_cnt <= 340))||
                            ((h_cnt >= 11 && h_cnt <= 21) && (v_cnt >= 328 && v_cnt <= 332)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 26 && h_cnt <= 42) && (v_cnt >= 320 && v_cnt <= 324))||
                            ((h_cnt >= 26 && h_cnt <= 42) && (v_cnt >= 336 && v_cnt <= 340))||
                            ((h_cnt >= 26 && h_cnt <= 29) && (v_cnt >= 324 && v_cnt <= 336))||
                            ((h_cnt >= 38 && h_cnt <= 42) && (v_cnt >= 324 && v_cnt <= 336)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >=44 && h_cnt <= 47) && (v_cnt >= 320 && v_cnt <= 340))||
                            ((h_cnt >= 47 && h_cnt <= 59) && (v_cnt >= 336 && v_cnt <= 340)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 61 && h_cnt <= 73) && (v_cnt >= 320 && v_cnt <= 324))||
                            ((h_cnt >= 61 && h_cnt <= 73) && (v_cnt >= 336 && v_cnt <= 340))||
                            ((h_cnt >= 61 && h_cnt <= 64) && (v_cnt >= 324 && v_cnt <= 336))||
                            ((h_cnt >= 73 && h_cnt <= 76) && (v_cnt >= 324 && v_cnt <= 336)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 568 && h_cnt <= 571) && (v_cnt >= 320 && v_cnt <= 340))||
                            ((h_cnt >= 580 && h_cnt <= 583) && (v_cnt >= 320 && v_cnt <= 340))||
                            ((h_cnt >= 571 && h_cnt <= 580) && (v_cnt >= 328 && v_cnt <= 332)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 585 && h_cnt <= 600) && (v_cnt >= 320 && v_cnt <= 324))||
                            ((h_cnt >= 585 && h_cnt <= 600) && (v_cnt >= 336 && v_cnt <= 340))||
                            ((h_cnt >= 585 && h_cnt <= 588) && (v_cnt >= 324 && v_cnt <= 336))||
                            ((h_cnt >= 597 && h_cnt <= 600) && (v_cnt >= 324 && v_cnt <= 336)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 602 && h_cnt <= 605) && (v_cnt >= 320 && v_cnt <= 340))||
                            ((h_cnt >= 606 && h_cnt <= 617) && (v_cnt >= 336 && v_cnt <= 340)))begin
                    RGB = 12'hfff;
                end else if(((h_cnt >= 619 && h_cnt <= 631) && (v_cnt >= 320 && v_cnt <= 324))||
                            ((h_cnt >= 619 && h_cnt <= 631) && (v_cnt >= 336 && v_cnt <= 340))||
                            ((h_cnt >= 619 && h_cnt <= 622) && (v_cnt >= 324 && v_cnt <= 336))||
                            ((h_cnt >= 631 && h_cnt <= 634) && (v_cnt >= 324 && v_cnt <= 336)))begin
                    RGB = 12'hfff;
                end else if(h_cnt >= `BOARD_X && h_cnt <= `BOARD_X + `GAMEBOARD_WIDTH && 
                            v_cnt >= `BOARD_Y && v_cnt <= `BOARD_Y + `GAMEBOARD_HEIGHT) begin  
                    if(((h_cnt+1)%20 == 0) || ((v_cnt+11)%20 == 0)) begin
                        RGB = 12'h111;
                    end else begin
                        if(cur_blk_index >= `BLOCKS_ROW * (`BLOCKS_COL-get_line)) begin
                            RGB = game_board[cur_blk_index] ? 12'hf00 : 12'h333;
                        end else if(cur_blk_index == cur_blk_1 || cur_blk_index == cur_blk_2 ||
                                cur_blk_index == cur_blk_3 || cur_blk_index == cur_blk_4) begin
                            if(((h_cnt+1)%20 == 0) || ((v_cnt+11)%20 == 0) || ((h_cnt+2)%20 == 0) || ((v_cnt+12)%20 == 0)|| 
                               ((h_cnt+3)%20 == 0) || ((v_cnt+13)%20 == 0) || ((h_cnt+4)%20 == 0) || ((v_cnt+14)%20 == 0) ) begin
                                case(cur_piece)
                                    3'd0: RGB = 12'haab;
                                    3'd1: RGB = 12'h07b;
                                    3'd2: RGB = 12'hcb0;
                                    3'd3: RGB = 12'h74a;
                                    3'd4: RGB = 12'h292;
                                    3'd5: RGB = 12'hc04;
                                    3'd6: RGB = 12'h10c;
                                    3'd7: RGB = 12'hc70; 
                                endcase
                            end else begin
                                case(cur_piece)
                                    3'd0: RGB = 12'haab;
                                    3'd1: RGB = 12'h29d;
                                    3'd2: RGB = 12'hed2;
                                    3'd3: RGB = 12'h96c;
                                    3'd4: RGB = 12'h4b4;
                                    3'd5: RGB = 12'he26;
                                    3'd6: RGB = 12'h43f;
                                    3'd7: RGB = 12'he91; 
                                endcase
                            end
                        end else begin
                            RGB = game_board[cur_blk_index] ? 12'h444 : 12'haab;
                        end
                    end 
                end else if(h_cnt >= 0 && h_cnt < `BOARD_X && v_cnt <= 430 && v_cnt >= 350) begin
                    case(hold_block)
                        3'd0: begin
                            if(h_cnt == v_cnt) RGB = 12'haab;
                            else RGB = 12'h000;
                        end
                        3'd1: begin 
                            if(h_cnt >= 30 && h_cnt < 50 && v_cnt >= 350 && v_cnt <= 430) begin
                                RGB = 12'h29d;
                            end else RGB = 12'h000;
                        end
                        3'd2: begin
                            if(h_cnt >= 20 && h_cnt < 60 && v_cnt >= 370 && v_cnt < 410) begin
                                RGB = 12'hed2;
                            end else RGB = 12'h000; 
                        end        
                        3'd3: begin
                            if((h_cnt >= 30 && h_cnt < 50 && v_cnt >= 370 && v_cnt < 390) ||
                               (h_cnt >= 10 && h_cnt < 70 && v_cnt >= 390 && v_cnt < 410)) begin
                                RGB = 12'h96c;
                            end else RGB = 12'h000;
                        end
                        3'd4: begin
                            if((h_cnt >= 30 && h_cnt < 70 && v_cnt >= 370 && v_cnt < 390) ||
                               (h_cnt >= 10 && h_cnt < 50 && v_cnt >= 390 && v_cnt < 410)) begin
                                RGB = 12'h4b4;
                            end else RGB = 12'h000;
                        end
                        3'd5: begin
                            if((h_cnt >= 10 && h_cnt < 50 && v_cnt >= 370 && v_cnt < 390) ||
                               (h_cnt >= 30 && h_cnt < 70 && v_cnt >= 390 && v_cnt < 410)) begin
                                RGB = 12'he26;
                            end else RGB = 12'h000;
                        end
                        3'd6: begin
                            if((h_cnt >= 20 && h_cnt < 40 && v_cnt >= 400 && v_cnt < 420) ||
                               (h_cnt >= 40 && h_cnt < 60 && v_cnt >= 360 && v_cnt < 420)) begin
                                RGB = 12'h43f;
                            end else RGB = 12'h000;
                        end
                        3'd7: begin
                            if((h_cnt >= 40 && h_cnt < 60 && v_cnt >= 400 && v_cnt < 420) ||
                               (h_cnt >= 20 && h_cnt < 40 && v_cnt >= 360 && v_cnt < 420)) begin
                                RGB = 12'he91; 
                            end else RGB = 12'h000;
                        end
                    endcase
                end else if(h_cnt >= 0 && h_cnt < `BOARD_X && v_cnt <= 130 && v_cnt > `BOARD_Y) begin
                    case(show_block)
                        3'd0: begin
                            RGB = 12'h000;
                        end
                        3'd1: begin 
                            if(h_cnt >= 30 && h_cnt < 50 && v_cnt >= 50 && v_cnt <= 130) begin
                                RGB = 12'h29d;
                            end else RGB = 12'h000;
                        end
                        3'd2: begin
                            if(h_cnt >= 20 && h_cnt < 60 && v_cnt >= 70 && v_cnt < 110) begin
                                RGB = 12'hed2;
                            end else RGB = 12'h000; 
                        end        
                        3'd3: begin
                            if((h_cnt >= 30 && h_cnt < 50 && v_cnt >= 70 && v_cnt < 90) ||
                               (h_cnt >= 10 && h_cnt < 70 && v_cnt >= 90 && v_cnt < 110)) begin
                                RGB = 12'h96c;
                            end else RGB = 12'h000;
                        end
                        3'd4: begin
                            if((h_cnt >= 30 && h_cnt < 70 && v_cnt >= 70 && v_cnt < 90) ||
                               (h_cnt >= 10 && h_cnt < 50 && v_cnt >= 90 && v_cnt < 110)) begin
                                RGB = 12'h4b4;
                            end else RGB = 12'h000;
                        end
                        3'd5: begin
                            if((h_cnt >= 10 && h_cnt < 50 && v_cnt >= 70 && v_cnt < 90) ||
                               (h_cnt >= 30 && h_cnt < 70 && v_cnt >= 90 && v_cnt < 110)) begin
                                RGB = 12'he26;
                            end else RGB = 12'h000;
                        end
                        3'd6: begin
                            if((h_cnt >= 20 && h_cnt < 40 && v_cnt >= 100 && v_cnt < 120) ||
                               (h_cnt >= 40 && h_cnt < 60 && v_cnt >= 60 && v_cnt < 120)) begin
                                RGB = 12'h43f;
                            end else RGB = 12'h000;
                        end
                        3'd7: begin
                            if((h_cnt >= 40 && h_cnt < 60 && v_cnt >= 100 && v_cnt < 120) ||
                               (h_cnt >= 20 && h_cnt < 40 && v_cnt >= 60 && v_cnt < 120)) begin
                                RGB = 12'he91; 
                            end else RGB = 12'h000;
                        end
                    endcase
                end else if(h_cnt > 280 && h_cnt < 359 && v_cnt < 210 && v_cnt >= 170) begin
                    case(ko)
                        3'd0: begin
                            if((h_cnt >= 310 && h_cnt < 330 && v_cnt >= 170 && v_cnt < 175) ||
                               (h_cnt >= 310 && h_cnt < 330 && v_cnt >= 200 && v_cnt < 205) ||
                               (h_cnt >= 310 && h_cnt < 315 && v_cnt >= 175 && v_cnt < 205) ||
                               (h_cnt >= 325 && h_cnt < 330 && v_cnt >= 175 && v_cnt < 205)) begin
                                RGB = 12'h29d;
                            end else RGB = 12'h000;
                        end
                        3'd1: begin 
                            if(h_cnt >= 315 && h_cnt < 325 && v_cnt >= 170 && v_cnt <= 205) begin
                                RGB = 12'h29d;
                            end else RGB = 12'h000;
                        end
                        3'd2: begin
                            if((h_cnt >= 310 && h_cnt < 330 && v_cnt >= 170 && v_cnt < 175) ||
                               (h_cnt >= 310 && h_cnt < 330 && v_cnt >= 185 && v_cnt < 190) ||
                               (h_cnt >= 310 && h_cnt < 330 && v_cnt >= 200 && v_cnt < 205) ||
                               (h_cnt >= 325 && h_cnt < 330 && v_cnt >= 175 && v_cnt < 185) ||
                               (h_cnt >= 310 && h_cnt < 315 && v_cnt >= 190 && v_cnt < 200)) begin
                                RGB = 12'hed2;
                            end else RGB = 12'h000; 
                        end        
                        3'd3: begin
                            if((h_cnt >= 310 && h_cnt < 330 && v_cnt >= 170 && v_cnt < 175) ||
                               (h_cnt >= 310 && h_cnt < 330 && v_cnt >= 185 && v_cnt < 190) ||
                               (h_cnt >= 310 && h_cnt < 330 && v_cnt >= 200 && v_cnt < 205) ||
                               (h_cnt >= 325 && h_cnt < 330 && v_cnt >= 175 && v_cnt < 205)) begin
                                RGB = 12'h96c;
                            end else RGB = 12'h000;
                        end
                        3'd4: begin
                            if((h_cnt >= 310 && h_cnt < 330 && v_cnt >= 185 && v_cnt < 190) ||
                               (h_cnt >= 310 && h_cnt < 315 && v_cnt >= 170 && v_cnt < 190) ||
                               (h_cnt >= 325 && h_cnt < 330 && v_cnt >= 175 && v_cnt < 205)) begin
                                RGB = 12'h4b4;
                            end else RGB = 12'h000;
                        end
                    endcase
                end else if(h_cnt >= `BOARD_X_2 && h_cnt <= `BOARD_X_2 + `GAMEBOARD_WIDTH  && 
                            v_cnt <= `BOARD_Y_2 + `GAMEBOARD_HEIGHT && v_cnt >= `BOARD_Y_2) begin
                    if(h_cnt == `BOARD_X_2 || h_cnt == `BOARD_X_2 + `GAMEBOARD_WIDTH || 
                       v_cnt == `BOARD_Y_2 || v_cnt == `BOARD_Y_2 + `GAMEBOARD_HEIGHT) begin 
                        RGB = 12'h444;
                    end else begin
                        if(((h_cnt+1)%20 == 0) || ((v_cnt+11)%20 == 0)) begin
                            RGB = 12'h111;
                        end else begin
                            if(cur_blk_index_2 >= `BLOCKS_ROW * (`BLOCKS_COL-get_line_2)) begin
                                RGB = game_board_2[cur_blk_index_2] ? 12'hf00 : 12'h333;
                            end else if(cur_blk_index_2 == cur_2_blk_1 || cur_blk_index_2 == cur_2_blk_2 ||
                                        cur_blk_index_2 == cur_2_blk_3 || cur_blk_index_2 == cur_2_blk_4) begin
                                if(((h_cnt+1)%20 == 0) || ((v_cnt+11)%20 == 0) || ((h_cnt+2)%20 == 0) || ((v_cnt+12)%20 == 0)|| 
                                   ((h_cnt+3)%20 == 0) || ((v_cnt+13)%20 == 0) || ((h_cnt+4)%20 == 0) || ((v_cnt+14)%20 == 0) ) begin
                                    case(cur_piece_2)
                                        3'd0: RGB = 12'haab;
                                        3'd1: RGB = 12'h07b;
                                        3'd2: RGB = 12'hcb0;
                                        3'd3: RGB = 12'h74a;
                                        3'd4: RGB = 12'h292;
                                        3'd5: RGB = 12'hc04;
                                        3'd6: RGB = 12'h10c;
                                        3'd7: RGB = 12'hc70; 
                                    endcase
                                end else begin
                                    case(cur_piece_2)
                                        3'd0: RGB = 12'haab;
                                        3'd1: RGB = 12'h29d;
                                        3'd2: RGB = 12'hed2;
                                        3'd3: RGB = 12'h96c;
                                        3'd4: RGB = 12'h4b4;
                                        3'd5: RGB = 12'he26;
                                        3'd6: RGB = 12'h43f;
                                        3'd7: RGB = 12'he91; 
                                    endcase
                                end
                            end else begin
                                RGB = game_board_2[cur_blk_index_2] ? 12'h444 : 12'haab;
                            end
                        end
                    end
                end else if(h_cnt >= 560 && h_cnt < 640 && v_cnt <= 430 && v_cnt >= 350) begin
                    case(hold_block_2)
                        3'd0: begin
                            RGB = 12'h000;
                        end
                        3'd1: begin 
                            if(h_cnt >= 590 && h_cnt < 610 && v_cnt >= 350 && v_cnt <= 430) begin
                                RGB = 12'h29d;
                            end else RGB = 12'h000;
                        end
                        3'd2: begin
                            if(h_cnt >= 580 && h_cnt < 620 && v_cnt >= 370 && v_cnt < 410) begin
                                RGB = 12'hed2;
                            end else RGB = 12'h000; 
                        end        
                        3'd3: begin
                            if((h_cnt >= 590 && h_cnt < 610 && v_cnt >= 370 && v_cnt < 390) ||
                               (h_cnt >= 570 && h_cnt < 630 && v_cnt >= 390 && v_cnt < 410)) begin
                                RGB = 12'h96c;
                            end else RGB = 12'h000;
                        end
                        3'd4: begin
                            if((h_cnt >= 590 && h_cnt < 630 && v_cnt >= 370 && v_cnt < 390) ||
                               (h_cnt >= 570 && h_cnt < 610 && v_cnt >= 390 && v_cnt < 410)) begin
                                RGB = 12'h4b4;
                            end else RGB = 12'h000;
                        end
                        3'd5: begin
                            if((h_cnt >= 570 && h_cnt < 610 && v_cnt >= 370 && v_cnt < 390) ||
                               (h_cnt >= 590 && h_cnt < 630 && v_cnt >= 390 && v_cnt < 410)) begin
                                RGB = 12'he26;
                            end else RGB = 12'h000;
                        end
                        3'd6: begin
                            if((h_cnt >= 580 && h_cnt < 600 && v_cnt >= 400 && v_cnt < 420) ||
                               (h_cnt >= 600 && h_cnt < 620 && v_cnt >= 360 && v_cnt < 420)) begin
                                RGB = 12'h43f;
                            end else RGB = 12'h000;
                        end
                        3'd7: begin
                            if((h_cnt >= 600 && h_cnt < 620 && v_cnt >= 400 && v_cnt < 420) ||
                               (h_cnt >= 580 && h_cnt < 600 && v_cnt >= 360 && v_cnt < 420)) begin
                                RGB = 12'he91; 
                            end else RGB = 12'h000;
                        end
                    endcase
                end else if(h_cnt >= 560 && h_cnt < 640 && v_cnt <= 130 && v_cnt > `BOARD_Y) begin
                    case(show_block_2)
                        3'd0: begin
                            RGB = 12'h000;
                        end
                        3'd1: begin 
                            if(h_cnt >= 590 && h_cnt < 610 && v_cnt >= 50 && v_cnt <= 130) begin
                                RGB = 12'h29d;
                            end else RGB = 12'h000;
                        end
                        3'd2: begin
                            if(h_cnt >= 580 && h_cnt < 620 && v_cnt >= 70 && v_cnt < 110) begin
                                RGB = 12'hed2;
                            end else RGB = 12'h000; 
                        end        
                        3'd3: begin
                            if((h_cnt >= 590 && h_cnt < 610 && v_cnt >= 70 && v_cnt < 90) ||
                               (h_cnt >= 570 && h_cnt < 630 && v_cnt >= 90 && v_cnt < 110)) begin
                                RGB = 12'h96c;
                            end else RGB = 12'h000;
                        end
                        3'd4: begin
                            if((h_cnt >= 590 && h_cnt < 630 && v_cnt >= 70 && v_cnt < 90) ||
                               (h_cnt >= 570 && h_cnt < 610 && v_cnt >= 90 && v_cnt < 110)) begin
                                RGB = 12'h4b4;
                            end else RGB = 12'h000;
                        end
                        3'd5: begin
                            if((h_cnt >= 570 && h_cnt < 610 && v_cnt >= 70 && v_cnt < 90) ||
                               (h_cnt >= 590 && h_cnt < 630 && v_cnt >= 90 && v_cnt < 110)) begin
                                RGB = 12'he26;
                            end else RGB = 12'h000;
                        end
                        3'd6: begin
                            if((h_cnt >= 580 && h_cnt < 600 && v_cnt >= 100 && v_cnt < 120) ||
                               (h_cnt >= 600 && h_cnt < 620 && v_cnt >= 60 && v_cnt < 120)) begin
                                RGB = 12'h43f;
                            end else RGB = 12'h000;
                        end
                        3'd7: begin
                            if((h_cnt >= 600 && h_cnt < 620 && v_cnt >= 100 && v_cnt < 120) ||
                               (h_cnt >= 580 && h_cnt < 600 && v_cnt >= 60 && v_cnt < 120)) begin
                                RGB = 12'he91; 
                            end else RGB = 12'h000;
                        end
                    endcase
                end else if(h_cnt > 280 && h_cnt < 359 && v_cnt < 310 && v_cnt >= 270) begin
                    case(ko_2)
                        3'd0: begin
                            if((h_cnt >= 310 && h_cnt < 330 && v_cnt >= 270 && v_cnt < 275) ||
                               (h_cnt >= 310 && h_cnt < 330 && v_cnt >= 300 && v_cnt < 305) ||
                               (h_cnt >= 310 && h_cnt < 315 && v_cnt >= 275 && v_cnt < 305) ||
                               (h_cnt >= 325 && h_cnt < 330 && v_cnt >= 275 && v_cnt < 305)) begin
                                RGB = 12'h29d;
                            end else RGB = 12'h000;
                        end
                        3'd1: begin 
                            if(h_cnt >= 315 && h_cnt < 325 && v_cnt >= 270 && v_cnt <= 305) begin
                                RGB = 12'h29d;
                            end else RGB = 12'h000;
                        end
                        3'd2: begin
                            if((h_cnt >= 310 && h_cnt < 330 && v_cnt >= 270 && v_cnt < 275) ||
                               (h_cnt >= 310 && h_cnt < 330 && v_cnt >= 285 && v_cnt < 290) ||
                               (h_cnt >= 310 && h_cnt < 330 && v_cnt >= 300 && v_cnt < 305) ||
                               (h_cnt >= 325 && h_cnt < 330 && v_cnt >= 275 && v_cnt < 285) ||
                               (h_cnt >= 310 && h_cnt < 315 && v_cnt >= 290 && v_cnt < 300)) begin
                                RGB = 12'hed2;
                            end else RGB = 12'h000; 
                        end        
                        3'd3: begin
                            if((h_cnt >= 310 && h_cnt < 330 && v_cnt >= 270 && v_cnt < 275) ||
                               (h_cnt >= 310 && h_cnt < 330 && v_cnt >= 285 && v_cnt < 290) ||
                               (h_cnt >= 310 && h_cnt < 330 && v_cnt >= 300 && v_cnt < 305) ||
                               (h_cnt >= 325 && h_cnt < 330 && v_cnt >= 275 && v_cnt < 305)) begin
                                RGB = 12'h96c;
                            end else RGB = 12'h000;
                        end
                        3'd4: begin
                            if((h_cnt >= 310 && h_cnt < 330 && v_cnt >= 285 && v_cnt < 290) ||
                               (h_cnt >= 310 && h_cnt < 315 && v_cnt >= 270 && v_cnt < 290) ||
                               (h_cnt >= 325 && h_cnt < 330 && v_cnt >= 275 && v_cnt < 305)) begin
                                RGB = 12'h4b4;
                           end else RGB = 12'h000;
                        end
                    endcase
                end else begin
                    RGB = 12'h000;
                end
            end
        end
    end
endmodule