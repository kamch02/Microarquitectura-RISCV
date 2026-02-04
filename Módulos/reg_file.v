`timescale 1ns / 1ps

module reg_file (
    input        clk,
    input        RegWrite,
    input  [4:0] rs1,
    input  [4:0] rs2,
    input  [4:0] rd,
    input  [31:0] wd,
    output [31:0] rd1,
    output [31:0] rd2
);

    // 32 registros de 32 bits
    reg [31:0] regs [0:31];
    
    //Inicialización de los registros
    integer j;
    initial begin
        for (j=0; j<32; j=j+1) regs[j] = 32'b0;
        regs[2] = 32'h00000100; // inicializa el stack pointer en la posición 256, este va a ir bajando conforme haya más y más registros utilizados
    end
    
    
    // Lectura para los puertos
    
    //Asiganción de los puertos de lectura
    assign rd1 = (rs1 == 5'd0) ? 32'b0 : regs[rs1]; 
    assign rd2 = (rs2 == 5'd0) ? 32'b0 : regs[rs2];

    // Puerto de escritura
    always @(posedge clk) begin
        if (RegWrite && (rd != 5'd0))
            regs[rd] <= wd;
    end

endmodule

