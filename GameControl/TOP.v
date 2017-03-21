// *******************************
// lab_SPEAKER_TOP
//
// ********************************

module TOP (
    input [31:0]tone_1,
    input [31:0]tone_2,
    //input [31:0]tone_1_2,
    //input [31:0]tone_2_2,
	input clk,
	input reset,
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
parameter BEAT_FREQ = 32'd8;	//one beat=0.125sec
parameter DUTY_BEST = 10'd512;	//duty cycle=50%

wire [31:0] freq;
//wire [31:0] tone_1;
//wire [31:0] tone_2;
//wire [31:0] tone_11;
wire [8:0] ibeatNum;
wire beatFreq;

assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on

assign se_2 = 1'd1;	//no gain(6dB)
assign se_4 = 1'd1;	//turn-on

assign se_2_2 = 1'd1;	//no gain(6dB)
assign se_2_4 = 1'd1;	//turn-on

/*clk_div clock_div(
	   .CLK(CLK),
	   .rst(rst),
	   .clk(clk)
	);*/
//Generate beat speed
PWM_gen btSpeedGen ( .clk(clk), 
					 .reset(reset),
					 .freq(BEAT_FREQ),
					 .duty(DUTY_BEST), 
					 .PWM(beatFreq)
);
	
//manipulate beat
PlayerCtrl playerCtrl_00 ( .clk(beatFreq),
						   .reset(reset),
						   .ibeat(ibeatNum)
);	
	
//Generate variant freq. of tones
Music music00 ( .ibeatNum(ibeatNum),
				.tone(freq)
);



// Generate particular freq. signal
PWM_gen toneGen ( .clk(clk), 
				  .reset(reset), 
				  .freq(freq),
				  .duty(DUTY_BEST), 
				  .PWM(pmod_1)
);
PWM_gen sound ( .clk(clk), 
				  .reset(reset), 
				  .freq(tone_1),
				  .duty(DUTY_BEST), 
				  .PWM(se_1)
);
PWM_gen sound_2 ( .clk(clk), 
				  .reset(reset), 
				  .freq(tone_2),
				  .duty(DUTY_BEST), 
				  .PWM(se_2_1)
);

endmodule