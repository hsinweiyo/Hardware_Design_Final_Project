// system state
`define STATE_READY        3'd0
`define STATE_GAME         3'd1
`define STATE_P1_WINS      3'd2
`define STATE_P2_WINS      3'd3
`define STATE_1P_GAME      3'd4
`define STATE_1P_OVER      3'd5

// Width & height of screen in pixel
`define PIXEL_WIDTH  640
`define PIXEL_HEIGHT 480
// The size of each block in pixel
`define BLOCK_SIZE 20

// Width & height of gameboard in blocksize
`define BLOCKS_ROW 10
`define BLOCKS_COL 19

// Width & Height of gameboard in pixel
`define GAMEBOARD_WIDTH  (`BLOCKS_ROW * `BLOCK_SIZE)
`define GAMEBOARD_HEIGHT (`BLOCKS_COL * `BLOCK_SIZE)

// Coordinate: X & Y
`define BOARD_X 79
`define BOARD_Y 49
`define BOARD_X_2 359
`define BOARD_Y_2 49
`define BOARD_X_3 219
`define BOARD_Y_3 49

// The number of bits used to store 
`define BITS_BLK_POS   8	//--> The position of a block in the screen
`define BITS_X_POS     4
`define BITS_Y_POS     5
`define BITS_ROT       2
`define BITS_BLK_SIZE  3
`define BITS_SCORE     14
`define BITS_PER_BLOCK 3	//--> which kind of blocks it is
`define MODE_BITS	   3

// Each block
`define EMPTY_BLOCK 3'd0
`define I_BLOCK 	3'd1
`define O_BLOCK 	3'd2
`define T_BLOCK 	3'd3
`define S_BLOCK 	3'd4
`define Z_BLOCK 	3'd5
`define J_BLOCK 	3'd6
`define L_BLOCK 	3'd7

// Modes
`define MODE_PLAY  0
`define MODE_DROP  1
`define MODE_PAUSE 2
`define MODE_IDLE  3
`define MODE_SHIFT 4
`define MODE_GET   5
`define MODE_CLEAR 7
// Drop timer
`define DROP_TIMER 10000

