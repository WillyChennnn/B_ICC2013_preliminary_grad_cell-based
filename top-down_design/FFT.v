`include "SIPO.v"
`include "sixteen_points_butterfly.v"
`include "eight_points_butterfly.v"
`include "four_points_butterfly.v"
`include "two_points_butterfly.v"

module FFT (clk,
            rst,
            fir_valid,
            fir_d,
            fft_valid,
            fft_d0, fft_d1, fft_d2, fft_d3,
            fft_d4, fft_d5, fft_d6, fft_d7,
            fft_d8, fft_d9, fft_d10, fft_d11,
            fft_d12, fft_d13, fft_d14, fft_d15
           );

input clk,rst;
input fir_valid;
input [15:0] fir_d;
output reg fft_valid;
output [31:0] fft_d0, fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7;
output [31:0] fft_d8, fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15;

wire x_valid;
wire [15:0] x0, x1, x2, x3;
wire [15:0] x4, x5, x6, x7;
wire [15:0] x8, x9, x10, x11;
wire [15:0] x12, x13, x14, x15;
/* stage 1 */
wire [63:0] stage1_00, stage1_01, stage1_02, stage1_03;
wire [63:0] stage1_04, stage1_05, stage1_06, stage1_07;
wire [63:0] stage1_08, stage1_09, stage1_10, stage1_11;
wire [63:0] stage1_12, stage1_13, stage1_14, stage1_15;
/* stage 2 */
wire [63:0] stage2_00, stage2_01, stage2_02, stage2_03;
wire [63:0] stage2_04, stage2_05, stage2_06, stage2_07;
wire [63:0] stage2_08, stage2_09, stage2_10, stage2_11;
wire [63:0] stage2_12, stage2_13, stage2_14, stage2_15;
/* stage 3 */
wire [63:0] stage3_00, stage3_01, stage3_02, stage3_03;
wire [63:0] stage3_04, stage3_05, stage3_06, stage3_07;
wire [63:0] stage3_08, stage3_09, stage3_10, stage3_11;
wire [63:0] stage3_12, stage3_13, stage3_14, stage3_15;


reg [3:0] stage;
reg [2:0] stage_cnt, n_stage_cnt;

SIPO SIPO0 (.clk(clk),
            .rst(rst),
            .fir_valid(fir_valid),
            .fir_d(fir_d),
            .x_valid(x_valid),
            .x0(x0), .x1(x1), .x2(x2), .x3(x3),
            .x4(x4), .x5(x5), .x6(x6), .x7(x7),
            .x8(x8), .x9(x9), .x10(x10), .x11(x11),
            .x12(x12), .x13(x13), .x14(x14), .x15(x15)
           );
/*----------------------------stage 1-----------------------------*/
sixteen_points_butterfly sixteen_points_butterfly0 (.clk(clk), .rst(rst), .en(stage[3]),
                                                    .x0(x0), .x1(x1), .x2(x2), .x3(x3),
                                                    .x4(x4), .x5(x5), .x6(x6), .x7(x7),
                                                    .x8(x8), .x9(x9), .x10(x10), .x11(x11),
                                                    .x12(x12), .x13(x13), .x14(x14), .x15(x15),
                                                    .stage1_00(stage1_00), .stage1_01(stage1_01), .stage1_02(stage1_02), .stage1_03(stage1_03),
                                                    .stage1_04(stage1_04), .stage1_05(stage1_05), .stage1_06(stage1_06), .stage1_07(stage1_07),
                                                    .stage1_08(stage1_08), .stage1_09(stage1_09), .stage1_10(stage1_10), .stage1_11(stage1_11),
                                                    .stage1_12(stage1_12), .stage1_13(stage1_13), .stage1_14(stage1_14), .stage1_15(stage1_15)
                                                   );
/*----------------------------stage 2-----------------------------*/
eight_points_butterfly eight_points_butterfly0 (.clk(clk), .rst(rst), .en(stage[2]),
                                                .x0(stage1_00), .x1(stage1_01), .x2(stage1_02), .x3(stage1_03),
                                                .x4(stage1_04), .x5(stage1_05), .x6(stage1_06), .x7(stage1_07),
                                                .stage2_00(stage2_00), .stage2_01(stage2_01), .stage2_02(stage2_02), .stage2_03(stage2_03),
                                                .stage2_04(stage2_04), .stage2_05(stage2_05), .stage2_06(stage2_06), .stage2_07(stage2_07)
                                               );
eight_points_butterfly eight_points_butterfly1 (.clk(clk), .rst(rst), .en(stage[2]),
                                                .x0(stage1_08), .x1(stage1_09), .x2(stage1_10), .x3(stage1_11),
                                                .x4(stage1_12), .x5(stage1_13), .x6(stage1_14), .x7(stage1_15),
                                                .stage2_00(stage2_08), .stage2_01(stage2_09), .stage2_02(stage2_10), .stage2_03(stage2_11),
                                                .stage2_04(stage2_12), .stage2_05(stage2_13), .stage2_06(stage2_14), .stage2_07(stage2_15)
                                               );
/*----------------------------stage 3-----------------------------*/
four_points_butterfly four_points_butterfly0 (.clk(clk), .rst(rst), .en(stage[1]),
                                              .x0(stage2_00), .x1(stage2_01), .x2(stage2_02), .x3(stage2_03),
                                              .stage3_00(stage3_00), .stage3_01(stage3_01), .stage3_02(stage3_02), .stage3_03(stage3_03)
                                             );
four_points_butterfly four_points_butterfly1 (.clk(clk), .rst(rst), .en(stage[1]),
                                              .x0(stage2_04), .x1(stage2_05), .x2(stage2_06), .x3(stage2_07),
                                              .stage3_00(stage3_04), .stage3_01(stage3_05), .stage3_02(stage3_06), .stage3_03(stage3_07)
                                             );
four_points_butterfly four_points_butterfly2 (.clk(clk), .rst(rst), .en(stage[1]),
                                              .x0(stage2_08), .x1(stage2_09), .x2(stage2_10), .x3(stage2_11),
                                              .stage3_00(stage3_08), .stage3_01(stage3_09), .stage3_02(stage3_10), .stage3_03(stage3_11)
                                             );
four_points_butterfly four_points_butterfly3 (.clk(clk), .rst(rst), .en(stage[1]),
                                              .x0(stage2_12), .x1(stage2_13), .x2(stage2_14), .x3(stage2_15),
                                              .stage3_00(stage3_12), .stage3_01(stage3_13), .stage3_02(stage3_14), .stage3_03(stage3_15)
                                             );
/*----------------------------stage 4-----------------------------*/
two_points_butterfly two_points_butterfly0 (.clk(clk), .rst(rst), .en(stage[0]),
                                            .x0(stage3_00), .x1(stage3_01),
                                            .stage4_00(fft_d0), .stage4_01(fft_d8)
                                           );
two_points_butterfly two_points_butterfly1 (.clk(clk), .rst(rst), .en(stage[0]),
                                            .x0(stage3_02), .x1(stage3_03),
                                            .stage4_00(fft_d4), .stage4_01(fft_d12)
                                           );
two_points_butterfly two_points_butterfly2 (.clk(clk), .rst(rst), .en(stage[0]),
                                            .x0(stage3_04), .x1(stage3_05),
                                            .stage4_00(fft_d2), .stage4_01(fft_d10)
                                           );
two_points_butterfly two_points_butterfly3 (.clk(clk), .rst(rst), .en(stage[0]),
                                            .x0(stage3_06), .x1(stage3_07),
                                            .stage4_00(fft_d6), .stage4_01(fft_d14)
                                           );
two_points_butterfly two_points_butterfly4 (.clk(clk), .rst(rst), .en(stage[0]),
                                            .x0(stage3_08), .x1(stage3_09),
                                            .stage4_00(fft_d1), .stage4_01(fft_d9)
                                           );
two_points_butterfly two_points_butterfly5 (.clk(clk), .rst(rst), .en(stage[0]),
                                            .x0(stage3_10), .x1(stage3_11),
                                            .stage4_00(fft_d5), .stage4_01(fft_d13)
                                           );
two_points_butterfly two_points_butterfly6 (.clk(clk), .rst(rst), .en(stage[0]),
                                            .x0(stage3_12), .x1(stage3_13),
                                            .stage4_00(fft_d3), .stage4_01(fft_d11)
                                           );
two_points_butterfly two_points_butterfly7 (.clk(clk), .rst(rst), .en(stage[0]),
                                            .x0(stage3_14), .x1(stage3_15),
                                            .stage4_00(fft_d7), .stage4_01(fft_d15)
                                           );
/*------------------------------------------------------------------------------------------------------------------------*/
/* fft finish signal */
always@(posedge clk or posedge rst)begin
    if(rst)begin
        fft_valid <= 1'b0;
    end
    else if(stage[0])begin
        fft_valid <= 1'b1;
    end
    else begin
        fft_valid <= 1'b0;
    end
end

/* enable count */
always@(posedge clk or posedge rst)begin
    if(rst)begin
        stage_cnt <= 3'd0;
    end
    else if(x_valid)begin
        stage_cnt <= 3'd1;
    end
    else begin
        stage_cnt <= n_stage_cnt;
    end
end
always@(*)begin
    if(stage_cnt!=3'd0)begin
        if(stage_cnt == 3'd4)begin
            n_stage_cnt = 3'd0;
        end
        else begin
            n_stage_cnt = stage_cnt + 3'd1;
        end
    end
    else begin
        n_stage_cnt = 3'd0;
    end
end

/* PE element enable */
always@(*)begin
    case(stage_cnt)
        3'd1:stage = 4'b1000;
        3'd2:stage = 4'b0100;
        3'd3:stage = 4'b0010;
        3'd4:stage = 4'b0001;
        default:stage = 4'b0000;
    endcase
end


endmodule