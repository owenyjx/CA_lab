`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Immediate Extend
// Tool Versions: Vivado 2017.4.1
// Description: Immediate Extension Module
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  立即数拓展，将指令中的立即数部分拓展为完整立即数
// 输入
    // Inst              指令的[31:7]
    // ImmType           立即数类型
// 输出
    // imm               补全的立即数
// 实验要求
    // 补全模块


`include "Parameters.v"   
module ImmExtend(
    input wire [31:7] inst,
    output reg [31:0] imm
    );

    always@(*)
    begin
        imm = {{27{1'b0}}, inst[11:7]};
    end
    
endmodule
