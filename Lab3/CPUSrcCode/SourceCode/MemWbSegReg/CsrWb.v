`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Operator 1 Seg Reg
// Tool Versions: Vivado 2017.4.1
// Description: Operator 1 Seg Reg for ID\EX
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // ID\EX的CSR指令段寄存器
// 输入
    // clk               时钟信号
    // reg1              General Register File读取的寄存器1内容
    // reg2              Csr Register File读取的寄存器1内容
    // bubbleE           EX阶段的bubble信号
    // flushE            EX阶段的flush信号
// 输出
    // reg1_EX           传给下一流水段的寄存器1内容
    // reg2_EX           传给下一流水段的寄存器1内容
// 实验要求  
    // 无需修改

module Csr_WB(
    input wire clk, bubbleW, flushW,
    input wire csr_reg_write_en_MEM,
    input wire [11:0]csr_addr_MEM,
    input wire [31:0] out_MEM,
    output reg [31:0] out_WB,
    output reg [11:0]csr_addr_WB,
    output reg csr_reg_write_en_WB
    );

    initial 
    begin
    csr_reg_write_en_WB = 0;
    csr_addr_WB = 0;
    out_WB = 0;
    end
    
    always@(posedge clk)
        if (!bubbleW) 
        begin
            if (flushW)
            begin
                csr_reg_write_en_WB = 0;
                csr_addr_WB = 0;
                out_WB = 0;
            end
            else 
            begin
                csr_reg_write_en_WB = csr_reg_write_en_MEM;
                csr_addr_WB = csr_addr_MEM;
                out_WB = out_MEM;
            end
        end
    
endmodule