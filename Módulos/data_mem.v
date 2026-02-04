module data_mem (
    input        clk,
    input        MemRead,
    input        MemWrite,
    input        ByteEn,
    input  [31:0] addr,
    input  [31:0] write_data,
    output [31:0] read_data
);

    // 256 palabras en la memoria
    reg [31:0] mem [0:255];
    
    //Inicialización de todos los registros en 0
    integer i;
    initial begin
        for (i=0; i<256; i=i+1) mem[i] = 32'b0;
    end
    //--------------------------------------
    
    
    // Funciones de escritura en la memoria
    always @(posedge clk) begin
        if (MemWrite) begin
            if (ByteEn)
                mem[addr[9:2]][7:0] <= write_data[7:0]; // SB (guarda byte)
            else
                mem[addr[9:2]] <= write_data;           // SW (guarda palabra)
        end
    end

    // Si está activado MemRead, la leé
    assign read_data = (MemRead) ? mem[addr[9:2]] : 32'b0;

endmodule
