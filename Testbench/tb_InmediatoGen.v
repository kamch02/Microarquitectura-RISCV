module tb_imm_gen;

    logic [31:0] instr;
    logic [2:0] ImmSrc;
    logic [31:0] imm_ext;

    imm_gen DUT (
        .instr(instr),
        .ImmSrc(ImmSrc),
        .imm_ext(imm_ext)
    );

    initial begin
        // I-Type (addi)
        instr  = 32'h00178793; // addi a5,a5,1
        ImmSrc = 3'b000; #10;

        // S-Type (sw)
        instr  = 32'hfef42623;
        ImmSrc = 3'b001; #10;

        // B-Type (bge)
        instr  = 32'hfce7d0e3;
        ImmSrc = 3'b010; #10;

        // U-Type (lui)
        instr  = 32'h0000c7b7;
        ImmSrc = 3'b011; #10;

        $stop;
    end

endmodule