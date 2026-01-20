`timescale 1ns / 1ps
 
module tb_reg_file;
 
    reg clk;
    reg RegWrite;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;
 
    reg_file DUT (
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );
 
    always #5 clk = ~clk;
 
    initial begin
        clk = 0;
        RegWrite = 0;
 
        rd = 5'd1; wd = 32'd100; RegWrite = 1;
        #10 RegWrite = 0;
 
        rs1 = 5'd1;
        rs2 = 5'd0;
        #10;
 
        $stop;
    end
 
endmodule
