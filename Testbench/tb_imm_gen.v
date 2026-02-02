`timescale 1ns/1ps
module tb_imm_gen;

    reg  [31:0] instr;
    reg  [2:0]  ImmSrc;
    wire [31:0] imm_ext;

    // Instancia del generador de inmediatos
    imm_gen DUT (
        .instr(instr),
        .ImmSrc(ImmSrc),
        .imm_ext(imm_ext)
    );

    initial begin
        // 
        // Tipo I (addi)
        // Verifica extensión de signo correcta
        // 
        instr = 32'h02100793;
        ImmSrc = 3'b000;
        #10;

        // 
        // Tipo S (sw)
        // Verifica reconstrucción del inmediato S
        // 
        instr = 32'hfef42623;
        ImmSrc = 3'b001;
        #10;

        // 
        // Tipo B (bge)
        // Verifica inmediato PC-relative para branch
        // 
        instr = 32'hfce7d0e3;
        ImmSrc = 3'b010;
        #10;

        // 
        // Tipo J (jal / j)
        // Verifica inmediato para salto incondicional
        // 
        instr = 32'h03c0006f;
        ImmSrc = 3'b100;
        #10;

        $stop;
    end
endmodule


