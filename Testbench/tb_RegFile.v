module tb_reg_file;

    logic clk;
    logic RegWrite;
    logic [4:0] rs1, rs2, rd;
    logic [31:0] wd;
    logic [31:0] rd1, rd2;

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

        // Write register
        RegWrite = 1;
        rd = 5'd5;
        wd = 32'd33;
        #10;

        // Read register
        RegWrite = 0;
        rs1 = 5'd5;
        rs2 = 5'd0;
        #10;

        $stop;
    end

endmodule