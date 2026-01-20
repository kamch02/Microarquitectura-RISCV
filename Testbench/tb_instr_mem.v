`timescale 1ns / 1ps
 
module tb_instr_mem;
 
    reg  [31:0] addr;
    wire [31:0] instr;
 
    instr_mem DUT (
        .addr(addr),
        .instr(instr)
    );
 
    initial begin
        // Dirección inicial
        addr = 32'd0;
        #10;
 
        // Siguiente instrucción
        addr = 32'd4;
        #10;
 
        addr = 32'd8;
        #10;
 
        addr = 32'd12;
        #10;
 
        addr = 32'd16;
        #10;
 
        addr = 32'd20;
        #10;
 
        // Salto a una dirección más adelante
        addr = 32'd48;
        #10;
 
        addr = 32'd52;
        #10;
 
        $stop;
    end
 
    initial begin
        $display("Time\tAddr\t\tInstr");
        $monitor("%0t\t%h\t%h", $time, addr, instr);
    end
 
endmodule
