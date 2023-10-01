module test_tb;
	reg  [3:0] r1, r2, ci;
	wire  cout;
	wire [3:0]s;

initial
	begin
		$dumpfile("test.vcd");
		$dumpvars(0, s);
		$monitor("r1 = %b, r2 = %b cin = %b | cout = %b sum = %b ", r1, r2, ci, cout, s);
		#50 r1=4'b0000; r2=4'b0000; ci=1'b0;
		#50 r1=4'b0000; r2=4'b0001; ci=1'b0;
		#50 r1=4'b0000; r2=4'b0010; ci=1'b0;
		#50 r1=4'b0000; r2=4'b0011; ci=1'b0;
		#50 r1=4'b0000; r2=4'b0000; ci=1'b1;
		#50 r1=4'b0000; r2=4'b0001; ci=1'b1;
		#50 r1=4'b0000; r2=4'b0010; ci=1'b1;
		#50 r1=4'b0000; r2=4'b0011; ci=1'b1;
		#50 r1=4'b0001; r2=4'b0000; ci=1'b0;
		#50 r1=4'b0001; r2=4'b0001; ci=1'b0;
		#50 r1=4'b0001; r2=4'b0010; ci=1'b0;
		#50 r1=4'b0001; r2=4'b0011; ci=1'b0;
		#50 r1=4'b0001; r2=4'b0000; ci=1'b1;
		#50 r1=4'b0001; r2=4'b0001; ci=1'b1;
		#50 r1=4'b0001; r2=4'b0010; ci=1'b1;
		#50 r1=4'b0001; r2=4'b0011; ci=1'b1;
		#50 $finish;
	end

	addr_4b s( s,cout,r1,r2,ci);
endmodule