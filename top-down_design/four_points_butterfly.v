module four_points_butterfly (clk, rst, en,
                              x0, x1, x2, x3,
                              stage3_00, stage3_01, stage3_02, stage3_03
                             );

input clk, rst;
input en;
input [63:0] x0, x1, x2, x3;
output reg [63:0] stage3_00, stage3_01, stage3_02, stage3_03;

reg [31:0] tmp0_real, tmp1_real;
reg [31:0] tmp0_imag, tmp1_imag;

reg [31:0] s3_00_real, s3_01_real;
reg [63:0] s3_02_real, s3_03_real;

reg [31:0] s3_00_imag, s3_01_imag;
reg [63:0] s3_02_imag, s3_03_imag;

wire [31:0] stage3_00_real, stage3_01_real;
wire [31:0] stage3_02_real, stage3_03_real;

wire [31:0] stage3_00_imag, stage3_01_imag;
wire [31:0] stage3_02_imag, stage3_03_imag;

/* Real part */
assign stage3_00_real = s3_00_real;
assign stage3_01_real = s3_01_real;
assign stage3_02_real = s3_02_real[47:16];
assign stage3_03_real = s3_03_real[47:16];

/* Imag part */
assign stage3_00_imag = s3_00_imag;
assign stage3_01_imag = s3_01_imag;
assign stage3_02_imag = s3_02_imag[47:16];
assign stage3_03_imag = s3_03_imag[47:16];

always@(*)begin
    tmp0_real = $signed(x0[63:32]) - $signed(x2[63:32]);
    tmp1_real = $signed(x1[63:32]) - $signed(x3[63:32]);
    tmp0_imag = $signed(x0[31:0]) - $signed(x2[31:0]);
    tmp1_imag = $signed(x1[31:0]) - $signed(x3[31:0]);
end

always@(*)begin
    s3_00_real = $signed(x0[63:32]) + $signed(x2[63:32]);
    s3_01_real = $signed(x1[63:32]) + $signed(x3[63:32]);
    s3_02_real = $signed(tmp0_real) * $signed(32'h00010000) - $signed(tmp0_imag) * $signed(32'h00000000);
    s3_03_real = $signed(tmp1_real) * $signed(32'h00000000) - $signed(tmp1_imag) * $signed(32'hFFFF0000);
  end
  
  always@(*)begin
    s3_00_imag = $signed(x0[31:0]) + $signed(x2[31:0]);
    s3_01_imag = $signed(x1[31:0]) + $signed(x3[31:0]);
    s3_02_imag = $signed(tmp0_real) * $signed(32'h00000000) + $signed(tmp0_imag) * $signed(32'h00010000);
    s3_03_imag = $signed(tmp1_real) * $signed(32'hFFFF0000) + $signed(tmp1_imag) * $signed(32'h00000000);
  end

always@(posedge clk or posedge rst)begin
    if(rst)begin
      stage3_00 <= 64'd0;
      stage3_01 <= 64'd0;
      stage3_02 <= 64'd0;
      stage3_03 <= 64'd0;
    end
    else if(en)begin
      stage3_00 <= {stage3_00_real, stage3_00_imag};
      stage3_01 <= {stage3_01_real, stage3_01_imag};
      stage3_02 <= {stage3_02_real, stage3_02_imag};
      stage3_03 <= {stage3_03_real, stage3_03_imag};
    end
    else begin
    end
end

endmodule