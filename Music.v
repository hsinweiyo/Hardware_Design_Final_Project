
`define MI   32'd330 // E
`define LA   32'd220 // A LOW
`define SI   32'd247 // B LOW
`define DO  32'd262 // C
`define RE  32'd294 // D
`define SO  32'd392 // GB
`define FA  32'd349 // F
`define MUTE  32'd20000 // MUTE
module Music (
	input [7:0] ibeatNum,	
	output reg [31:0] tone
);

always @(*) begin
	case (ibeatNum)		// 1/4 beat
		8'd0 : tone = `MI;	
		8'd1 : tone = `MI;
		8'd2 : tone = `MI;
		8'd3 : tone = `MI;
		8'd4 : tone = `SI;
		8'd5 : tone = `SI;
		8'd6 : tone = `DO;
		8'd7 : tone = `DO;
		
		8'd8 : tone = `RE;
		8'd9 : tone = `RE;
		8'd10 : tone = `RE;
		8'd11 : tone = `RE;
		8'd12 : tone = `DO;
		8'd13 : tone = `DO;
		8'd14 : tone = `SI;
		8'd15 : tone = `SI;
/////////////////////////////////////////////////
		
		8'd16 : tone = `LA;
		8'd17 : tone = `LA;
		8'd18 : tone = `LA;
		8'd19 : tone = `LA;
		8'd20 : tone = `LA;
		8'd21 : tone = `LA;
		8'd22 : tone = `DO;
		8'd23 : tone = `DO;
		
		8'd24 : tone = `MI;
		8'd25 : tone = `MI;
		8'd26 : tone = `MI;
		8'd27 : tone = `MI;
		8'd28 : tone = `RE;
		8'd29 : tone = `RE;
		8'd30 : tone = `DO;
		8'd31 : tone = `DO;
////////////////////////////////////////////
		
		8'd32 : tone = `SI;
		8'd33 : tone = `SI;
		8'd34 : tone = `SI;
		8'd35 : tone = `SI;
		8'd36 : tone = `SI;
		8'd37 : tone = `SI;
		8'd38 : tone = `DO;
		8'd39 : tone = `DO;
		
		8'd40 : tone = `RE;
		8'd41 : tone = `RE;
		8'd42 : tone = `RE;
		8'd43 : tone = `RE;
		8'd44 : tone = `MI;
		8'd45 : tone = `MI;
		8'd46 : tone = `MI;
		8'd47 : tone = `MI;
/////////////////////////////////////////////////
		
		8'd48 : tone = `DO;
		8'd49 : tone = `DO;
		8'd50 : tone = `DO;
	    8'd51 : tone = `DO;
		8'd52 : tone = `LA;
		8'd53 : tone = `LA;
		8'd54 : tone = `LA;
		8'd55 : tone = `LA;
		
		8'd56 : tone = `LA;
		8'd57 : tone = `LA;
//////////////////////////////////////////////////////
		8'd58 : tone = `RE;
		8'd59 : tone = `RE;
		8'd60 : tone = `RE;
		8'd61 : tone = `RE;
		8'd62 : tone = `RE;
		8'd63 : tone = `RE;
///////////////////////////////////////////////////
		
		8'd64 : tone = `FA;
		8'd65 : tone = `FA;
		8'd66 : tone = `LA;
		8'd67 : tone = `LA;
		8'd68 : tone = `LA;
		8'd69 : tone = `LA;
		8'd70 : tone = `SO;
		8'd71 : tone = `SO;
		
		8'd72 : tone = `FA;
		8'd73 : tone = `FA;
		8'd74 : tone = `MI;
		8'd75 : tone = `MI;
		8'd76 : tone = `MI;
		8'd77 : tone = `MI;
		8'd78 : tone = `MI;
		8'd79 : tone = `MI;
/////////////////////////////////////////////////
	
		8'd80 : tone = `DO;
		8'd81 : tone = `DO;
		8'd82 : tone = `MI;
		8'd83 : tone = `MI;
		8'd84 : tone = `MI;
		8'd85 : tone = `MI;
		8'd86 : tone = `RE;
		8'd87 : tone = `RE;
		
		8'd88 : tone = `DO;
		8'd89 : tone = `DO;
		8'd90 : tone = `SI;
		8'd91 : tone = `SI;
		8'd92 : tone = `SI;
		8'd93 : tone = `SI;
		8'd94 : tone = `SI;
		8'd95 : tone = `SI;
///////////////////////////////////////////////////
		
		8'd96 : tone = `DO;
		8'd97 : tone = `DO;
		8'd98 : tone = `RE;
		8'd99 : tone = `RE;
		8'd100 : tone = `RE;
		8'd101 : tone = `RE;
		8'd102 : tone = `RE;
		8'd103 : tone = `RE;
		
		8'd104 : tone = `MI;
		8'd105 : tone = `MI;
		8'd106 : tone = `DO;
		8'd107 : tone = `DO;
		8'd108 : tone = `DO;
		8'd109 : tone = `DO;
		8'd110 : tone = `LA;
		8'd111 : tone = `LA;
/////////////////////////////////////////////////
		
		8'd112 : tone = `LA;
		8'd113 : tone = `LA;
		8'd114 : tone = `LA;
		8'd115 : tone = `LA;
		8'd116 : tone = `LA;
		8'd117 : tone = `LA;
		/*
		8'd118 : tone = `NMGs;
		8'd119 : tone = `NMGs;
		
		8'd120 : tone = `NMB;
		8'd121 : tone = `NMB;
		8'd122 : tone = `NMB;
		8'd123 : tone = `NM0;
		8'd124 : tone = `NMB;
		8'd125 : tone = `NMB;
		8'd126 : tone = `NMB;
		8'd127 : tone = `NM0;
///////////////////////////////////////////////////
*/
		default : tone = `MUTE;
	endcase
end

endmodule
		
		
		
		