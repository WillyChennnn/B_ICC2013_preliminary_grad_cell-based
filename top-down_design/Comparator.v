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