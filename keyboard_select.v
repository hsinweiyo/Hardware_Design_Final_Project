module keyboard_select(
    input wire [511:0] key_down,
    input wire been_ready,
    output wire p1_left,
    output wire p1_right,
    output wire p1_rotate,
    output wire p1_change,
    output wire p1_speed,
    output wire p1_drop,
    output wire enter,
    output wire pause,
    output wire p2_left,
    output wire p2_right,
    output wire p2_rotate,
    output wire p2_change,
    output wire p2_speed,
    output wire p2_drop
);

    parameter P1_MOVE_LEFT_CODES  = 9'b0_0001_1011; // S_code
    parameter P1_MOVE_RIGHT_CODES = 9'b0_0010_1011; // F_code
    parameter P1_SPEED_UP_CODES   = 9'b0_0010_0011; // D_code
    parameter P1_ROTATE_CODES     = 9'b0_0010_0100; // E_code
    parameter P1_TO_BOTTOM_CODES  = 9'b0_0001_0010; // Left Shift
    parameter P1_CHANGE_CODES     = 9'b0_0001_1010; // Z_code
    parameter P2_MOVE_LEFT_CODES  = 9'b0_0110_1001; // 1_code
    parameter P2_MOVE_RIGHT_CODES = 9'b0_0111_1010; // 3_code
    parameter P2_SPEED_UP_CODES   = 9'b0_0111_0010; // 2_code
    parameter P2_ROTATE_CODES     = 9'b0_0111_0011; // 5_code
    parameter P2_TO_BOTTOM_CODES  = 9'b0_0010_1001; // Space_code
    parameter P2_CHANGE_CODES     = 9'b0_0100_1001; // > code
    parameter ENTER_CODES         = 9'b0_0101_1010; // Enter_code
    parameter PAUSE_CODES         = 9'b0_0100_1101; // P_code
    
	assign p1_left   = (been_ready == 1'b1 && key_down[P1_MOVE_LEFT_CODES]  == 1'b1) ? 1'b1 : 1'b0;
	assign p1_right  = (been_ready == 1'b1 && key_down[P1_MOVE_RIGHT_CODES] == 1'b1) ? 1'b1 : 1'b0;
	assign p1_rotate = (been_ready == 1'b1 && key_down[P1_ROTATE_CODES]     == 1'b1) ? 1'b1 : 1'b0;
	assign p1_change = (been_ready == 1'b1 && key_down[P1_CHANGE_CODES]     == 1'b1) ? 1'b1 : 1'b0;
	assign p1_speed  = (been_ready == 1'b1 && key_down[P1_SPEED_UP_CODES]   == 1'b1) ? 1'b1 : 1'b0;
	assign p1_drop   = (been_ready == 1'b1 && key_down[P1_TO_BOTTOM_CODES]  == 1'b1) ? 1'b1 : 1'b0;
	assign enter     = (been_ready == 1'b1 && key_down[ENTER_CODES]         == 1'b1) ? 1'b1 : 1'b0;
	assign p2_left   = (been_ready == 1'b1 && key_down[P2_MOVE_LEFT_CODES]  == 1'b1) ? 1'b1 : 1'b0;
    assign p2_right  = (been_ready == 1'b1 && key_down[P2_MOVE_RIGHT_CODES] == 1'b1) ? 1'b1 : 1'b0;
    assign p2_rotate = (been_ready == 1'b1 && key_down[P2_ROTATE_CODES]     == 1'b1) ? 1'b1 : 1'b0;
    assign p2_change = (been_ready == 1'b1 && key_down[P2_CHANGE_CODES]     == 1'b1) ? 1'b1 : 1'b0;
    assign p2_speed  = (been_ready == 1'b1 && key_down[P2_SPEED_UP_CODES]   == 1'b1) ? 1'b1 : 1'b0;
    assign p2_drop   = (been_ready == 1'b1 && key_down[P2_TO_BOTTOM_CODES]  == 1'b1) ? 1'b1 : 1'b0;
    assign pause     = (been_ready == 1'b1 && key_down[PAUSE_CODES]         == 1'b1) ? 1'b1 : 1'b0;
    
endmodule
