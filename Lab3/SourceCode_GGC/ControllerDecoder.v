`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Controller Decoder
// Tool Versions: Vivado 2017.4.1
// Description: Controller Decoder Module
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  对指令进行译码，将其翻译成控制信号，传输给各个部�?
// 输入
    // Inst              待译码指�?
// 输出
    // jal               jal跳转指令
    // jalr              jalr跳转指令
    // op2_src           ALU的第二个操作数来源�?�为1时，op2选择imm，为0时，op2选择reg2
    // ALU_func          ALU执行的运算类�?
    // br_type           branch的判断条件，可以是不进行branch
    // load_npc          写回寄存器的值的来源（PC或�?�ALU计算结果�?, load_npc == 1时�?�择PC
    // wb_select         写回寄存器的值的来源（Cache内容或�?�ALU计算结果），wb_select == 1时�?�择cache内容
    // load_type         load类型
    // src_reg_en        指令中src reg的地�?是否有效，src_reg_en[1] == 1表示reg1被使用到了，src_reg_en[0]==1表示reg2被使用到�?
    // reg_write_en      通用寄存器写使能，reg_write_en == 1表示�?要写回reg
    // cache_write_en    按字节写入data cache，由高到低每个使能位控制�?字节的写入，�?32位即4字节
    // imm_type          指令中立即数类型
    // alu_src1          alu操作�?1来源，alu_src1 == 0表示来自reg1，alu_src1 == 1表示来自PC
    // alu_src2          alu操作�?2来源，alu_src2 == 2’b00表示来自reg2，alu_src2 == 2'b01表示来自reg2地址，alu_src2 == 2'b10表示来自立即�?
// 实验要求
    // 补全模块


`include "Parameters.v"   
module ControllerDecoder(
    input wire [31:0] inst,
    output wire jal,
    output wire jalr,
    output wire op2_src,
    output reg [3:0] ALU_func,
    output reg [2:0] br_type,
    output wire load_npc,
    output wire wb_select,
    output reg [2:0] load_type,
    output reg [1:0] src_reg_en,
    output reg reg_write_en,
    output reg [3:0] cache_write_en,
    output wire alu_src1,
    output wire [1:0] alu_src2,
    output reg [2:0] imm_type
    );

    initial begin
        ALU_func = `ADD;
        br_type = `NOBRANCH;
        load_type = `NOREGWRITE;
        imm_type = `RTYPE;
        src_reg_en = 2'b11;
        reg_write_en = 0;
        cache_write_en = 4'b0000;
    end

    assign jal = (inst[6:0] == 7'b1101111)? 1 : 0;//jalָ
    
    assign jalr = (inst[6:0] == 7'b1100111)? 1 : 0;//jalrָ
    
    assign op2_src = (inst[6:0] == 7'b0110011)? 0 : 1;//alu指令
    
    //ALU_func
    always@(*)
    begin
    //普通alu指令
        if(inst[6:0] == 7'b0000011)ALU_func <= `ADD;
        else if(inst[6:0] == 7'b0110011)begin
            case({inst[31:25],inst[14:12]})
                10'b0000000_000 : ALU_func <= `ADD;
                10'b0100000_000 : ALU_func <= `SUB;
                10'b0000000_001 : ALU_func <= `SLL;
                10'b0000000_101 : ALU_func <= `SRL;
                10'b0100000_101 : ALU_func <= `SRA;                
                10'b0000000_010 : ALU_func <= `SLT;
                10'b0000000_011 : ALU_func <= `SLTU;
                10'b0000000_100 : ALU_func <= `XOR;
                10'b0000000_110 : ALU_func <= `OR;
                10'b0000000_111 : ALU_func <= `AND;
                default ALU_func <= 4'd3; //默认ADD 
            endcase
        end
    //立即数指令
        else if(inst[6:0] == 7'b0010011)begin
            case( inst[14:12] )
                3'b000 : ALU_func <= `ADD;
                3'b001 : ALU_func <= `SLL;
                3'b010 : ALU_func <= `SLT;
                3'b011 : ALU_func <= `SLTU;
                3'b100 : ALU_func <= `XOR;
                3'b101 : ALU_func <= (inst[31:25] == 7'b0000000)? `SRL : `SRA;
                3'b110 : ALU_func <= `OR;
                3'b111 : ALU_func <= `AND;
                default ALU_func <= 4'd3; //默认ADD                           
            endcase
        end
    //JALR指令
        else if(inst[6:0] == 7'b1100111)begin
            ALU_func <= `ADD;
        end
    //LUI指令
        else if(inst[6:0] == 7'b0110111)begin
            ALU_func <= `LUI;
        end
    //AUIPC指令
        else if(inst[6:0] == 7'b0010111)begin
            ALU_func <= `ADD;
        end
        else ALU_func <= 4'd3;//默认ADD
    end

    //br_type
    always@(*)
    begin
        if(inst[6:0] == 7'b1100011)begin
            case(inst[14:12])
                3'b000 : br_type <= `BEQ;
                3'b001 : br_type <= `BNE;
                3'b100 : br_type <= `BLT;
                3'b101 : br_type <= `BGE;
                3'b110 : br_type <= `BLTU;
                3'b111 : br_type <= `BGEU;
                default : br_type <= `NOBRANCH;
            endcase
        end
        else br_type <= `NOBRANCH;//默认不跳转
    end

    assign load_npc = (inst[6:0] == 7'b1101111||inst[6:0] == 7'b1100111)?  1: 0;//jal或jalrָ
    
    assign wb_select = (inst[6:0] == 7'b0000011)? 1: 0;//loadָ类型

    //load_type
    always@(*)
    begin
        if(inst[6:0] == 7'b0000011)begin
            case(inst[14:12])
                3'b000 : load_type <= `LB;
                3'b001 : load_type <= `LH;
                3'b010 : load_type <= `LW;
                3'b100 : load_type <= `LBU;
                3'b101 : load_type <= `LHU;
                default : load_type <= `NOREGWRITE;//默认为不写回
            endcase
        end
        else load_type <= `NOREGWRITE;//默认不写
    end

    //src_reg_en
    always@(*)
    begin
        case(inst[6:0])
            7'b1101111 : src_reg_en <= 2'b00;//jal
            7'b1100111 : src_reg_en <= 2'b10;//jalr            
            7'b0000011 : src_reg_en <= 2'b10;//load
            7'b0100011 : src_reg_en <= 2'b10;//store
            7'b0110111 : src_reg_en <= 2'b00;//LUI
            7'b0010111 : src_reg_en <= 2'b00;//AUIPC
            7'b0010011 : src_reg_en <= 2'b10;//立即数指令
            7'b0110011 : src_reg_en <= 2'b11;//ALU指令
            7'b1100011 : src_reg_en <= 2'b11;//branch指令
            default : src_reg_en <= 2'b11;//失配后默认两个reg都有�?
        endcase
    end

    //下面是reg_write_en
    always@(*)
    begin
        case(inst[6:0])
            7'b1101111 : reg_write_en <= 1;//jal
            7'b1100111 : reg_write_en <= 1;//jalr
            7'b0000011 : reg_write_en <= 1;//load
            7'b0100011 : reg_write_en <= 0;//store
            7'b0110111 : reg_write_en <= 1;//LUI
            7'b0010111 : reg_write_en <= 1;//AUIPC
            7'b0010011 : reg_write_en <= 1;//立即数指令
            7'b0110011 : reg_write_en <= 1;//ALU指令
            7'b1100011 : reg_write_en <= 0;//branch指令
            default : reg_write_en <= 0;//默认不写入reg
        endcase
    end

    //下面是cache_write_en
    always@(*)
    begin
        case(inst[6:0])
            7'b1101111 : cache_write_en <= 4'b0000;//jal
            7'b1100111 : cache_write_en <= 4'b0000;//jalr        
            7'b0000011 : cache_write_en <= 4'b0000;//load
            7'b0100011 :begin                  //store
                            if(inst[14:12] == 3'b010)cache_write_en <= 4'b1111;
                            else if(inst[14:12] == 3'b001)cache_write_en <= 4'b0011;
                            else if(inst[14:12] == 3'b000)cache_write_en <= 4'b0001;
                            else cache_write_en <= 4'b0000;
                        end
            7'b0110111 : cache_write_en <= 4'b0000;//LUI
            7'b0010111 : cache_write_en <= 4'b0000;//AUIPC
            7'b0010011 : cache_write_en <= 4'b0000;//立即数指令
            7'b0110011 : cache_write_en <= 4'b0000;//ALU指令
            7'b1100011 : cache_write_en <= 4'b0000;//branch指令
            default : cache_write_en <= 4'b0000;//默认不写入cache
        endcase
    end

    //下面是决定立即数类型
    always@(*)
    begin
        case(inst[6:0])
            7'b1101111 : imm_type <= `JTYPE;//jal
            7'b1100111 : imm_type <= `ITYPE;//jalr        
            7'b0000011 : imm_type <= `ITYPE;//load
            7'b0100011 : imm_type <= `STYPE;//store
            7'b0110111 : imm_type <= `UTYPE;//LUI
            7'b0010111 : imm_type <= `UTYPE;//AUIPC
            7'b0010011 : imm_type <= `ITYPE;//立即数指令
            7'b0110011 : imm_type <= `RTYPE;//ALU指令
            7'b1100011 : imm_type <= `BTYPE;//branch指令
            default : ;
        endcase
    end
    
    assign alu_src1 = (inst[6:0] == 7'b1101111 || inst[6:0] == 7'b0010111)?  1: 0;//jal与AUIPC
    
    assign alu_src2 = (inst[6:0] == 7'b0010011 &&((inst[31:25]==7'b0000000 && inst[14:12]==3'b001)||(inst[31:25]==7'b0000000 && inst[14:12]==3'b101)||(inst[31:25]==7'b0100000 && inst[14:12]==3'b101)))? 2'b01 : ((inst[6:0] == 7'b0110011)? 2'b00 : 2'b10);
    //偏移立即数指令：reg2地址；ALU指令：reg2；其余：imm

    // TODO: Complete this module

endmodule
