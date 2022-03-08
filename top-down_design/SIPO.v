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