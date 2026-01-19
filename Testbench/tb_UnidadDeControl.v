module tb_control_unit;

    logic clk, reset;
    logic [31:0] instr;
    logic Zero, Less;

    logic PCWrite, PCWriteCond, IRWrite;
    logic RegWrite, MemRead, MemWrite, ByteEn;
    logic ALUSrcA;
    logic [1:0] ALUSrcB, ResultSrc, PCSource;
    logic [2:0] ALUCtrl, ImmSrc;

    control_unit DUT (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .Zero(Zero),
        .Less(Less),
        .PCWrite(PCWrite),
        .PCWriteCond(PCWriteCond),
        .IRWrite(IRWrite),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ByteEn(ByteEn),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUCtrl(ALUCtrl),
        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc),
        .PCSource(PCSource)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        Zero = 0;
        Less = 0;
        #10 reset = 0;

        // ADDI
        instr = 32'h00178793;
        #50;

        // BRANCH
        instr = 32'hfce7d0e3;
        Less = 1;
        #50;

        $stop;
    end

endmodule
