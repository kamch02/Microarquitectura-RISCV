`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2026 06:35:43 PM
// Design Name: 
// Module Name: TbALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ps

module TbALU;

    reg  [31:0] A, B;
    reg  [2:0]  ALUCtrl;
    wire [31:0] Result;
    wire        Zero, Less;

    // Si tu módulo se llama ALU (mayúsculas), cambia alu por ALU aquí
    ALU DUT (
        .A(A),
        .B(B),
        .ALUCtrl(ALUCtrl),
        .Result(Result),
        .Zero(Zero),
        .Less(Less)
    );

    initial begin
        // (opcional) valores iniciales
        A = 0; B = 0; ALUCtrl = 3'b000;
        #5;

        // ADD
        A = 32'd10; B = 32'd5; ALUCtrl = 3'b000; #10;

        // SUB
        A = 32'd5;  B = 32'd5; ALUCtrl = 3'b001; #10;

        // AND
        A = 32'h000000FF; B = 32'h0000000F; ALUCtrl = 3'b010; #10;

        // SHIFT LEFT
        A = 32'd4;  B = 32'd1; ALUCtrl = 3'b011; #10;

        $stop;
    end

endmodule
