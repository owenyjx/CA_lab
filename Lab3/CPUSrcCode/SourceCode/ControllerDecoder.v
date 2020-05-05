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
    //  对指令进行译码，将其翻译成控制信号，传输给各个部件
// 输入
    // Inst              待译码指令
// 输出
    // jal               jal跳转指令
    // jalr              jalr跳转指令
    // op2_src           ALU的第二个操作数来源。为1时，op2选择imm，为0时，op2选择reg2
    // ALU_func          ALU执行的运算类型
    // br_type           branch的判断条件，可以是不进行branch
    // load_npc          写回寄存器的值的来源（PC或者ALU计算结果）, load_npc == 1时选择PC
    // wb_select         写回寄存器的值的来源（Cache内容或者ALU计算结果），wb_select == 1时选择cache内容
    // load_type         load类型
    // src_reg_en        指令中src reg的地址是否有效，src_reg_en[1] == 1表示reg1被使用到了，src_reg_en[0]==1表示reg2被使用到了
    // reg_write_en      通用寄存器写使能，reg_write_en == 1表示需要写回reg
    // cache_write_en    按字节写入data cache
    // imm_type          指令中立即数类型
    // alu_src1          alu操作数1来源，alu_src1 == 0表示来自reg1，alu_src1 == 1表示来自PC
    // alu_src2          alu操作数2来源，alu_src2 == 2’b00表示来自reg2，alu_src2 == 2'b01表示来自reg2地址，alu_src2 == 2'b10表示来自立即数
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
    output wire [1:0]load_npc,
    output wire wb_select,
    output reg [2:0] load_type,
    output reg [1:0] src_reg_en,
    output reg reg_write_en,
    output reg [3:0] cache_write_en,
    output wire alu_src1,
    output wire [1:0] alu_src2,
    output reg [2:0] imm_type
    );

    // TODO: Complete this module
    always@(*)
    begin

        //ALU_func ALU???????
        // ADD... AND,???????
        if(inst[6:0] == 7'b0110011)
        begin
            case(inst[14:12])
                3'b000:
                begin
                    if(inst[30] == 1)
                    begin
                        ALU_func = `SUB;
                    end
                    else
                    begin
                        ALU_func = `ADD;
                    end
                end
                3'b001: ALU_func = `SLL;
                3'b010: ALU_func = `SLT;
                3'b011: ALU_func = `SLTU;
                3'b100: ALU_func = `XOR;
                3'b101: 
                begin
                    if(inst[30] == 1)
                    begin
                        ALU_func = `SRA;
                    end
                    else
                    begin
                        ALU_func = `SRL;
                    end
                end
                3'b110: ALU_func = `OR;
                3'b111: ALU_func = `AND;
                default: ;
            endcase
        end
        //ADDI,..SRAI
        else if(inst[6:0] == 7'b0010011)
        begin
            case(inst[14:12])
                3'b000: ALU_func = `ADD;
                3'b001: ALU_func = `SLL;
                3'b010: ALU_func = `SLT;
                3'b011: ALU_func = `SLTU;
                3'b100: ALU_func = `XOR;
                3'b101: 
                begin
                    if(inst[30] == 1)
                    begin
                        ALU_func = `SRA;
                    end
                    else
                    begin
                        ALU_func = `SRL;
                    end
                end
                3'b110: ALU_func = `OR;
                3'b111: ALU_func = `AND;
                default: ;
            endcase
        end
        //SW,SH,SB ????
        else if (inst[6:0] == 7'b0100011)
        begin
            ALU_func = `ADD;
        end   
        //LB,LH,LW,LBU,LHU????
        else if (inst[6:0] == 7'b0000011)
        begin
            ALU_func = `ADD;
        end  
        //???????ALU???????????
        else if (inst[6:0] == 7'b1100011)
        begin
            ALU_func = `ADD;
        end  
        //JAL,JALR????
        else if (inst[6:0] == 7'b1101111 || inst[6:0] == 7'b1100111)
        begin
            ALU_func = `ADD;
        end 
        //AUIPC ??????PC????
        else if (inst[6:0] == 7'b0010111)
        begin
            ALU_func = `ADD;
        end 
        //LUI
        else if (inst[6:0] == 7'b0110111)
        begin
            ALU_func = `LUI;
        end 
        else
        begin
        end
    end
    
    always@(*)
    begin
            //br_type branch????????????branch
        if(inst[6:0] == 7'b1100011)
        begin
            case(inst[14:12])
                3'b000: br_type = `BEQ;
                3'b001: br_type = `BNE;
                3'b100: br_type = `BLT;
                3'b101: br_type = `BGE;
                3'b110: br_type = `BLTU;
                3'b111: br_type = `BGEU;
                default: ;
            endcase
        end
        else
        begin
            br_type = `NOBRANCH;
        end
    end

    always@(*)
    begin
     //cache_write_en ?????data cache
        if(inst[6:0] == 7'b0100011) 
        begin
            case(inst[14:12])
                3'b000: cache_write_en = 4'b0001;
                3'b001: cache_write_en = 4'b0011;
                3'b010: cache_write_en = 4'b1111;
                default: cache_write_en = 4'b0000;
            endcase
        end
        else
        begin
           cache_write_en = 4'b0000;
        end
    end

    always@(*)
    begin
        //reg_write_en ?????????reg_write_en == 1??????reg
        
        if(inst[6:0] == 7'b1100011 || inst[6:0] == 7'b0100011 ) 
        begin
            reg_write_en = 1'b0; 
        end
        else
        begin
            reg_write_en = 1'b1; 
        end
    end

    always@(*)
    begin
        //imm_type ????????

        if(inst[6:0] == 7'b0110011) 
        begin
            imm_type = `RTYPE;
        end
        else if(inst[6:0] == 7'b0000011 || inst[6:0] == 7'b0010011 || inst[6:0] == 7'b1100111)
        begin
            imm_type = `ITYPE;
        end
        else if(inst[6:0] == 7'b0100011)
        begin
            imm_type = `STYPE;
        end
        else if(inst[6:0] == 7'b1100011)
        begin
            imm_type = `BTYPE;
        end
        else if(inst[6:0] == 7'b0110111 || inst[6:0] == 7'b0010111)
        begin
            imm_type = `UTYPE;
        end
        else if(inst[6:0] == 7'b1101111)
        begin
            imm_type = `JTYPE;
        end
    end

    //src_reg_en ???src reg????????src_reg_en[1] == 1??reg1??????src_reg_en[0]==1??reg2?????
    always@(*)
    begin
         

        if(inst[6:0] == 7'b0110011 || inst[6:0] == 7'b0100011 || inst[6:0] == 7'b1100011) 
        begin
            src_reg_en[0] = 1'b1; 
        end
        else
        begin
            src_reg_en[0] = 1'b0; 
        end

        
    end

    always@(*)
    begin
        if(inst[6:0] == 7'b0110111 || inst[6:0] == 7'b0010111 || inst[6:0] == 7'b1101111) 
        begin
            src_reg_en[1] = 1'b0; 
        end
        else
        begin
            src_reg_en[1] = 1'b1; 
        end
    end

    always@(*)
    begin
                //load_type load??
        if(inst[6:0] == 7'b0000011)
        begin
            case(inst[14:12])
                3'b000: load_type = `LB;
                3'b001: load_type = `LH;
                3'b010: load_type = `LW;
                3'b100: load_type = `LBU;
                3'b101: load_type = `LHU;
                default: ;
            endcase
        end
        else
        begin
            load_type = `NOREGWRITE;
        end
    end



    assign jal = (inst[6:0] == 7'b1101111)? 1'b1:1'b0;

    assign jalr = (inst[6:0] == 7'b1100111)? 1'b1:1'b0;

    //when ADD,SUB,SLL,SLT,SLTU,XOR,SRL,SRA,OR,AND select reg2
    assign op2_src = (inst[6:0] == 7'b0110011)? 1'b0:1'b1; 

    //when jal,jajr
    assign load_npc = (inst[6:0] == 7'b1110011) ? 2'b11 : (inst[6:0] == 7'b1101111 || inst[6:0] == 7'b1100111)? 1: 0; //加入csr指令
    // assign load_npc = (inst[6:0] == 7'b1101111 || inst[6:0] == 7'b1100111)? 2'b01: 2'b00; //加入csr指令

    //when sw,sh,sb
    assign wb_select = (inst[6:0] == 7'b0000011)? 1'b1:1'b0;

    //when jal,AUIPC
    assign alu_src1 = (inst[6:0] == 7'b1101111 || inst[6:0] == 7'b0010111)? 1'b1:1'b0; 

    //when when ADD,SUB,SLL,SLT,SLTU,XOR,SRL,SRA,OR,AND select reg2; when SLLI,SRLI,SRAI select reg2?? !!!!!!!!!!!!!!!!!!!!!!!!
    assign alu_src2 = (inst[6:0] == 7'b0110011)?2'b00 : (inst[6:0] == 7'b0010011 && (inst[14:12] == 3'b001 || inst[14:12] == 3'b001 || inst[14:12] == 3'b001)) ? 2'b01 : 2'b10;


endmodule
