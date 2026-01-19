module tb_data_mem;

    logic clk;
    logic MemRead, MemWrite, ByteEn;
    logic [31:0] addr, write_data;
    logic [31:0] read_data;

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

        // Write word
        MemWrite = 1; MemRead = 0; ByteEn = 0;
        addr = 32'h10; write_data = 32'h12345678;
        #10;

        // Read word
        MemWrite = 0; MemRead = 1;
        #10;

        // Write byte (sb)
        MemWrite = 1; MemRead = 0; ByteEn = 1;
        addr = 32'h14; write_data = 32'h000000AA;
        #10;

        // Read back
        MemWrite = 0; MemRead = 1;
        #10;

        $stop;
    end

endmodule