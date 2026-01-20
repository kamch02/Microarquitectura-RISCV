module instr_mem (
    input  [31:0] addr,
    output [31:0] instr
);
 
    // 256 words of instruction memory
    reg [31:0] mem [0:255];
 
    // Load program at simulation start
    initial begin
        $readmemh("program.hex", mem);
    end
 
    // Word-aligned access (PC / 4)
    assign instr = mem[addr[9:2]];
 
endmodule
