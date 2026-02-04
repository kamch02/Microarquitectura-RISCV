`timescale 1ns / 1ps

module instr_mem (
    input  [31:0] addr,
    output [31:0] instr
);

    // 256 palabras para la memora de instrucciones
    reg [31:0] mem [0:255];

    // Se lee el archivo .hex que cuenta con las instrucciones obtendias del object dump del código C
    initial begin
        $readmemh("program.hex", mem);
    end

    // Los dos primeros bits son siempre 0, lo relevante es la instrucción que está dada en los bits 9 a 2
    assign instr = mem[addr[9:2]];

endmodule


