module tb_instr_mem;

    logic [31:0] addr;
    logic [31:0] instr;

    instr_mem DUT (
        .addr(addr),
        .instr(instr)
    );

    initial begin
        addr = 0;   #10;
        addr = 4;   #10;
        addr = 8;   #10;
        addr = 12;  #10;

        $stop;
    end

endmodule
