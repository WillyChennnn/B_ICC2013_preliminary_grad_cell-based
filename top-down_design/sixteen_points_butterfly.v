module sixteen_points_butterfly ( clk, rst, en,
                                  x0, x1, x2, x3,
                                  x4, x5, x6, x7,
                                  x8, x9, x10, x11,
                                  x12, x13, x14, x15,
                                  stage1_00, stage1_01, stage1_02, stage1_03,
                                  stage1_04, stage1_05, stage1_06, stage1_07,
                                  stage1_08, stage1_09, stage1_10, stage1_11,
                                  stage1_12, stage1_13, stage1_14, stage1_15
                                );
input clk, rst;
input en;
input [15:0] x0, x1, x2, x3;
input [15:0] x4, x5, x6, x7;
input [15:0] x8, x9, x10, x11;
input [15:0] x12, x13, x14, x15;

output reg [63:0] stage1_00, stage1_01, stage1_02, stage1_03;
output reg [63:0] stage1_04, stage1_05, stage1_06, stage1_07;
output reg [63:0] stage1_08, stage1_09, stage1_10, stage1_11;
output reg [63:0] stage1_12, stage1_13, stage1_14, stage1_15;

reg [15:0] tmp0, tmp1, tmp2, tmp3;
reg [15:0] tmp4, tmp5, tmp6, tmp7;

reg [15:0] s1_00_real, s1_01_real, s1_02_real, s1_03_real;
reg [15:0] s1_04_real, s1_05_real, s1_06_real, s1_07_real;
reg [47:0] s1_08_real, s1_09_real, s1_10_real, s1_11_real;
reg [47:0] s1_12_real, s1_13_real, s1_14_real, s1_15_real;

reg [47:0] s1_08_imag, s1_09_imag, s1_10_imag, s1_11_imag;
reg [47:0] s1_12_imag, s1_13_imag, s1_14_imag, s1_15_imag;

wire [31:0] stage1_00_real, stage1_01_real, stage1_02_real, stage1_03_real;
wire [31:0] stage1_04_real, stage1_05_real, stage1_06_real, stage1_07_real;

wire [31:0] stage1_08_real, stage1_09_real, stage1_10_real, stage1_11_real;
wire [31:0] stage1_12_real, stage1_13_real, stage1_14_real, stage1_15_real;

wire [31:0] stage1_08_imag, stage1_09_imag, stage1_10_imag, stage1_11_imag;
wire [31:0] stage1_12_imag, stage1_13_imag, stage1_14_imag, stage1_15_imag;

/* Real part */
assign stage1_00_real = { { 8{s1_00_real[15]} }, s1_00_real, 8'd0 };
assign stage1_01_real = { { 8{s1_01_real[15]} }, s1_01_real, 8'd0 };
assign stage1_02_real = { { 8{s1_02_real[15]} }, s1_02_real, 8'd0 };
assign stage1_03_real = { { 8{s1_03_real[15]} }, s1_03_real, 8'd0 };
assign stage1_04_real = { { 8{s1_04_real[15]} }, s1_04_real, 8'd0 };
assign stage1_05_real = { { 8{s1_05_real[15]} }, s1_05_real, 8'd0 };
assign stage1_06_real = { { 8{s1_06_real[15]} }, s1_06_real, 8'd0 };
assign stage1_07_real = { { 8{s1_07_real[15]} }, s1_07_real, 8'd0 };
assign stage1_08_real = s1_08_real[39:8];
assign stage1_09_real = s1_09_real[39:8];
assign stage1_10_real = s1_10_real[39:8];
assign stage1_11_real = s1_11_real[39:8];
assign stage1_12_real = s1_12_real[39:8];
assign stage1_13_real = s1_13_real[39:8];
assign stage1_14_real = s1_14_real[39:8];
assign stage1_15_real = s1_15_real[39:8];

/* Imag part */
assign stage1_08_imag = s1_08_imag[39:8];
assign stage1_09_imag = s1_09_imag[39:8];
assign stage1_10_imag = s1_10_imag[39:8];
assign stage1_11_imag = s1_11_imag[39:8];
assign stage1_12_imag = s1_12_imag[39:8];
assign stage1_13_imag = s1_13_imag[39:8];
assign stage1_14_imag = s1_14_imag[39:8];
assign stage1_15_imag = s1_15_imag[39:8];

always@(*)begin
  tmp0 = $signed(x0) - $signed(x8);
  tmp1 = $signed(x1) - $signed(x9);
  tmp2 = $signed(x2) - $signed(x10);
  tmp3 = $signed(x3) - $signed(x11);
  tmp4 = $signed(x4) - $signed(x12);
  tmp5 = $signed(x5) - $signed(x13);
  tmp6 = $signed(x6) - $signed(x14);
  tmp7 = $signed(x7) - $signed(x15);
end

always@(*)begin
  s1_00_real = $signed(x0) + $signed(x8);
  s1_01_real = $signed(x1) + $signed(x9);
  s1_02_real = $signed(x2) + $signed(x10);
  s1_03_real = $signed(x3) + $signed(x11);
  s1_04_real = $signed(x4) + $signed(x12);
  s1_05_real = $signed(x5) + $signed(x13);
  s1_06_real = $signed(x6) + $signed(x14);
  s1_07_real = $signed(x7) + $signed(x15);
  s1_08_real = $signed(tmp0) * $signed(32'h00010000);
  s1_09_real = $signed(tmp1) * $signed(32'h0000EC83);
  s1_10_real = $signed(tmp2) * $signed(32'h0000B504);
  s1_11_real = $signed(tmp3) * $signed(32'h000061F7);
  s1_12_real = $signed(tmp4) * $signed(32'h00000000);
  s1_13_real = $signed(tmp5) * $signed(32'hFFFF9E09);
  s1_14_real = $signed(tmp6) * $signed(32'hFFFF4AFC);
  s1_15_real = $signed(tmp7) * $signed(32'hFFFF137D);
end

always@(*)begin
  s1_08_imag = $signed(tmp0) * $signed(32'h00000000);
  s1_09_imag = $signed(tmp1) * $signed(32'hFFFF9E09);
  s1_10_imag = $signed(tmp2) * $signed(32'hFFFF4AFC);
  s1_11_imag = $signed(tmp3) * $signed(32'hFFFF137D);
  s1_12_imag = $signed(tmp4) * $signed(32'hFFFF0000);
  s1_13_imag = $signed(tmp5) * $signed(32'hFFFF137D);
  s1_14_imag = $signed(tmp6) * $signed(32'hFFFF4AFC);
  s1_15_imag = $signed(tmp7) * $signed(32'hFFFF9E09);
end

always@(posedge clk or posedge rst)begin
  if(rst)begin
    stage1_00 <= 64'd0;
    stage1_01 <= 64'd0;
    stage1_02 <= 64'd0;
    stage1_03 <= 64'd0;
    stage1_04 <= 64'd0;
    stage1_05 <= 64'd0;
    stage1_06 <= 64'd0;
    stage1_07 <= 64'd0;
    stage1_08 <= 64'd0;
    stage1_09 <= 64'd0;
    stage1_10 <= 64'd0;
    stage1_11 <= 64'd0;
    stage1_12 <= 64'd0;
    stage1_13 <= 64'd0;
    stage1_14 <= 64'd0;
    stage1_15 <= 64'd0;
  end
  else if(en)begin
    stage1_00 <= {stage1_00_real, 32'd0};
    stage1_01 <= {stage1_01_real, 32'd0};
    stage1_02 <= {stage1_02_real, 32'd0};
    stage1_03 <= {stage1_03_real, 32'd0};
    stage1_04 <= {stage1_04_real, 32'd0};
    stage1_05 <= {stage1_05_real, 32'd0};
    stage1_06 <= {stage1_06_real, 32'd0};
    stage1_07 <= {stage1_07_real, 32'd0};
    stage1_08 <= {stage1_08_real, stage1_08_imag};
    stage1_09 <= {stage1_09_real, stage1_09_imag};
    stage1_10 <= {stage1_10_real, stage1_10_imag};
    stage1_11 <= {stage1_11_real, stage1_11_imag};
    stage1_12 <= {stage1_12_real, stage1_12_imag};
    stage1_13 <= {stage1_13_real, stage1_13_imag};
    stage1_14 <= {stage1_14_real, stage1_14_imag};
    stage1_15 <= {stage1_15_real, stage1_15_imag};
  end
  else begin
  end
end

endmodule