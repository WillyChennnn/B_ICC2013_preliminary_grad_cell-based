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