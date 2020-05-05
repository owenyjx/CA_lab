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

module Csr_EX(
    input wire clk, bubbleE, flushE,
    input wire [31:0] reg1_ID,
    input wire [31:0] reg2_ID,
    input wire csr_reg_write_en_ID,
    input wire [11:0]csr_addr_ID,
    input wire [2:0] csr_ALU_func_ID,
    output reg [2:0]csr_ALU_func_EX,
    output reg [11:0]csr_addr_EX,
    output reg csr_reg_write_en_EX,
    output reg [31:0] reg1_EX,
    output reg [31:0] reg2_EX
    );

    initial 
    begin
    reg1_EX = 0;
    reg2_EX = 0;
    csr_reg_write_en_EX = 0;
    csr_addr_EX = 0;
    csr_ALU_func_EX = 0;
    end
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE)
            begin
                reg1_EX <= 0;
                reg2_EX <= 0;
                csr_reg_write_en_EX = 0;
                csr_addr_EX = 0;
                csr_ALU_func_EX = 0;
            end
            else 
            begin
                reg1_EX <= reg1_ID;
                reg2_EX <= reg2_ID;
                csr_reg_write_en_EX = csr_reg_write_en_ID;
                csr_addr_EX = csr_addr_ID;
                csr_ALU_func_EX = csr_ALU_func_ID;
            end
        end
    
endmodule