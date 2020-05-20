`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: PC ID Seg Reg
// Tool Versions: Vivado 2017.4.1
// Description: PC seg reg for IF\ID
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // IF\ID的PC段寄存器
// 输入
    // clk               时钟信号
    // PC_IF             PC寄存器传来的指令地址
    // bubbleD           ID阶段的bubble信号
    // flushD            ID阶段的flush信号
// 输出
    // PC_ID             传给下一段寄存器的PC地址
// 实验要求  
    // 无需修改

module BTB(
    input wire clk,rst, 
    input wire [31:0] PC_IF,
    output reg [31:0] PC_predict,index
    );

    initial PC_ID = 0;
    
    always @(poseedge clk)
    begin
        if(rst)
        begin
            for(i = 0; i < 8; i++)begin
                PC_buffer[i] = 65{1'b0};
            end
        end
        else
        begin
            index = 8;
            for(i = 0; i < 8; i++)begin
                if(PC_buffer[i][64:33] == PC_IF && PC_buffer[i][0] = 1'b1) begin
                    flag = i; 
                end
                    
            end
        end
    end
    
endmodule