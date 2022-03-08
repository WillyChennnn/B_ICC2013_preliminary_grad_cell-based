module  FAS (data_valid, data, clk, rst, fir_d, fir_valid, fft_valid, done, freq,
 fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8,
 fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0);
input clk, rst;
input data_valid;
input [15:0] data; 

output fir_valid, fft_valid;
output [15:0] fir_d;
output [31:0] fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8;
output [31:0] fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0;
output done;
output [3:0] freq;
//`include "./dat/FIR_coefficient.dat"

FIR_filter FIR (.clk(clk),
                 .rst(rst),
                 .data_valid(data_valid),
                 .data(data),
                 .fir_valid(fir_valid),
                 .fir_d(fir_d)
                );

FFT FFT (.clk(clk),
         .rst(rst),
         .fir_valid(fir_valid),
         .fir_d(fir_d),
         .fft_valid(fft_valid),
         .fft_d0(fft_d0), .fft_d1(fft_d1), .fft_d2(fft_d2), .fft_d3(fft_d3),
         .fft_d4(fft_d4), .fft_d5(fft_d5), .fft_d6(fft_d6), .fft_d7(fft_d7),
         .fft_d8(fft_d8), .fft_d9(fft_d9), .fft_d10(fft_d10), .fft_d11(fft_d11),
         .fft_d12(fft_d12), .fft_d13(fft_d13), .fft_d14(fft_d14), .fft_d15(fft_d15)
        );

Analyzer Analyze (.clk(clk),
                  .rst(rst),
                  .fft_valid(fft_valid),
                  .fft_d0(fft_d0), .fft_d1(fft_d1), .fft_d2(fft_d2), .fft_d3(fft_d3),
                  .fft_d4(fft_d4), .fft_d5(fft_d5), .fft_d6(fft_d6), .fft_d7(fft_d7),
                  .fft_d8(fft_d8), .fft_d9(fft_d9), .fft_d10(fft_d10), .fft_d11(fft_d11),
                  .fft_d12(fft_d12), .fft_d13(fft_d13), .fft_d14(fft_d14), .fft_d15(fft_d15),
                  .done(done),
                  .freq(freq)
                 );

endmodule

module FIR_filter (clk,
                   rst,
                   data_valid,
                   data,
                   fir_valid,
                   fir_d
                  );

input clk,rst;
input data_valid;
input [15:0] data;
output fir_valid;
output [15:0] fir_d;

/* parameter declartion */
parameter signed [19:0] FIR_C00 = 20'hFFF9E ;     //The FIR_coefficient value 0: -1.495361e-003
parameter signed [19:0] FIR_C01 = 20'hFFF86 ;     //The FIR_coefficient value 1: -1.861572e-003
parameter signed [19:0] FIR_C02 = 20'hFFFA7 ;     //The FIR_coefficient value 2: -1.358032e-003
parameter signed [19:0] FIR_C03 = 20'h0003B ;    //The FIR_coefficient value 3: 9.002686e-004
parameter signed [19:0] FIR_C04 = 20'h0014B ;    //The FIR_coefficient value 4: 5.050659e-003
parameter signed [19:0] FIR_C05 = 20'h0024A ;    //The FIR_coefficient value 5: 8.941650e-003
parameter signed [19:0] FIR_C06 = 20'h00222 ;    //The FIR_coefficient value 6: 8.331299e-003
parameter signed [19:0] FIR_C07 = 20'hFFFE4 ;     //The FIR_coefficient value 7: -4.272461e-004
parameter signed [19:0] FIR_C08 = 20'hFFBC5 ;     //The FIR_coefficient value 8: -1.652527e-002
parameter signed [19:0] FIR_C09 = 20'hFF7CA ;     //The FIR_coefficient value 9: -3.207397e-002
parameter signed [19:0] FIR_C10 = 20'hFF74E ;     //The FIR_coefficient value 10: -3.396606e-002
parameter signed [19:0] FIR_C11 = 20'hFFD74 ;     //The FIR_coefficient value 11: -9.948730e-003
parameter signed [19:0] FIR_C12 = 20'h00B1A ;    //The FIR_coefficient value 12: 4.336548e-002
parameter signed [19:0] FIR_C13 = 20'h01DAC ;    //The FIR_coefficient value 13: 1.159058e-001
parameter signed [19:0] FIR_C14 = 20'h02F9E ;    //The FIR_coefficient value 14: 1.860046e-001
parameter signed [19:0] FIR_C15 = 20'h03AA9 ;    //The FIR_coefficient value 15: 2.291412e-001
parameter signed [19:0] FIR_C16 = 20'h03AA9 ;    //The FIR_coefficient value 16: 2.291412e-001
parameter signed [19:0] FIR_C17 = 20'h02F9E ;    //The FIR_coefficient value 17: 1.860046e-001
parameter signed [19:0] FIR_C18 = 20'h01DAC ;    //The FIR_coefficient value 18: 1.159058e-001
parameter signed [19:0] FIR_C19 = 20'h00B1A ;    //The FIR_coefficient value 19: 4.336548e-002
parameter signed [19:0] FIR_C20 = 20'hFFD74 ;     //The FIR_coefficient value 20: -9.948730e-003
parameter signed [19:0] FIR_C21 = 20'hFF74E ;     //The FIR_coefficient value 21: -3.396606e-002
parameter signed [19:0] FIR_C22 = 20'hFF7CA ;     //The FIR_coefficient value 22: -3.207397e-002
parameter signed [19:0] FIR_C23 = 20'hFFBC5 ;     //The FIR_coefficient value 23: -1.652527e-002
parameter signed [19:0] FIR_C24 = 20'hFFFE4 ;     //The FIR_coefficient value 24: -4.272461e-004
parameter signed [19:0] FIR_C25 = 20'h00222 ;    //The FIR_coefficient value 25: 8.331299e-003
parameter signed [19:0] FIR_C26 = 20'h0024A ;    //The FIR_coefficient value 26: 8.941650e-003
parameter signed [19:0] FIR_C27 = 20'h0014B ;    //The FIR_coefficient value 27: 5.050659e-003
parameter signed [19:0] FIR_C28 = 20'h0003B ;    //The FIR_coefficient value 28: 9.002686e-004
parameter signed [19:0] FIR_C29 = 20'hFFFA7 ;     //The FIR_coefficient value 29: -1.358032e-003
parameter signed [19:0] FIR_C30 = 20'hFFF86 ;     //The FIR_coefficient value 30: -1.861572e-003
parameter signed [19:0] FIR_C31 = 20'hFFF9E ;     //The FIR_coefficient value 31: -1.495361e-003


reg [5:0] cnt,next_cnt;
reg [15:0] data_set [0:30];
reg [35:0] tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9;
reg [35:0] tmp10, tmp11, tmp12, tmp13, tmp14, tmp15, tmp16, tmp17, tmp18, tmp19;
reg [35:0] tmp20, tmp21, tmp22, tmp23, tmp24, tmp25, tmp26, tmp27, tmp28, tmp29;
reg [35:0] tmp30, tmp31;

reg signed [36:0] sum1, sum2, sum3, sum4;
reg signed [36:0] sum5, sum6, sum7, sum8;

wire signed [37:0] total;

assign fir_valid = (cnt == 6'd33)?1'b1:1'b0;
assign fir_d = (total[37])? total[31:16]+1'b1 : total[31:16];
assign total = $signed(sum1) + $signed(sum2) + $signed(sum3) + $signed(sum4) + $signed(sum5) + $signed(sum6) + $signed(sum7) + $signed(sum8);


/*counter*/
always@(posedge clk or posedge rst)begin
    if(rst)begin
        cnt<=6'd0;
    end
    else begin
        cnt<=next_cnt;
    end
end
always@(*)begin
    if(data_valid)begin
        if(cnt==6'd33)begin
            next_cnt=cnt;
        end
        else begin
            next_cnt=cnt+6'd1;
        end
    end
    else begin
        next_cnt=cnt;
    end
end

// data_set 1 signed bit, 7bit for integer, 8bits for decimal digitd
always@(posedge clk or posedge rst)begin
    if(rst)begin
        data_set[0]<=16'd0;
        data_set[1]<=16'd0;
        data_set[2]<=16'd0;
        data_set[3]<=16'd0;
        data_set[4]<=16'd0;
        data_set[5]<=16'd0;
        data_set[6]<=16'd0;
        data_set[7]<=16'd0;
        data_set[8]<=16'd0;
        data_set[9]<=16'd0;
        data_set[10]<=16'd0;
        data_set[11]<=16'd0;
        data_set[12]<=16'd0;
        data_set[13]<=16'd0;
        data_set[14]<=16'd0;
        data_set[15]<=16'd0;
        data_set[16]<=16'd0;
        data_set[17]<=16'd0;
        data_set[18]<=16'd0;
        data_set[19]<=16'd0;
        data_set[20]<=16'd0;
        data_set[21]<=16'd0;
        data_set[22]<=16'd0;
        data_set[23]<=16'd0;
        data_set[24]<=16'd0;
        data_set[25]<=16'd0;
        data_set[26]<=16'd0;
        data_set[27]<=16'd0;
        data_set[28]<=16'd0;
        data_set[29]<=16'd0;
        data_set[30]<=16'd0;
    end
    else if(data_valid)begin
        data_set[0]<=data;
        data_set[1]<=data_set[0];
        data_set[2]<=data_set[1];
        data_set[3]<=data_set[2];
        data_set[4]<=data_set[3];
        data_set[5]<=data_set[4];
        data_set[6]<=data_set[5];
        data_set[7]<=data_set[6];
        data_set[8]<=data_set[7];
        data_set[9]<=data_set[8];
        data_set[10]<=data_set[9];
        data_set[11]<=data_set[10];
        data_set[12]<=data_set[11];
        data_set[13]<=data_set[12];
        data_set[14]<=data_set[13];
        data_set[15]<=data_set[14];
        data_set[16]<=data_set[15];
        data_set[17]<=data_set[16];
        data_set[18]<=data_set[17];
        data_set[19]<=data_set[18];
        data_set[20]<=data_set[19];
        data_set[21]<=data_set[20];
        data_set[22]<=data_set[21];
        data_set[23]<=data_set[22];
        data_set[24]<=data_set[23];
        data_set[25]<=data_set[24];
        data_set[26]<=data_set[25];
        data_set[27]<=data_set[26];
        data_set[28]<=data_set[27];
        data_set[29]<=data_set[28];
        data_set[30]<=data_set[29];      
    end
    else begin
    end
end

/*FIR Process*/
always@(*)begin
    tmp0 =  $signed(data) * $signed(FIR_C31);
    tmp1 =  $signed(data_set[0]) *  $signed(FIR_C30);
    tmp2 =  $signed(data_set[1]) *  $signed(FIR_C29);
    tmp3 =  $signed(data_set[2]) *  $signed(FIR_C28);
    tmp4 =  $signed(data_set[3]) *  $signed(FIR_C27);
    tmp5 =  $signed(data_set[4]) *  $signed(FIR_C26);
    tmp6 =  $signed(data_set[5]) *  $signed(FIR_C25);
    tmp7 =  $signed(data_set[6]) *  $signed(FIR_C24);
    tmp8 =  $signed(data_set[7]) *  $signed(FIR_C23);
    tmp9 =  $signed(data_set[8]) *  $signed(FIR_C22);
    tmp10 = $signed(data_set[9]) *  $signed(FIR_C21);
    tmp11 = $signed(data_set[10]) * $signed(FIR_C20);
    tmp12 = $signed(data_set[11]) * $signed(FIR_C19);
    tmp13 = $signed(data_set[12]) * $signed(FIR_C18);
    tmp14 = $signed(data_set[13]) * $signed(FIR_C17);
    tmp15 = $signed(data_set[14]) * $signed(FIR_C16);
    tmp16 = $signed(data_set[15]) * $signed(FIR_C15);
    tmp17 = $signed(data_set[16]) * $signed(FIR_C14);
    tmp18 = $signed(data_set[17]) * $signed(FIR_C13);
    tmp19 = $signed(data_set[18]) * $signed(FIR_C12);
    tmp20 = $signed(data_set[19]) * $signed(FIR_C11);
    tmp21 = $signed(data_set[20]) * $signed(FIR_C10);
    tmp22 = $signed(data_set[21]) * $signed(FIR_C09);
    tmp23 = $signed(data_set[22]) * $signed(FIR_C08);
    tmp24 = $signed(data_set[23]) * $signed(FIR_C07);
    tmp25 = $signed(data_set[24]) * $signed(FIR_C06);
    tmp26 = $signed(data_set[25]) * $signed(FIR_C05);
    tmp27 = $signed(data_set[26]) * $signed(FIR_C04);
    tmp28 = $signed(data_set[27]) * $signed(FIR_C03);
    tmp29 = $signed(data_set[28]) * $signed(FIR_C02);
    tmp30 = $signed(data_set[29]) * $signed(FIR_C01);
    tmp31 = $signed(data_set[30]) * $signed(FIR_C00);
end


/* Summation for all data */
always@(posedge clk or posedge rst)begin
    if(rst)begin
        sum1<=37'd0;
        sum2<=37'd0;
        sum3<=37'd0;
        sum4<=37'd0;
        sum5<=37'd0;
        sum6<=37'd0;
        sum7<=37'd0;
        sum8<=37'd0;
    end
    else begin
        sum1 <= $signed(tmp0) + $signed(tmp1) + $signed(tmp2) + $signed(tmp3);
        sum2 <= $signed(tmp4) + $signed(tmp5) + $signed(tmp6) + $signed(tmp7);
        sum3 <= $signed(tmp8) + $signed(tmp9) + $signed(tmp10) + $signed(tmp11);
        sum4 <= $signed(tmp12) + $signed(tmp13) + $signed(tmp14) + $signed(tmp15);
        sum5 <= $signed(tmp16) + $signed(tmp17) + $signed(tmp18) + $signed(tmp19);
        sum6 <= $signed(tmp20) + $signed(tmp21) + $signed(tmp22) + $signed(tmp23);
        sum7 <= $signed(tmp24) + $signed(tmp25) + $signed(tmp26) + $signed(tmp27);
        sum8 <= $signed(tmp28) + $signed(tmp29) + $signed(tmp30) + $signed(tmp31);
    end
end

endmodule

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

module Comparator (clk,
                   rst,
                   en,
                   data1,
                   data2,
                   freq1,
                   freq2,
                   win_data,
                   win_freq
                  );

input clk, rst;
input en;
input [31:0] data1, data2;
input [3:0] freq1,freq2;
output reg [31:0] win_data;
output reg [3:0] win_freq;

reg [31:0] max;
reg [3:0] max_freq;

reg [31:0] data1_real, data1_imag;
reg [31:0] data2_real, data2_imag;
reg [32:0] data1_sum, data2_sum;
reg [33:0] diff;


always@(posedge clk or posedge rst)begin
    if(rst)begin
        win_data <= 32'd0;
        win_freq <= 4'd0;
    end
    else if(en)begin
        win_data <= max;
        win_freq <= max_freq;
    end
    else begin
    end
end

always@(*)begin
    data1_real = $signed(data1[31:16]) * $signed(data1[31:16]);
    data1_imag = $signed(data1[15:0]) * $signed(data1[15:0]);
    data2_real = $signed(data2[31:16]) * $signed(data2[31:16]);
    data2_imag = $signed(data2[15:0]) * $signed(data2[15:0]);
    data1_sum = data1_real + data1_imag;
    data2_sum = data2_real + data2_imag;
    diff = data1_sum - data2_sum;
end

always@(*)begin
    if(diff[33])begin
        max = data2;
        max_freq = freq2;
    end
    else begin
        max = data1;
        max_freq = freq1;
    end
end

endmodule

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

module SIPO ( clk,
              rst,
              fir_valid,
              fir_d,
              x_valid,
              x0, x1, x2, x3,
              x4, x5, x6, x7,
              x8, x9, x10, x11,
              x12, x13, x14, x15
            );

input clk, rst;
input fir_valid;
input [15:0] fir_d;
output x_valid;
output reg [15:0] x0, x1, x2, x3;
output reg [15:0] x4, x5, x6, x7;
output reg [15:0] x8, x9, x10, x11;
output reg [15:0] x12, x13, x14, x15;

reg [15:0] reg0, reg1, reg2, reg3;
reg [15:0] reg4, reg5, reg6, reg7;
reg [15:0] reg8, reg9, reg10, reg11;
reg [15:0] reg12, reg13, reg14;

assign x_valid=(cnt==4'd15)?1'b1:1'b0;

reg [3:0] cnt, n_cnt;

/* counter */
always@(posedge clk or posedge rst)begin
    if(rst)begin
        cnt<=4'd0;
    end
    else begin
        cnt<=n_cnt;
    end
end
always@(*)begin
    if(fir_valid)begin
        if(cnt==4'd15)begin
            n_cnt=4'd0;
        end
        else begin
            n_cnt=cnt+4'd1;
        end
    end
    else begin
        n_cnt=4'd0;
    end
end

always@(posedge clk or posedge rst)begin
    if(rst)begin
        x0 <= 16'd0;
        x1 <= 16'd0;
        x2 <= 16'd0;
        x3 <= 16'd0;
        x4 <= 16'd0;
        x5 <= 16'd0;
        x6 <= 16'd0;
        x7 <= 16'd0;
        x8 <= 16'd0;
        x9 <= 16'd0;
        x10 <= 16'd0;
        x11 <= 16'd0;
        x12 <= 16'd0;
        x13 <= 16'd0;
        x14 <= 16'd0;
        x15 <= 16'd0;
    end
    else if(x_valid)begin
        x0 <= reg0;
        x1 <= reg1;
        x2 <= reg2;
        x3 <= reg3;
        x4 <= reg4;
        x5 <= reg5;
        x6 <= reg6;
        x7 <= reg7;
        x8 <= reg8;
        x9 <= reg9;
        x10 <= reg10;
        x11 <= reg11;
        x12 <= reg12;
        x13 <= reg13;
        x14 <= reg14;
        x15 <= fir_d;
    end
    else begin
    end
end

always@(posedge clk or posedge rst)begin
    if(rst)begin
        reg0 <= 16'd0;
        reg1 <= 16'd0;
        reg2 <= 16'd0; 
        reg3 <= 16'd0; 
        reg4 <= 16'd0; 
        reg5 <= 16'd0; 
        reg6 <= 16'd0; 
        reg7 <= 16'd0; 
        reg8 <= 16'd0; 
        reg9 <= 16'd0; 
        reg10 <= 16'd0; 
        reg11 <= 16'd0; 
        reg12 <= 16'd0; 
        reg13 <= 16'd0; 
        reg14 <= 16'd0;
    end
    else begin
        case(cnt)
            4'd0: reg0 <= fir_d;
            4'd1: reg1 <= fir_d;
            4'd2: reg2 <= fir_d;
            4'd3: reg3 <= fir_d;
            4'd4: reg4 <= fir_d;
            4'd5: reg5 <= fir_d;
            4'd6: reg6 <= fir_d;
            4'd7: reg7 <= fir_d;
            4'd8: reg8 <= fir_d;
            4'd9: reg9 <= fir_d;
            4'd10: reg10 <= fir_d;
            4'd11: reg11 <= fir_d;
            4'd12: reg12 <= fir_d;
            4'd13: reg13 <= fir_d;
            4'd14: reg14 <= fir_d;
        endcase
    end
end

endmodule

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