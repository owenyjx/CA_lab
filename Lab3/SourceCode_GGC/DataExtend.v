`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Data Extend
// Tool Versions: Vivado 2017.4.1
// Description: Data Extension module
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  将Cache中Load的数据扩展成32位
// 输入
    // data              cache读出的数据
    // addr              字节地址
    // load_type         load的类型
    // ALU_func          运算类型
// 输出
    // dealt_data        扩展完的数据
// 实验要求
    // 补全模块


`include "Parameters.v"

module DataExtend(
    input wire [31:0] data,
    input wire [1:0] addr,
    input wire [2:0] load_type,
    output reg [31:0] dealt_data
    );


    always@(*)
    begin
        case(load_type)
            `NOREGWRITE:dealt_data <= 32'd0;
            `LW:begin
                    dealt_data <= data;
                end		    //	 32bit
            `LH:begin
                    if(addr[1]==0) dealt_data <= {{17{data[15]}},data[14:0]};
                    else if(addr[1]==1) dealt_data <= {{17{data[31]}},data[30:16]};
                    else dealt_data <= 32'd0;
                end			//	16bit 符号扩展   
            `LB:begin
                    if(addr==2'b00) dealt_data <= {{25{data[7]}},data[6:0]};
                    else if(addr==2'b01) dealt_data <= {{25{data[15]}},data[14:8]};
                    else if(addr==2'b10) dealt_data <= {{25{data[23]}},data[22:16]};
                    else if(addr==2'b11) dealt_data <= {{25{data[31]}},data[30:24]};
                    else dealt_data <= 32'd0;
                end		    //	 8bit 符号扩展
            `LHU:begin
                    if(addr[1]==0) dealt_data <= {16'd0,data[15:0]};
                    else if(addr[1]==1) dealt_data <= {16'd0,data[31:16]};
                    else dealt_data <= 32'd0;
                end			//   16bit 无符号扩展
            `LBU:begin
                    if(addr==2'b00) dealt_data <= {24'd0,data[7:0]};
                    else if(addr==2'b01) dealt_data <= {24'd0,data[15:8]};
                    else if(addr==2'b10) dealt_data <= {24'd0,data[23:16]};
                    else if(addr==2'b11) dealt_data <= {24'd0,data[31:24]};
                    else dealt_data <= 32'd0;
                end			//	8bit 无符号扩展
            default :dealt_data <= 32'd0;
        endcase
    end





    // TODO: Complete this module

endmodule