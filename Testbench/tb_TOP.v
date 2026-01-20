`timescale 1ns / 1ps
 
module tb_top_riscv_multiciclo;
 
    reg clk;
    reg reset;
 
    // Instantiate DUT
    top_riscv_multiciclo DUT (
        .clk(clk),
        .reset(reset)
    );
 
    // -------------------------
    // Clock generation
    // -------------------------
    always #5 clk = ~clk;  // 100 MHz clock
 
    // -------------------------
    // Test sequence
    // -------------------------
    initial begin
        clk = 0;
        reset = 1;
 
        // Hold reset
        #20;
        reset = 0;
 
        // Run simulation
        #500;
 
        // Stop simulation
        $stop;
    end
 
    // -------------------------
    // Monitor (optional but useful)
    // -------------------------
    initial begin
        $display("Time\tPC\t\tInstruction");
        $monitor("%0t\t%h\t%h",
                 $time,
                 DUT.PC,
                 DUT.IR);
    end
 
endmodule
