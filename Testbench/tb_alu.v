`timescale 1ns/1ps
module tb_alu;

    // Entradas de la ALU
    reg  [31:0] A, B;
    reg  [2:0]  ALUCtrl;

    // Salidas de la ALU
    wire [31:0] Result;
    wire Zero, Less;

    // Instancia de la ALU funcional
    alu DUT (
        .A(A),
        .B(B),
        .ALUCtrl(ALUCtrl),
        .Result(Result),
        .Zero(Zero),
        .Less(Less)
    );

    initial begin
        // 
        // Prueba ADD
        // Verifica que la ALU sume correctamente A + B
        // 
        A = 10; B = 5; ALUCtrl = 3'b000;
        #10;

        // 
        // Prueba SUB
        // Verifica la resta y la activación de bandera Zero
        // 
        A = 10; B = 10; ALUCtrl = 3'b001;
        #10;

        // 
        // Prueba AND
        // Verifica operación lógica bit a bit
        // 
        A = 32'hF0F0; B = 32'h0F0F; ALUCtrl = 3'b010;
        #10;

        // 
        // Prueba SLL
        // Verifica desplazamiento lógico a la izquierda
        // 
        A = 1; B = 3; ALUCtrl = 3'b011;
        #10;

        $stop;
    end
endmodule

