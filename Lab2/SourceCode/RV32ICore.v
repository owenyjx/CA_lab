`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: RV32I Core
// Tool Versions: Vivado 2017.4.1
// Description: Top level of our CPU Core
//////////////////////////////////////////////////////////////////////////////////


//功能说明
    // RV32I Core的顶层模块
//实验要求  
    // 添加CSR指令的数据通路和相应部件

module RV32ICore(
    input wire CPU_CLK,
    input wire CPU_RST,
    input wire [31:0] CPU_Debug_DataCache_A2,
    input wire [31:0] CPU_Debug_DataCache_WD2,
    input wire [3:0] CPU_Debug_DataCache_WE2,
    output wire [31:0] CPU_Debug_DataCache_RD2,
    input wire [31:0] CPU_Debug_InstCache_A2,
    input wire [31:0] CPU_Debug_InstCache_WD2,
    input wire [ 3:0] CPU_Debug_InstCache_WE2,
    output wire [31:0] CPU_Debug_InstCache_RD2
    );
	//wire values definitions
    wire bubbleF, flushF, bubbleD, flushD, bubbleE, flushE, bubbleM, flushM, bubbleW, flushW;
    wire [31:0] jal_target, br_target;
    wire jal, br;
    wire jalr_ID, jalr_EX;
    wire [31:0] NPC, PC_IF, PC_4, PC_ID, PC_EX;
    wire [31:0] inst_ID;
    wire reg_write_en_ID, reg_write_en_EX, reg_write_en_MEM, reg_write_en_WB;
    wire [4:0] reg1_src_EX;
    wire [4:0] reg2_src_EX;
    wire [4:0] reg_dest_EX, reg_dest_MEM, reg_dest_WB;
    wire [31:0] data_WB;
    wire [31:0] reg1, reg1_EX;
    wire [31:0] reg2, reg2_EX, reg2_MEM;
    wire [31:0] op2;
    wire [31:0] reg_or_imm;
    wire op2_src;
    wire [3:0] ALU_func_ID, ALU_func_EX;
    wire [2:0] br_type_ID, br_type_EX;
    wire [1:0] load_npc_ID, load_npc_EX;
    wire wb_select_ID, wb_select_EX, wb_select_MEM;
    wire [2:0] load_type_ID, load_type_EX, load_type_MEM;
    wire [1:0] src_reg_en_ID, src_reg_en_EX;
    wire [3:0] cache_write_en_ID, cache_write_en_EX, cache_write_en_MEM;
    wire alu_src1_ID, alu_src1_EX;
    wire [1:0] alu_src2_ID, alu_src2_EX;
    wire [2:0] imm_type;
    wire [31:0] imm;
    wire [31:0] ALU_op1, ALU_op2, ALU_out;
    wire [31:0] dealt_reg2;
    wire [31:0] result, result_MEM;
    wire [1:0] op1_sel, op2_sel, reg2_sel;

    wire [31:0] csr_op1_ID, csr_op1_EX, csr_op1_MEM, csr_op1_WB, csr_ALU_out;
    wire [31:0] csr_ALU_out_EX, csr_ALU_out_MEM, csr_ALU_out_WB;
    wire [31:0] csr_op2_ID, csr_op2_EX, csr_op2_MEM, csr_op2_WB;
    wire [31:0] csr_imm;
    wire [31:0] csr_data_WB;
    wire csr_reg_write_en_ID, csr_reg_write_en_EX, csr_reg_write_en_MEM, csr_reg_write_en_WB;
    wire [11:0] csr_addr_dest_ID, csr_addr_dest_EX, csr_addr_dest_MEM, csr_addr_dest_WB;
    wire [2:0] csr_ALU_func_ID, csr_ALU_func_EX, csr_ALU_func_MEM, csr_ALU_func_WB;




    // Adder to compute PC + 4
    assign PC_4 = PC_IF + 4;
    // MUX for op2 source
    assign op2 = op2_src ? imm : reg2;
    // Adder to compute PC_ID + Imm - 4
    assign jal_target = PC_ID + op2 - 4;
    // MUX for ALU op1
    assign ALU_op1 = (op1_sel == 2'h0) ? result_MEM :
                                         ((op1_sel == 2'h1) ? data_WB :
                                                              (op1_sel == 2'h2) ? (PC_EX - 4) :
                                                                                  reg1_EX);
    // MUX for ALU op2
    assign ALU_op2 = (op2_sel == 2'h0) ? result_MEM :
                                         ((op2_sel == 2'h1) ? data_WB :
                                                              ((op2_sel == 2'h2) ? reg2_src_EX :
                                                                                   reg_or_imm));

    // MUX for Reg2
    assign dealt_reg2 = (reg2_sel == 2'h0) ? result_MEM :
                                            ((reg2_sel == 2'h1) ? data_WB : reg2_EX);


    // MUX for result (ALU or PC_EX)
    assign result = (load_npc_EX == 2'b11) ? csr_op1_EX : (load_npc_EX == 1) ? PC_EX : ALU_out;

    assign csr_op2_ID = (inst[14:12] == 3'b101 || inst[14:12] == 3'b110 || inst[14:12] == 3'b111) ? {{27{1'b0}}, inst[11:7]} : reg1;
    assign csr_reg_write_en_ID = 1;
    assign csr_ALU_func_ID = (inst[14:12] == 3'b001) ? 0 : (inst[14:12] == 3'b010) ? 1 : (inst[14:12] == 3'b011) ? 2 : (inst[14:12] == 3'b101) ? 3 : (inst[14:12] == 3'b110) ? 4 : 5 


    //Module connections
    // ---------------------------------------------
    // PC-Generator
    // ---------------------------------------------


    NPC_Generator NPC_Generator1(
        .PC(PC_4),
        .jal_target(jal_target),
        .jalr_target(ALU_out),
        .br_target(br_target),
        .jal(jal),
        .jalr(jalr_EX),
        .br(br),
        .NPC(NPC)
    );


    PC_IF PC_IF1(
        .clk(CPU_CLK),
        .bubbleF(bubbleF),
        .flushF(flushF),
        .NPC(NPC),
        .PC(PC_IF)
    );



    // ---------------------------------------------
    // IF stage
    // ---------------------------------------------

    PC_ID PC_ID1(
        .clk(CPU_CLK),
        .bubbleD(bubbleD),
        .flushD(flushD),
        .PC_IF(PC_4),
        .PC_ID(PC_ID)
    );


    IR_ID IR_ID1(
        .clk(CPU_CLK),
        .bubbleD(bubbleD),
        .flushD(flushD),
        .write_en(|CPU_Debug_InstCache_WE2),
        .addr(PC_IF[31:2]),
        .debug_addr(CPU_Debug_InstCache_A2[31:2]),
        .debug_input(CPU_Debug_InstCache_WD2),
        .inst_ID(inst_ID),
        .debug_data(CPU_Debug_InstCache_RD2)
    );



    // ---------------------------------------------
    // ID stage
    // ---------------------------------------------


    RegisterFile RegisterFile1(
        .clk(CPU_CLK),
        .rst(CPU_RST),
        .write_en(reg_write_en_WB),
        .addr1(inst_ID[19:15]),
        .addr2(inst_ID[24:20]),
        .wb_addr(reg_dest_WB),
        .wb_data(data_WB),
        .reg1(reg1),
        .reg2(reg2)
    );

    //加入特殊寄存器
    CSRRegisterFile CSRRegisterFile1(
        .clk(CPU_CLK),
        .rst(CPU_RST),
        .csr_write_en(csr_reg_write_en_WB),
        .csr_addr(inst[31:20]),
        .csr_wb_data(csr_ALU_out_WB),
        .csr_wb_addr(csr_addr_dest_WB),
        .csr_out(csr_op1_ID)
    )


    ControllerDecoder ControllerDecoder1(
        .inst(inst_ID),
        .jal(jal),
        .jalr(jalr_ID),
        .op2_src(op2_src),
        .ALU_func(ALU_func_ID),
        .br_type(br_type_ID),
        .load_npc(load_npc_ID),
        .wb_select(wb_select_ID),
        .load_type(load_type_ID),
        .src_reg_en(src_reg_en_ID),
        .reg_write_en(reg_write_en_ID),
        .cache_write_en(cache_write_en_ID),
        .alu_src1(alu_src1_ID),
        .alu_src2(alu_src2_ID),
        .imm_type(imm_type)
    );

    ImmExtend ImmExtend1(
        .inst(inst_ID[31:7]),
        .imm_type(imm_type),
        .imm(imm)
    );


    PC_EX PC_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .PC_ID(PC_ID),
        .PC_EX(PC_EX)
    );

    BR_Target_EX BR_Target_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .address(jal_target),
        .address_EX(br_target)
    );

    Op1_EX Op1_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .reg1(reg1),
        .reg1_EX(reg1_EX)
    );

    Op2_EX Op2_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .op2(op2),
        .reg_or_imm(reg_or_imm)
    );

    Reg2_EX Reg2_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .reg2(reg2),
        .reg2_EX(reg2_EX)
    );

    Addr_EX Addr_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .reg1_src_ID(inst_ID[19:15]),
        .reg2_src_ID(inst_ID[24:20]),
        .reg_dest_ID(inst_ID[11:7]),
        .reg1_src_EX(reg1_src_EX),
        .reg2_src_EX(reg2_src_EX),
        .reg_dest_EX(reg_dest_EX)
    );



    Ctrl_EX Ctrl_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .jalr_ID(jalr_ID),
        .ALU_func_ID(ALU_func_ID),
        .br_type_ID(br_type_ID),
        .load_npc_ID(load_npc_ID),
        .wb_select_ID(wb_select_ID),
        .load_type_ID(load_type_ID),
        .src_reg_en_ID(src_reg_en_ID),
        .reg_write_en_ID(reg_write_en_ID),
        .cache_write_en_ID(cache_write_en_ID),
        .alu_src1_ID(alu_src1_ID),
        .alu_src2_ID(alu_src2_ID),
        .jalr_EX(jalr_EX),
        .ALU_func_EX(ALU_func_EX),
        .br_type_EX(br_type_EX),
        .load_npc_EX(load_npc_EX),
        .wb_select_EX(wb_select_EX),
        .load_type_EX(load_type_EX),
        .src_reg_en_EX(src_reg_en_EX),
        .reg_write_en_EX(reg_write_en_EX),
        .cache_write_en_EX(cache_write_en_EX),
        .alu_src1_EX(alu_src1_EX),
        .alu_src2_EX(alu_src2_EX)
    );


    //load type负责rd目标寄存器的赋值，通过改变之前的代码，rd的目标地址也不需要新加。
    Csr_EX Csr_EX1(
    .clk(CPU_CLK),
    .bubbleE(bubbleE),
    .flushE(flushE),
    .csr_addr_ID(inst[31:20]),
    .csr_addr_EX(csr_addr_dest_EX),
    .csr_reg_write_en_ID(csr_reg_write_en_ID),
    .csr_ALU_func_ID(csr_ALU_func_ID),
    .csr_ALU_func_EX(csr_ALU_func_EX),
    .csr_reg_write_en_EX(csr_reg_write_en_EX),
    .reg1(csr_op1_ID),
    .reg2(csr_op2_ID),
    .reg1_EX(csr_op1_EX),
    .reg2_EX(csr_op2_EX)
    );




    // ---------------------------------------------
    // EX stage
    // ---------------------------------------------

    ALU ALU1(
        .op1(ALU_op1),
        .op2(ALU_op2),
        .ALU_func(ALU_func_EX),
        .ALU_out(ALU_out)
    );

    BranchDecision BranchDecision1(
        .reg1(ALU_op1),
        .reg2(dealt_reg2),
        .br_type(br_type_EX),
        .br(br)
    );


    Result_MEM Result_MEM1(
        .clk(CPU_CLK),
        .bubbleM(bubbleM),
        .flushM(flushM),
        .result(result),
        .result_MEM(result_MEM)
    );

    Reg2_MEM Reg2_MEM1(
        .clk(CPU_CLK),
        .bubbleM(bubbleM),
        .flushM(flushM),
        .reg2_EX(dealt_reg2),
        .reg2_MEM(reg2_MEM)
    );

    Addr_MEM Addr_MEM1(
        .clk(CPU_CLK),
        .bubbleM(bubbleM),
        .flushM(flushM),
        .reg_dest_EX(reg_dest_EX),
        .reg_dest_MEM(reg_dest_MEM)
    );



    Ctrl_MEM Ctrl_MEM1(
        .clk(CPU_CLK),
        .bubbleM(bubbleM),
        .flushM(flushM),
        .wb_select_EX(wb_select_EX),
        .load_type_EX(load_type_EX),
        .reg_write_en_EX(reg_write_en_EX),
        .cache_write_en_EX(cache_write_en_EX),
        .wb_select_MEM(wb_select_MEM),
        .load_type_MEM(load_type_MEM),
        .reg_write_en_MEM(reg_write_en_MEM),
        .cache_write_en_MEM(cache_write_en_MEM)
    );

    //新加入一个ALU模块，和流水段模块
    CSR_ALU CSR_ALU1(
        .op1(csr_op1_EX),
        .op2(csr_op2_EX),
        .ALU_func(csr_ALU_func_EX),
        .ALU_out(ALU_out)
    );


    Csr_MEM Csr_MEM1(
    .clk(CPU_CLK),
    .bubbleM(bubbleM),
    .flushM(flushM),
    .csr_addr_EX(csr_addr_dest_EX),
    .csr_addr_MEM(csr_addr_dest_MEM),
    .csr_reg_write_en_EX(csr_reg_write_en_EX),
    .csr_reg_write_en_MEM(csr_reg_write_en_MEM),
    .out_EX(csr_ALU_out_EX),
    .out_MEM(csr_ALU_out_MEM)
    );

    // ---------------------------------------------
    // MEM stage
    // ---------------------------------------------


    WB_Data_WB WB_Data_WB1(
        .clk(CPU_CLK),
        .bubbleW(bubbleW),
        .flushW(flushW),
        .wb_select(wb_select_MEM),
        .load_type(load_type_MEM),
        .write_en(cache_write_en_MEM),
        .debug_write_en(CPU_Debug_DataCache_WE2),
        .addr(result_MEM),
        .debug_addr(CPU_Debug_DataCache_A2),
        .in_data(reg2_MEM),
        .debug_in_data(CPU_Debug_DataCache_WD2),
        .debug_out_data(CPU_Debug_DataCache_RD2),
        .data_WB(data_WB)
    );


    Addr_WB Addr_WB1(
        .clk(CPU_CLK),
        .bubbleW(bubbleW),
        .flushW(flushW),
        .reg_dest_MEM(reg_dest_MEM),
        .reg_dest_WB(reg_dest_WB)
    );

    Ctrl_WB Ctrl_WB1(
        .clk(CPU_CLK),
        .bubbleW(bubbleW),
        .flushW(flushW),
        .reg_write_en_MEM(reg_write_en_MEM),
        .reg_write_en_WB(reg_write_en_WB)
    );
    
    //新加入了流水段
    Csr_WB Csr_WB1(
    .clk(CPU_CLK),
    .bubbleM(bubbleW),
    .flushM(flushW),
    .csr_addr_MEM(csr_addr_dest_MEM),
    .csr_addr_WB(csr_addr_dest_WB),
    .csr_reg_write_en_MEM(csr_reg_write_en_MEM),
    .csr_reg_write_en_WB(csr_reg_write_en_WB),
    .out_MEM(csr_ALU_out_MEM),
    .out_WB(csr_ALU_out_WB)
    );

    // ---------------------------------------------
    // WB stage
    // ---------------------------------------------



    // ---------------------------------------------
    // Harzard Unit
    // ---------------------------------------------
    HarzardUnit HarzardUnit1(
        .rst(CPU_RST),
        .reg1_srcD(inst_ID[19:15]),
        .reg2_srcD(inst_ID[24:20]),
        .reg1_srcE(reg1_src_EX),
        .reg2_srcE(reg2_src_EX),
        .reg_dstE(reg_dest_EX),
        .reg_dstM(reg_dest_MEM),
        .reg_dstW(reg_dest_WB),
        .br(br),
        .jalr(jalr_EX),
        .jal(jal),
        .src_reg_en(src_reg_en_EX),
        .wb_select(wb_select_EX),
        .reg_write_en_MEM(reg_write_en_MEM),
        .reg_write_en_WB(reg_write_en_WB),
        .alu_src1(alu_src1_EX),
        .alu_src2(alu_src2_EX),
        .flushF(flushF),
        .bubbleF(bubbleF),
        .flushD(flushD),
        .bubbleD(bubbleD),
        .flushE(flushE),
        .bubbleE(bubbleE),
        .flushM(flushM),
        .bubbleM(bubbleM),
        .flushW(flushW),
        .bubbleW(bubbleW),
        .op1_sel(op1_sel),
        .op2_sel(op2_sel),
        .reg2_sel(reg2_sel)
    );  
    	         
endmodule