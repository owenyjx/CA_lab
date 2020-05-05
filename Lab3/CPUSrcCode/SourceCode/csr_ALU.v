`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: ALU
// Tool Versions: Vivado 2017.4.1
// Description: Arithmetic and logic computation module
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  算数运算和逻辑运算功能部件
// 输入
    // op1               第一个操作数
    // op2               第二个操作数
    // ALU_func          运算类型
// 输出
    // ALU_out           运算结果
// 实验要求
    // 补全模块

`include "Parameters.v"   
module CSR_ALU(
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire [2:0] ALU_func,
    output reg [31:0] ALU_out
    );

    // TODO: Complete this module
    always@(*)
    begin
        case(ALU_func)
            0: ALU_out = op2;
            1: ALU_out = op1 | op2;
            2: ALU_out = op1 & ~op2;
            3: ALU_out = op2;
            4: ALU_out = op1 | op2;
            5: ALU_out = op1 & ~op2;
            default: ;
        endcase 
    end

endmodule

