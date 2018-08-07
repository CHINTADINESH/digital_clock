# digital_clock
module digitalClockt_b( input m);
	wire clk;
	wire [1:0] hmsb;
	wire [4:0] hlsb;
	wire [3:0] mmsb;
	wire [4:0] mlsb;
	wire [3:0] smsb;
	wire [4:0] slsb;

	clockgenerator cg (clk);
	digitalClock cd(clk, hmsb, hlsb, mmsb, mlsb, smsb, slsb);
	endmodule

module clockgenerator(clk);
	output clk;
	reg clk;
	initial
		begin
		clk = 0;
		end
	always begin
		#10 clk = !clk;
		end
	endmodule
		
	
module digitalClock(clk, hmsb, hlsb, mmsb, mlsb, smsb, slsb);
	input clk;
	wire masterreset;
	output [1:0] hmsb;
	output [4:0] hlsb;
	output [3:0] mmsb;
	output [4:0] mlsb;
	output [3:0] smsb;
	output [4:0] slsb;
	wire twocheck, fourcheck;
	and tc (twocheck, hmsb[1], ~hmsb[0]);
	and fc (fourcheck, ~hlsb[3], hlsb[2], ~hlsb[1], ~hlsb[0]);
	and tfc (masterreset, twocheck, fourcheck);
	digit slsb0 (clk, slsb, masterreset);
	nextdigit smsb0(slsb[4], smsb, masterreset);
	digit mlsb0(smsb[3], mlsb, masterreset);
	nextdigit mmsb0(mlsb[4], mmsb, masterreset);
	digit hlsb0(mmsb[3], hlsb, masterreset);
	hourmsb hmsb0(hlsb[4], hmsb, masterreset); 
	endmodule
module digit(clk, oup, res);
	input clk;	
	input res;
	output [4:0] oup;
	wire data3, data2, data1, data0;
	wire ndata3, ndata2, ndata1, ndata0;
	wire newdata3, newdata2, newdata1, newdata0; 
	wire aand0, aand1;
	wire band0, band1, band2;
	wire cand0, cand1;
	wire nexttrigger;
	not n3(ndata3,data3);
	not n2(ndata2,data2);
	not n1(ndata1,data1);
	not n0(ndata0,data0);
	or a1(newdata3, aand0, aand1);
	and a11(aand0, data2, data1, data0);
	and a12(aand1, data3, ndata0);
	or b1(newdata2, band0, band1, band2);
	and b11(band0, data2, ndata1);
	and b12(band1, data2, ndata0);
	and b13(band2, ndata2, data1, ndata0);
	or c1(newdata1, cand0, cand1, cand2);
	and c11(cand0, ndata3, data1, ndata0);
	and c12(cand1, ndata3, ndata1, data0);
	and ( nexttrigger, data3, ndata2, ndata1, data0);
	not (newdata0,  dand0);
	dff x3 (.d(newdata3), .clk(clk), .reset(res), .q(data3) );
	dff x2 (.d(newdata2), .clk(clk), .reset(res), .q(data2) );
	dff x1 (.d(newdata1), .clk(clk), .reset(res), .q(data1) );
	dff x0 (.d(newdata0), .clk(clk), .reset(res), .q(data0) );
	assign oup = {nexttrigger,data3, data2, data1, data0};
	endmodule
module nextdigit(clk, oup, res);
	input clk;	
	input res;	
	output [3:0] oup;
	wire  data2, data1, data0;
	wire 	ndata2, ndata1, ndata0;
	wire  newdata2, newdata1, newdata0; 
	wire band0, band1;
	wire cand0, cand1;
	wire nexttrigger;
	not n2(ndata2,data2);
	not n1(ndata1,data1);
	not n0(ndata0,data0);
	or b1(newdata2, band0, band1);
	and b11(band0, data2, ndata0);
	and b12(band1, data1, data0);
	or c1(newdata1, cand0, cand1);
	and c11(cand0, data1, ndata0);
	and c12(cand1, ndata3, ndata1, data0);
	and ( nexttrigger, data2, ndata1, data0);
	assign newdata0 =  ndata0;
	dff x2 (.d(newdata2), .clk(clk), .reset(res), .q(data2) );
	dff x1 (.d(newdata1), .clk(clk), .reset(res), .q(data1) );
	dff x0 (.d(newdata0), .clk(clk), .reset(res), .q(data0) );
	assign oup = {nexttrigger, data2, data1, data0};
	endmodule
module hourmsb(clk, oup, res);
	input clk;
	output [1:0] oup;
	input res;
	wire  data1, data0;
	wire 	ndata1, ndata0;
	wire 	newdata1, newdata0; 
	assign newdata1 = data0;
	assign newdata0 = ndata0;
	dff x1 (.d(newdata1), .clk(clk), .reset(res), .q(data1) );
	dff x0 (.d(newdata0), .clk(clk), .reset(res), .q(data0) );
	assign oup = { data1, data0};
	endmodule
module dff(d, clk, reset, q );
	input clk, reset,d ;
	output q;
	reg q;
	always @(negedge clk or posedge reset)
		begin
			if(reset ==1)
				q = 0;
			else
				q = d;
		end
	endmodule
