module tb_alu;

    logic [31:0] A, B;
    logic [2:0]  ALUCtrl;
    logic [31:0] Result;
    logic Zero, Less;

    alu DUT (
        .A(A),
        .B(B),
        .ALUCtrl(ALUCtrl),
        .Result(Result),
        .Zero(Zero),
        .Less(Less)
    );

    initial begin
        // ADD
        A = 10; B = 5; ALUCtrl = 3'b000; #10;

        // SUB (branch)
        A = 5; B = 5; ALUCtrl = 3'b001; #10;

        // AND (andi)
        A = 8'hFF; B = 8'h0F; ALUCtrl = 3'b010; #10;

        // SHIFT LEFT (slli)
        A = 4; B = 1; ALUCtrl = 3'b011; #10;

        $stop;
    end

endmodule
