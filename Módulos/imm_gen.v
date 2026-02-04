`timescale 1ns / 1ps

module imm_gen (
    input  [31:0] instr,
    input  [2:0]  ImmSrc,
    output reg [31:0] imm_ext
);

    always @(*) begin
        case (ImmSrc)

            // Tipo I (addi, lw, andi, slli)
            3'b000:
                imm_ext = {{20{instr[31]}}, instr[31:20]};

            // Tipo S (sw, sb)
            3'b001:
                imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            // Tipo B (beq, bne, bge)
            3'b010:
                imm_ext = {{19{instr[31]}}, instr[31], instr[7],
                           instr[30:25], instr[11:8], 1'b0};

            // Tipo U (lui)
            3'b011:
                imm_ext = {instr[31:12], 12'b0};

            // Tipo J (jal) (para JUMP)
            3'b100:
                imm_ext = {{11{instr[31]}}, instr[31],
                           instr[19:12], instr[20],
                           instr[30:21], 1'b0};

            default:
                imm_ext = 32'b0; //se mantiene el valor del inmediato extendido como 0 para evitar escrituras erróneas
        endcase
    end

endmodule


