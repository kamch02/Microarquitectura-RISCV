`timescale 1ns / 1ps
 
module tb_data_mem;
 
    reg clk;
    reg MemRead, MemWrite, ByteEn;
    reg [31:0] addr;
    reg [31:0] write_data;
    wire [31:0] read_data;
 
    data_mem DUT (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ByteEn(ByteEn),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );
 
    always #5 clk = ~clk;
 
    initial begin
        clk = 0;
        MemRead = 0;
        MemWrite = 0;
        ByteEn = 0;
 
        addr = 32'd4;
        write_data = 32'h12345678;
        MemWrite = 1;
        #10 MemWrite = 0;
 
        MemRead = 1;
        #10;
 
        $stop;
    end
 
endmodule
