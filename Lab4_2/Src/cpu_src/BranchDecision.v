`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Branch Decision
// Tool Versions: Vivado 2017.4.1
// Description: Decide whether to branch
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    //  判断是否branch
// 输入
    // reg1               寄存器1
    // reg2               寄存器2
    // br_type            branch类型
// 输出
    // br                 是否branch
// 实验要求
    // 补全模块

`include "Parameters.v"   
module BranchDecision(
    input wire [31:0] reg1, reg2,
    input wire [2:0] br_type,
    output reg br
    );

    always@(*)
    begin
        case(br_type)
            `NOBRANCH : br <= 0;
            `BEQ :if(reg1 == reg2)br <= 1;
                  else br <= 0;
            `BNE :if(reg1 != reg2)br <= 1;
                  else br <= 0;
            `BLT :if($signed(reg1) < $signed(reg2))br <= 1;
                  else br <= 0;
            `BLTU :if(reg1 < reg2)br <= 1;
                  else br <= 0;
            `BGE :if($signed(reg1) >= $signed(reg2))br <= 1;
                  else br <= 0;
            `BGEU :if(reg1 >= reg2)br <= 1;
                  else br <= 0;
            default : br <= 0;
        endcase
    end
    
    // TODO: Complete this module

endmodule
