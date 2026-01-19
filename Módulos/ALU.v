module alu (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [2:0]  ALUCtrl,
    output logic [31:0] Result,
    output logic        Zero,
    output logic        Less
);
 
    always_comb begin
        case (ALUCtrl)
            3'b000: Result = A + B;              // ADD
            3'b001: Result = A - B;              // SUB
            3'b010: Result = A & B;              // AND
            3'b011: Result = A << B[4:0];        // SLL
            default: Result = 32'b0;
        endcase
    end
 
    assign Zero = (Result == 32'b0);
    assign Less = ($signed(A) < $signed(B));
 
endmodule