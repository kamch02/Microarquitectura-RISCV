`timescale 1ns / 1ps

module alu (

    //Inputs de la ALU
    input  [31:0] A,
    input  [31:0] B,
    
    //Selector de función a realizar
    input  [2:0]  ALUCtrl,
    
    //Outputs (Resultado y banderas)
    output reg [31:0] Result,
    output wire Zero,        //BAndera Z
    output wire Less         //Bandera N
);

    // Deco para seleccionar función
    always @(*) begin
        case (ALUCtrl)
            3'b000: Result = A + B;        // ADD
            3'b001: Result = A - B;        // SUB
            3'b010: Result = A & B;        // AND
            3'b011: Result = A << B[4:0];  // SLL
            default: Result = 32'b0;
        endcase
    end

    // Banderas
    assign Zero = (Result == 32'b0);
    assign Less = ($signed(A) < $signed(B));

endmodule
