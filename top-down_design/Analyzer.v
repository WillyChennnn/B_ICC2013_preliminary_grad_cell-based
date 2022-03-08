`include "Comparator.v"
module Analyzer(clk,
                rst,
                fft_valid,
                fft_d0, fft_d1, fft_d2, fft_d3,
                fft_d4, fft_d5, fft_d6, fft_d7,
                fft_d8, fft_d9, fft_d10, fft_d11,
                fft_d12, fft_d13, fft_d14, fft_d15,
                done,
                freq
               );

input clk, rst;
input fft_valid;
input [31:0] fft_d0, fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7;
input [31:0] fft_d8, fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15;
output reg done;
output [3:0] freq;

reg [3:0] analyze_stage;
reg [1:0] cnt, n_cnt;

//s1
wire [31:0] s1_windata0, s1_windata1, s1_windata2, s1_windata3;
wire [31:0] s1_windata4, s1_windata5, s1_windata6, s1_windata7;
//s2
wire [31:0] s2_windata0, s2_windata1, s2_windata2, s2_windata3;
//s3
wire [31:0] s3_windata0, s3_windata1;
//s4
wire [31:0] s4_windata;

//s1
wire [3:0] s1_winfreq0, s1_winfreq1, s1_winfreq2, s1_winfreq3;
wire [3:0] s1_winfreq4, s1_winfreq5, s1_winfreq6, s1_winfreq7;
//s2
wire [3:0] s2_winfreq0, s2_winfreq1, s2_winfreq2, s2_winfreq3;
//s3
wire [3:0] s3_winfreq0, s3_winfreq1;
//s4
wire [3:0] s4_winfreq;


assign freq = (done)? s4_winfreq : 4'd0;

/*=========================== done, freq-----------------------------*/
always@(posedge clk or posedge rst)begin
    if(rst)begin
        done <= 1'b0;
    end
    else if(analyze_stage[0])begin
        done <= 1'b1;
    end
    else begin
        done <= 1'b0;
    end
end

/*------------------------- analyzer_enable------------------------ */
always@(*)begin
    if( fft_valid || cnt!=2'd0 )begin
        case(cnt)
            2'd0: analyze_stage = 4'b1000;
            2'd1: analyze_stage = 4'b0100;
            2'd2: analyze_stage = 4'b0010;
            2'd3: analyze_stage = 4'b0001;
            default: analyze_stage = 4'd0;
        endcase
    end
    else begin
        analyze_stage = 4'd0;
    end
end

/*--------------------------- counter -----------------------------*/
always@(posedge clk or posedge rst)begin
    if(rst)begin
        cnt <= 2'd0;
    end
    else begin
        cnt <= n_cnt;
    end
end
always@(*)begin
    if(cnt==2'd3)begin
        n_cnt = 2'd0;
    end
    else if( fft_valid || cnt!=2'd0 )begin
        n_cnt= cnt + 2'd1;
    end
    else begin
        n_cnt = 2'd0;
    end
end

/*-----------------------------------Comparator------------------------------------ */

/* Stage1 */
Comparator S1_Comparator0 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[3]),
                           .data1(fft_d0),
                           .data2(fft_d8),
                           .freq1(4'd0),
                           .freq2(4'd8),
                           .win_data(s1_windata0),
                           .win_freq(s1_winfreq0)
                          );
Comparator S1_Comparator1 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[3]),
                           .data1(fft_d4),
                           .data2(fft_d12),
                           .freq1(4'd4),
                           .freq2(4'd12),
                           .win_data(s1_windata1),
                           .win_freq(s1_winfreq1)
                          );
Comparator S1_Comparator2 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[3]),
                           .data1(fft_d2),
                           .data2(fft_d10),
                           .freq1(4'd2),
                           .freq2(4'd10),
                           .win_data(s1_windata2),
                           .win_freq(s1_winfreq2)
                          );
Comparator S1_Comparator3 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[3]),
                           .data1(fft_d6),
                           .data2(fft_d14),
                           .freq1(4'd6),
                           .freq2(4'd14),
                           .win_data(s1_windata3),
                           .win_freq(s1_winfreq3)
                          );
Comparator S1_Comparator4 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[3]),
                           .data1(fft_d1),
                           .data2(fft_d9),
                           .freq1(4'd1),
                           .freq2(4'd9),
                           .win_data(s1_windata4),
                           .win_freq(s1_winfreq4)
                          );
Comparator S1_Comparator5 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[3]),
                           .data1(fft_d5),
                           .data2(fft_d13),
                           .freq1(4'd5),
                           .freq2(4'd13),
                           .win_data(s1_windata5),
                           .win_freq(s1_winfreq5)
                          );
Comparator S1_Comparator6 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[3]),
                           .data1(fft_d3),
                           .data2(fft_d11),
                           .freq1(4'd3),
                           .freq2(4'd11),
                           .win_data(s1_windata6),
                           .win_freq(s1_winfreq6)
                          );
Comparator S1_Comparator7 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[3]),
                           .data1(fft_d7),
                           .data2(fft_d15),
                           .freq1(4'd7),
                           .freq2(4'd15),
                           .win_data(s1_windata7),
                           .win_freq(s1_winfreq7)
                          );
/* Stage2 */
Comparator S2_Comparator0 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[2]),
                           .data1(s1_windata0),
                           .data2(s1_windata1),
                           .freq1(s1_winfreq0),
                           .freq2(s1_winfreq1),
                           .win_data(s2_windata0),
                           .win_freq(s2_winfreq0)
                          );
Comparator S2_Comparator1 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[2]),
                           .data1(s1_windata2),
                           .data2(s1_windata3),
                           .freq1(s1_winfreq2),
                           .freq2(s1_winfreq3),
                           .win_data(s2_windata1),
                           .win_freq(s2_winfreq1)
                          );
Comparator S2_Comparator2 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[2]),
                           .data1(s1_windata4),
                           .data2(s1_windata5),
                           .freq1(s1_winfreq4),
                           .freq2(s1_winfreq5),
                           .win_data(s2_windata2),
                           .win_freq(s2_winfreq2)
                          );
Comparator S2_Comparator3 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[2]),
                           .data1(s1_windata6),
                           .data2(s1_windata7),
                           .freq1(s1_winfreq6),
                           .freq2(s1_winfreq7),
                           .win_data(s2_windata3),
                           .win_freq(s2_winfreq3)
                          );
/* stage3 */
Comparator S3_Comparator0 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[1]),
                           .data1(s2_windata0),
                           .data2(s2_windata1),
                           .freq1(s2_winfreq0),
                           .freq2(s2_winfreq1),
                           .win_data(s3_windata0),
                           .win_freq(s3_winfreq0)
                          );
Comparator S3_Comparator1 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[1]),
                           .data1(s2_windata2),
                           .data2(s2_windata3),
                           .freq1(s2_winfreq2),
                           .freq2(s2_winfreq3),
                           .win_data(s3_windata1),
                           .win_freq(s3_winfreq1)
                          );
/* stage4 */
Comparator S4_Comparator0 (.clk(clk),
                           .rst(rst),
                           .en(analyze_stage[0]),
                           .data1(s3_windata0),
                           .data2(s3_windata1),
                           .freq1(s3_winfreq0),
                           .freq2(s3_winfreq1),
                           .win_data(s4_windata),
                           .win_freq(s4_winfreq)
                          );                         
endmodule