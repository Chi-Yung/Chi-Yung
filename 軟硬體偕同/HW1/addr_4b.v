module addr_4b(s,cout,r1,r2,ci);
	input	[3:0] r1,r2;
	input ci;
	output [3:0] s;
	output	cout;
	wire c1,c2,c3;
	addr_1b u0(
	.a(r1[0]),.b(r2[0]),.cin(ci),.cout(c1),.sum(s[0])
	);
	addr_1b u1(
	.a(r1[1]),.b(r2[1]),.cin(c1),.cout(c2),.sum(s[1])
	);
	addr_1b u2(
	.a(r1[2]),.b(r2[2]),.cin(c2),.cout(c3),.sum(s[2])
	);
	addr_1b u3(
	.a(r1[3]),.b(r2[3]),.cin(c3),.cout(cout),.sum(s[3])
	);
	endmodule
