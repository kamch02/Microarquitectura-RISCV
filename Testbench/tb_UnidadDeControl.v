`timescale 1ns / 1ps
 
module tb_control_unit;
 
    reg clk;
    reg reset;
    reg [31:0] instr;
    reg Zero;
    reg Less;
 
    wire PCWrite;
    wire IRWrite;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire ByteEn;
    wire ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [2:0] ALUCtrl;
    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
    wire [1:0] PCSource;
 
    control_unit DUT (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .Zero(Zero),
        .Less(Less),
        .PCWrite(PCWrite),
        .IRWrite(IRWrite),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ByteEn(ByteEn),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUCtrl(ALUCtrl),
        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc),
        .PCSource(PCSource)
    );
 
    // Clock generation
    always #5 clk = ~clk;
 
    initial begin
        clk = 0;
        reset = 1;
        instr = 32'b0;
        Zero = 0;
        Less = 0;
 
        #10 reset = 0;
 
        // -------------------------
        // FETCH
        // -------------------------
        instr = 32'h00000013; // NOP
        #10;
 
        // -------------------------
        // ADDI
        // -------------------------
        instr = 32'h02100793; // addi a5, zero, 33
        #10;
        #10;
        #10;
 
        // -------------------------
        // LW
        // -------------------------
        instr = 32'hFE842783;
        #10;
        #10;
        #10;
        #10;
 
        // -------------------------
        // SW
        // -------------------------
        instr = 32'hFEF42623;
        #10;
        #10;
        #10;
 
        // -------------------------
        // BRANCH (bge)
        // -------------------------
        instr = 32'hFCE7D0E3;
        Less = 1;
        #10;
        Less = 0;
 
        // -------------------------
        // ANDI
        // -------------------------
        instr = 32'h00F7F793;
        #10;
        #10;
 
        #50;
        $stop;
    end
 
endmodule
