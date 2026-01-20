`timescale 1ns / 1ps
 
module tb_imm_gen;
 
    reg  [31:0] instr;
    reg  [2:0]  ImmSrc;
    wire [31:0] imm_out;
 
    imm_gen DUT (
        .instr(instr),
        .ImmSrc(ImmSrc),
        .imm_out(imm_out)
    );
 
    initial begin
        instr = 32'h00000013;
        ImmSrc = 3'b000; // I-type
        #10;
 
        instr = 32'h00F70793; // andi
        ImmSrc = 3'b000;
        #10;
 
        instr = 32'hFEF42623; // sw
        ImmSrc = 3'b001;
        #10;
 
        instr = 32'hFCE7D0E3; // bge
        ImmSrc = 3'b010;
        #10;
 
        $stop;
    end
 
endmodule
