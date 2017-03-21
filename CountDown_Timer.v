module CountDown_Timer(
	input 			 CLK,
	input 			 RESET,
	input wire       game_over,
	input wire		 pause,
	input wire		 Start,
	output reg [3:0] AN,
	output reg [6:0] Seg,
	output reg 	     time_up
);
	reg [1:0]  state, n_state;
	reg [17:0] clk_div;
	reg [27:0] clk_ms;
	reg [3:0]  display;
	
	reg [3:0]  ms;
	reg [3:0]  s0;
	reg [3:0]  s1;
	reg s2;
	
	wire DCLK;

	parameter INIT   = 2'b00;
	parameter WAIT   = 2'b01;
	parameter COUNT  = 2'b10;
	parameter REACH	 = 2'b11;
    
	always@(posedge CLK or posedge RESET)begin
        if(RESET)
            clk_ms <= 28'b0;
	    else if(clk_ms == 1000_0000)
			clk_ms <= 28'b0;
        else if(state == COUNT)
            clk_ms <= clk_ms + 1;
    end
	
	assign DCLK = ((clk_ms == 1000_0000) ? 1 : 0);
     
    /* for the seven segment display */
    always @(posedge CLK) begin
        clk_div <= clk_div + 1;
    end
	
    always@(posedge CLK or posedge RESET)begin
       	if(RESET)         state <= INIT;
	    else              state <= n_state;
   	end
	
	always @(*) begin
		n_state = state;
		case(state)
			INIT :           n_state = WAIT;
			WAIT : if(Start) n_state = COUNT;
			COUNT: begin
			    if(pause) begin
			        n_state = WAIT;
			    end else if(((ms == 1) && (s0 == 0) && (s1 == 0) && (s2 == 0)) || game_over) begin
			        n_state = REACH;
			    end
		    end
		    REACH: if(Start) n_state = INIT;
		endcase
	end
    
    always @(*) begin
        if(state == REACH) begin
            time_up = 1'b1;
        end else time_up = 1'b0;
    end
    
	always @(posedge CLK or posedge RESET) begin
        if(RESET) begin
            ms <= 0;
            s0 <= 0;
            s1 <= 2;
            s2 <= 1;
        end else if(state == INIT) begin
            ms <= 0;
            s0 <= 0;
            s1 <= 2;
            s2 <= 1;
        end else if(state == REACH) begin
            ms <= 0;
            s0 <= 0;
            s1 <= 0;
            s2 <= 0;
        end else if( DCLK == 1 )begin
        	if(ms == 0) begin
        		ms <= 9;
            	if(s0 == 0) begin //xx9.9
	            	s0 <= 9;
	            	if(s1 == 0) begin //x59.9
	                	s1  <= 9;
	                	if(s2 == 0) begin
	                	    ms <= 0;
	                	    s0 <= 0;
	                	    s1 <= 0;
	                	    s2 <= 0;
	                	end else begin
							s2 <= s2 - 1;
						end
	            	end else begin
	            		s1 <= s1 - 1;
	            	end
	        	end else begin
	            	s0 <= s0 - 1;
	        	end
	    	end else begin
	    		ms <= ms -1;
	    	end
	    end
    end
	
	always @(*) begin
		display = 0;
		case(clk_div[17:16])
			2'b00 : begin
			    Dot = 1;
				display = ms;
				AN = 4'b1110;
			end
			2'b01 : begin
			    Dot = 0;
				display = s0;
				AN = 4'b1101;
			end
			2'b10 : begin
			    Dot = 1;
				display = s1;
				AN = 4'b1011;
			end
			2'b11 : begin
				Dot = 1;
				display = s2;
				AN = 4'b0111;
			end
		endcase
	end
	
	always @(*)begin
		case(display)
			0 : Seg = 7'b1000000;
			1 : Seg = 7'b1111001;
			2 : Seg = 7'b0100100;
			3 : Seg = 7'b0110000;
			4 : Seg = 7'b0011001;
			5 : Seg = 7'b0010010;
			6 : Seg = 7'b0000010;
			7 : Seg = 7'b1111000;
			8 : Seg = 7'b0000000;
			9 : Seg = 7'b0010000;
			default : Seg = 7'b1000000;
		endcase
	end	
endmodule