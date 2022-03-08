module two_points_butterfly ( clk, rst, en,
                              x0, x1,
                              stage4_00, stage4_01
                            );
input clk, rst;
input en;
input [63:0] x0, x1;
output reg [31:0] stage4_00, stage4_01;

reg [31:0] tmp0_real;
reg [31:0] tmp0_imag;

reg [31:0] s4_00_real;
reg [63:0] s4_01_real;

reg [31:0] s4_00_imag;
reg [63:0] s4_01_imag;

wire [15:0] stage4_00_real;
wire [15:0] stage4_01_real;

wire [15:0] stage4_00_imag;
wire [15:0] stage4_01_imag;

/* Real part */
assign stage4_00_real = s4_00_real[23:8];
assign stage4_01_real = s4_01_real[39:24];

/* Imag part */
assign stage4_00_imag = s4_00_imag[23:8];
assign stage4_01_imag = s4_01_imag[39:24];

always@(*)begin
    tmp0_real = $signed(x0[63:32]) - $signed(x1[63:32]);
    tmp0_imag = $signed(x0[31:0]) - $signed(x1[31:0]);
end

always@(*)begin
    s4_00_real = $signed(x0[63:32]) + $signed(x1[63:32]);
    s4_01_real = $signed(tmp0_real) * $signed(32'h00010000) - $signed(tmp0_imag) * $signed(32'h00000000);
  end
  
  always@(*)begin
    s4_00_imag = $signed(x0[31:0]) + $signed(x1[31:0]);
    s4_01_imag = $signed(tmp0_real) * $signed(32'h00000000) + $signed(tmp0_imag) * $signed(32'h00010000);
  end

always@(posedge clk or posedge rst)begin
    if(rst)begin
      stage4_00 <= 32'd0;
      stage4_01 <= 32'd0;
    end
    else if(en)begin
      stage4_00 <= {stage4_00_real, stage4_00_imag};
      stage4_01 <= {stage4_01_real, stage4_01_imag};
    end
    else begin
    end
end

endmodule