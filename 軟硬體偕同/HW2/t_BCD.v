module t_BCD;
	reg [3:0] BCD_i;
   wire [9:0] Dec_o;
   reg Reset_n, Preset;
   integer i;
initial begin       
		  $dumpfile("test.vcd");
          Reset_n = 0;
          Preset = 0;
          $monitor("reset_n = %b ,Preset = %b ,bcd = %b dec = %b ", Reset_n, Preset, BCD_i, Dec_o);
          #50;
          Preset = 1;
          #50;
          Reset_n = 1;
          #50;
          Preset = 0;
			 for(i = 0;i < 16;i = i+1)
        begin
            BCD_i = i; 
            #50;
        end 
			#1200 $finish;		  
    end 
BCD tbcd(.BCD_i(BCD_i),.Dec_o(Dec_o),.Reset_n(Reset_n),.Preset(Preset));	 
endmodule