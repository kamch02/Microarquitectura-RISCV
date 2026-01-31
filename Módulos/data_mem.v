`timescale 1ns / 1ps

module data_mem (
    input        clk,
    input        MemRead,
    input        MemWrite,
    input        ByteEn,
    input  [31:0] addr,
    input  [31:0] write_data,
    output [31:0] read_data
);

    // 256 words of data memory
    reg [31:0] mem [0:255];
    
    integer i;
    initial begin
        for (i=0; i<256; i=i+1) mem[i] = 32'b0;
    end
    
    // Write operation (synchronous)
    always @(posedge clk) begin
        if (MemWrite) begin
            if (ByteEn)
                mem[addr[9:2]][7:0] <= write_data[7:0]; // sb
            else
                mem[addr[9:2]] <= write_data;           // sw
        end
    end

    // Read operation (combinational)
    assign read_data = (MemRead) ? mem[addr[9:2]] : 32'b0;

endmodule

