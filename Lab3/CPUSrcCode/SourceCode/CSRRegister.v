`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: General Register
// Tool Versions: Vivado 2017.4.1
// Description: General Register File
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    //  通用寄存器，提供读写端口（同步写，异步读）
    //  时钟下降沿写入
    //  0号寄存器的值始终为0
// 输入
    // clk               时钟信号
    // rst               寄存器重置信号
    // write_en          寄存器写使能
    // addr1             reg1读地址
    // addr2             reg2读地址
    // wb_addr           写回地址
    // wb_data           写回数据
// 输出
    // reg1              reg1读数据
    // reg2              reg2读数据
// 实验要求
    // 无需修改


module CSRRegisterFile(
    input wire clk,
    input wire rst,
    input wire csr_write_en,
    input wire [11:0] csr_addr,
    input wire [31:0] csr_wb_data,
    input wire [11:0] csr_wb_addr,
    output wire [31:0] csr_out
    );

    reg [31:0] csr_reg_file[4095:0];
    integer i;

    // init register file
    initial
    begin
        for(i = 0; i < 4096; i = i + 1) 
            csr_reg_file[i][31:0] <= 32'b0;
    end

    // write in clk negedge, reset in rst posedge
    // if write register in clk posedge,
    // new wb data also write in clk posedge,
    // so old wb data will be written to register
    always@(negedge clk or posedge rst) 
    begin 
        if (rst)
            for(i = 0; i < 4096; i = i + 1) 
                csr_reg_file[i][31:0] <= 32'b0;
        else if(csr_write_en && (csr_wb_addr != 5'h0))
            csr_reg_file[csr_wb_addr] <= csr_wb_data;   
    end

    // read data changes when address changes
    assign csr_out = csr_reg_file[csr_addr];




endmodule
