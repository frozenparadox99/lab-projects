module fft(clk,sel,yr,yi); //main module
  input clk;
  input [2:0]sel;
  output reg [7:0]yr,yi;
 
  wire [7:0]y0r,y1r,y2r,y3r,y4r,y5r,y6r,y7r,y0i,y1i,y2i,y3i,y4i,y5i,y6i,y7i;
  wire [7:0]x20r,x20i,x21r,x21i,x22r,x22i,x23r,x23i,x24r,x24i,x25r,x25i,x26r,x26i,x27r,x27i;
  wire [7:0]x10r,x10i,x11r,x11i,x12r,x12i,x13r,x13i,x14r,x14i,x15r,x15i,x16r,x16i,x17r,x17i;
  wire [7:0]x0,x1,x2,x3,x4,x5,x6,x7;

parameter w0r=8'b1;
parameter w0i=8'b0;
parameter w1r=8'b10110101;
parameter w1i=8'b01001011;
parameter w2r=8'b0;
parameter w2i=8'b11111111;
parameter w3r=8'b01001011;
parameter w3i=8'b01001011;

assign x0=8'b1;
assign x1=8'b10;
assign x2=8'b100;
assign x3=8'b1000;
assign x4=8'b10000;
assign x5=8'b100000;
assign x6=8'b1000000;
assign x7=8'b10000000;
//stage1
bfly1 s11(x0,x4,w0r,w0i,x10r,x10i,x11r,x11i);
bfly1 s12(x2,x6,w0r,w0i,x12r,x12i,x13r,x13i);
bfly1 s13(x1,x5,w0r,w0i,x14r,x14i,x15r,x15i);  
bfly1 s14(x3,x7,w0r,w0i,x16r,x16i,x17r,x17i);
//stage2
bfly1 s21(x10r,x12r,w0r,w0i,x20r,x20i,x22r,x22i);
bfly2 s22(x11r,x11i,x13r,x13i,x21r,x21i,x23r,x23i);
bfly1 s23(x14r,x16r,w0r,w0i,x24r,x24i,x26r,x26i);
bfly2 s24(x15r,x15i,x17r,x17i,x25r,x25i,x27r,x27i);
//stage3
bfly1 s31(x20r,x24r,w0r,w0i,y0r,y0i,y4r,y4i);
bfly3 s32(x21r,x21i,x25r,x25i,w1r,w1i,y1r,y1i,y5r,y5i);
bfly2 s33(x22r,x22i,x26r,x26i,y2r,y2i,y6r,y6i);
bfly4 s34(x23r,x23i,x27r,x27i,w3r,w3i,y3r,y3i,y7r,y7i);

always@(posedge clk)
case(sel)
  0:begin yr=y0r; yi=y0i; end
  1:begin yr=y1r; yi=y1i; end
  2:begin yr=y2r; yi=y2i; end
  3:begin yr=y3r; yi=y3i; end
  4:begin yr=y4r; yi=y4i; end
  5:begin yr=y5r; yi=y5i; end
  6:begin yr=y6r; yi=y6i; end
  7:begin yr=y7r; yi=y7i; end
endcase
 endmodule

module bfly1(x,y,wr,wi,x0r,x0i,x1r,x1i);// sub module
  input [7:0]x,y,wr,wi;
  output[7:0]x1r,x1i,x0r,x0i;
  assign x0r=x+(y*wr);
  assign x0i=y*wi;
  assign x1r=x+(~(y*wr)+1);
  assign x1i=~(y*wi)+1;
endmodule

module bfly2(xr,xi,yr,yi,x0r,x0i,x1r,x1i); // sub module
  input [7:0]xr,xi,yr,yi;
  output [7:0]x0r,x0i,x1r,x1i;
  assign x0r=xr;
  assign x0i=~yr+1;
  assign x1r=xr;
  assign x1i=yr;
endmodule

module bfly3(xr,xi,yr,yi,wr,wi,x0r,x0i,x1r,x1i); // sub module
  input [7:0]xr,xi,yr,yi,wr,wi;
  output [7:0]x0r,x0i,x1r,x1i;
  wire [15:0]p1,p2,p3,p4;
  wire [7:0]win,yrn,yin;
  wire [8:0]ywr,ywi;
  parameter sht=8'b1000;
  assign yrn=~yr+1;
  assign yin=yi;
  assign win=~wi+1;
 
  assign p1=(yrn*wr)>>sht;
  assign p2=(yin*win)>>sht;
  assign p3=(yrn*win)>>sht;
  assign p4=(yin*wr)>>sht;
  assign ywr=(~p1+1)+p2;
  assign ywi=p3+p4;
 
  assign x0r=xr+ywr;
  assign x0i=xi+ywi;
  assign x1r=xr+(~ywr+1);
  assign x1i=xi+(~ywi+1);
endmodule

module bfly4(xr,xi,yr,yi,wr,wi,x0r,x0i,x1r,x1i); // sub module
  input [7:0]xr,xi,yr,yi,wr,wi;
  output [7:0]x0r,x0i,x1r,x1i;
  wire [15:0]p1,p2;
  wire [7:0]win,yrn,yin;
  wire [8:0]ywr,ywi;
  parameter sht=8'b1000;
  assign yrn=~yr+1;
  assign yin=~yi+1;
  assign win=~wi+1;
    assign p1=(yrn*win)>>sht;
  assign p2=(yin*win)>>sht;
  assign ywr=p1+(~p2+1);
  assign ywi=p1+p2;
   assign x0r=xr+ywr;
  assign x0i=xi+ywi;
  assign x1r=xr+(~ywr+1);
  assign x1i=xi+(~ywi+1);
endmodule