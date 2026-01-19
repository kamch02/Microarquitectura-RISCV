module imm_gen (
    input  logic [31:0] instr,
    input  logic [2:0]  ImmSrc,
    output logic [31:0] imm_ext
);

    always_comb begin
        case (ImmSrc)

            3'b000: // I-type
                imm_ext = {{20{instr[31]}}, instr[31:20]};

            3'b001: // S-type
                imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            3'b010: // B-type
                imm_ext = {{19{instr[31]}},
                            instr[31],
                            instr[7],
                            instr[30:25],
                            instr[11:8],
                            1'b0};

            3'b011: // U-type (lui)
                imm_ext = {instr[31:12], 12'b0};

            3'b100: // J-type (jal)
                imm_ext = {{11{instr[31]}},
                            instr[31],
                            instr[19:12],
                            instr[20],
                            instr[30:21],
                            1'b0};

            default:
                imm_ext = 32'b0;
        endcase
    end

endmodule
