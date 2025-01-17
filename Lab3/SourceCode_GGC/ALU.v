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
module ALU(
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire [3:0] ALU_func,
    output reg [31:0] ALU_out
    );
    // TODO: Complete this module
    always@(*)
    begin
        case(ALU_func)
            `ADD :  ALU_out <= $signed(op1) + $signed(op2);
            `SUB :  ALU_out <= $signed(op1) - $signed(op2);
            `SLL :  ALU_out <= op1 << op2[4:0];
            `SRL :  ALU_out <= op1 >> op2[4:0];
            `SRA :  ALU_out <= $signed(op1) >>> op2[4:0];
            `SLT :  if($signed(op1) < $signed(op2))ALU_out <= 32'd1;
                    else ALU_out <= 32'd0;
            `SLTU : if(op1 < op2)ALU_out <= 32'd1;
                    else ALU_out <= 32'd0;
            `XOR :  ALU_out <= op1 ^ op2;
            `OR :   ALU_out <= op1 | op2;
            `AND :  ALU_out <= op1 & op2;   
            `LUI :  ALU_out <= op2;
            default : ALU_out <= 0;
            
        endcase
    end
    
endmodule