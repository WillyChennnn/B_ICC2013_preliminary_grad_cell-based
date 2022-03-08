module eight_points_butterfly ( clk, rst, en,
                                x0, x1, x2, x3,
                                x4, x5, x6, x7,
                                stage2_00, stage2_01, stage2_02, stage2_03,
                                stage2_04, stage2_05, stage2_06, stage2_07
                              );
input clk, rst;
input en;
input [63:0] x0, x1, x2, x3;
input [63:0] x4, x5, x6, x7;

output reg [63:0] stage2_00, stage2_01, stage2_02, stage2_03;
output reg [63:0] stage2_04, stage2_05, stage2_06, stage2_07;

reg [31:0] tmp0_real, tmp1_real, tmp2_real, tmp3_real;
reg [31:0] tmp0_imag, tmp1_imag, tmp2_imag, tmp3_imag;

reg [31:0] s2_00_real, s2_01_real, s2_02_real, s2_03_real;
reg [63:0] s2_04_real, s2_05_real, s2_06_real, s2_07_real;

reg [31:0] s2_00_imag, s2_01_imag, s2_02_imag, s2_03_imag;
reg [63:0] s2_04_imag, s2_05_imag, s2_06_imag, s2_07_imag;

wire [31:0] stage2_00_real, stage2_01_real, stage2_02_real, stage2_03_real;
wire [31:0] stage2_04_real, stage2_05_real, stage2_06_real, stage2_07_real;

wire [31:0] stage2_00_imag, stage2_01_imag, stage2_02_imag, stage2_03_imag;
wire [31:0] stage2_04_imag, stage2_05_imag, stage2_06_imag, stage2_07_imag;

/* Real part */
assign stage2_00_real = s2_00_real;
assign stage2_01_real = s2_01_real;
assign stage2_02_real = s2_02_real;
assign stage2_03_real = s2_03_real;
assign stage2_04_real = s2_04_real[47:16];
assign stage2_05_real = s2_05_real[47:16];
assign stage2_06_real = s2_06_real[47:16];
assign stage2_07_real = s2_07_real[47:16];

/* Imag part */
assign stage2_00_imag = s2_00_imag;
assign stage2_01_imag = s2_01_imag;
assign stage2_02_imag = s2_02_imag;
assign stage2_03_imag = s2_03_imag;
assign stage2_04_imag = s2_04_imag[47:16];
assign stage2_05_imag = s2_05_imag[47:16];
assign stage2_06_imag = s2_06_imag[47:16];
assign stage2_07_imag = s2_07_imag[47:16];

always@(*)begin
  tmp0_real = $signed(x0[63:32]) - $signed(x4[63:32]);
  tmp1_real = $signed(x1[63:32]) - $signed(x5[63:32]);
  tmp2_real = $signed(x2[63:32]) - $signed(x6[63:32]);
  tmp3_real = $signed(x3[63:32]) - $signed(x7[63:32]);
  tmp0_imag = $signed(x0[31:0]) - $signed(x4[31:0]);
  tmp1_imag = $signed(x1[31:0]) - $signed(x5[31:0]);
  tmp2_imag = $signed(x2[31:0]) - $signed(x6[31:0]);
  tmp3_imag = $signed(x3[31:0]) - $signed(x7[31:0]);
end

always@(*)begin
  s2_00_real = $signed(x0[63:32]) + $signed(x4[63:32]);
  s2_01_real = $signed(x1[63:32]) + $signed(x5[63:32]);
  s2_02_real = $signed(x2[63:32]) + $signed(x6[63:32]);
  s2_03_real = $signed(x3[63:32]) + $signed(x7[63:32]);
  s2_04_real = $signed(tmp0_real) * $signed(32'h00010000) - $signed(tmp0_imag) * $signed(32'h00000000);
  s2_05_real = $signed(tmp1_real) * $signed(32'h0000B504) - $signed(tmp1_imag) * $signed(32'hFFFF4AFC);
  s2_06_real = $signed(tmp2_real) * $signed(32'h00000000) - $signed(tmp2_imag) * $signed(32'hFFFF0000);
  s2_07_real = $signed(tmp3_real) * $signed(32'hFFFF4AFC) - $signed(tmp3_imag) * $signed(32'hFFFF4AFC);
end

always@(*)begin
  s2_00_imag = $signed(x0[31:0]) + $signed(x4[31:0]);
  s2_01_imag = $signed(x1[31:0]) + $signed(x5[31:0]);
  s2_02_imag = $signed(x2[31:0]) + $signed(x6[31:0]);
  s2_03_imag = $signed(x3[31:0]) + $signed(x7[31:0]);  
  s2_04_imag = $signed(tmp0_real) * $signed(32'h00000000) + $signed(tmp0_imag) * $signed(32'h00010000);
  s2_05_imag = $signed(tmp1_real) * $signed(32'hFFFF4AFC) + $signed(tmp1_imag) * $signed(32'h0000B504);
  s2_06_imag = $signed(tmp2_real) * $signed(32'hFFFF0000) + $signed(tmp2_imag) * $signed(32'h00000000);
  s2_07_imag = $signed(tmp3_real) * $signed(32'hFFFF4AFC) + $signed(tmp3_imag) * $signed(32'hFFFF4AFC);
end

always@(posedge clk or posedge rst)begin
  if(rst)begin
    stage2_00 <= 64'd0;
    stage2_01 <= 64'd0;
    stage2_02 <= 64'd0;
    stage2_03 <= 64'd0;
    stage2_04 <= 64'd0;
    stage2_05 <= 64'd0;
    stage2_06 <= 64'd0;
    stage2_07 <= 64'd0;
  end
  else if(en)begin
    stage2_00 <= {stage2_00_real, stage2_00_imag};
    stage2_01 <= {stage2_01_real, stage2_01_imag};
    stage2_02 <= {stage2_02_real, stage2_02_imag};
    stage2_03 <= {stage2_03_real, stage2_03_imag};
    stage2_04 <= {stage2_04_real, stage2_04_imag};
    stage2_05 <= {stage2_05_real, stage2_05_imag};
    stage2_06 <= {stage2_06_real, stage2_06_imag};
    stage2_07 <= {stage2_07_real, stage2_07_imag};
  end
  else begin
  end
end

endmodule