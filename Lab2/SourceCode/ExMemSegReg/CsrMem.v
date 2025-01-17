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

module Csr_MEM(
    input wire clk, bubbleM, flushM,
    input wire csr_reg_write_en_EX,
    input wire [11:0]csr_addr_EX,
    input wire [31:0] out_EX,
    output reg [31:0] out_MEM,
    output reg [11:0]csr_addr_MEM,
    output reg csr_reg_write_en_MEM
    );

    initial 
    begin
    csr_reg_write_en_MEM = 0;
    csr_addr_MEM = 0;
    out_MEM = 0;
    end
    
    always@(posedge clk)
        if (!bubbleM) 
        begin
            if (flushM)
            begin
                csr_reg_write_en_MEM = 0;
                csr_addr_MEM = 0;
                out_MEM = 0;
            end
            else 
            begin
                csr_reg_write_en_MEM = csr_reg_write_en_EX;
                csr_addr_MEM = csr_addr_EX;
                out_MEM = out_EX;
            end
        end
    
endmodule