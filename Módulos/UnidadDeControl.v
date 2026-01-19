module control_unit (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instr,
    input  logic        Zero,
    input  logic        Less,

    output logic        PCWrite,
    output logic        PCWriteCond,
    output logic        IRWrite,
    output logic        RegWrite,
    output logic        MemRead,
    output logic        MemWrite,
    output logic        ByteEn,

    output logic        ALUSrcA,
    output logic [1:0]  ALUSrcB,
    output logic [2:0]  ALUCtrl,

    output logic [1:0]  ResultSrc,
    output logic [2:0]  ImmSrc,
    output logic [1:0]  PCSource
);

    // -------------------------
    // Opcode extraction
    // -------------------------
    logic [6:0] opcode;
    assign opcode = instr[6:0];

    // -------------------------
    // FSM States
    // -------------------------
    typedef enum logic [3:0] {
        S_FETCH      = 4'd0,
        S_DECODE     = 4'd1,
        S_EXEC_I     = 4'd2,
        S_EXEC_U     = 4'd3,
        S_MEM_ADDR   = 4'd4,
        S_MEM_READ   = 4'd5,
        S_MEM_WRITE  = 4'd6,
        S_WB_ALU     = 4'd7,
        S_WB_LW      = 4'd8,
        S_BRANCH     = 4'd9,
        S_JUMP       = 4'd10
    } state_t;

    state_t state, next_state;

    // -------------------------
    // State register
    // -------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= S_FETCH;
        else
            state <= next_state;
    end

    // -------------------------
    // Next-state logic
    // -------------------------
    always_comb begin
        next_state = state;

        case (state)

            S_FETCH:
                next_state = S_DECODE;

            S_DECODE: begin
                case (opcode)
                    7'b0010011: next_state = S_EXEC_I;    // addi, andi, slli
                    7'b0110111: next_state = S_EXEC_U;    // lui
                    7'b0000011: next_state = S_MEM_ADDR;  // lw
                    7'b0100011: next_state = S_MEM_ADDR;  // sw, sb
                    7'b1100011: next_state = S_BRANCH;    // bne, bge
                    7'b1101111: next_state = S_JUMP;      // jal
                    default:    next_state = S_FETCH;
                endcase
            end

            S_EXEC_I,
            S_EXEC_U:
                next_state = S_WB_ALU;

            S_MEM_ADDR:
                if (opcode == 7'b0000011)
                    next_state = S_MEM_READ;
                else
                    next_state = S_MEM_WRITE;

            S_MEM_READ:
                next_state = S_WB_LW;

            S_MEM_WRITE:
                next_state = S_FETCH;

            S_WB_ALU,
            S_WB_LW,
            S_BRANCH,
            S_JUMP:
                next_state = S_FETCH;

            default:
                next_state = S_FETCH;
        endcase
    end

    // -------------------------
    // Output logic (control signals)
    // -------------------------
    always_comb begin
        // Defaults
        PCWrite     = 0;
        PCWriteCond = 0;
        IRWrite     = 0;
        RegWrite    = 0;
        MemRead     = 0;
        MemWrite    = 0;
        ByteEn      = 0;

        ALUSrcA     = 0;
        ALUSrcB     = 2'b00;
        ALUCtrl     = 3'b000;

        ResultSrc   = 2'b00;
        ImmSrc      = 3'b000;
        PCSource    = 2'b00;

        case (state)

            // -------------------------
            // FETCH
            // -------------------------
            S_FETCH: begin
                IRWrite  = 1;
                ALUSrcA  = 0;          // PC
                ALUSrcB  = 2'b01;      // +4
                ALUCtrl  = 3'b000;     // ADD
                PCWrite  = 1;
                PCSource = 2'b00;      // ALU result
            end

            // -------------------------
            // EXECUTE I-type
            // -------------------------
            S_EXEC_I: begin
                ALUSrcA = 1;
                ALUSrcB = 2'b10;       // immediate
                ImmSrc  = 3'b000;      // I-type
            end

            // -------------------------
            // EXECUTE U-type (lui)
            // -------------------------
            S_EXEC_U: begin
                ImmSrc = 3'b011;       // U-type
            end

            // -------------------------
            // MEMORY ADDRESS CALC
            // -------------------------
            S_MEM_ADDR: begin
                ALUSrcA = 1;
                ALUSrcB = 2'b10;
                ImmSrc  = 3'b001;      // S-type
            end

            // -------------------------
            // MEMORY READ
            // -------------------------
            S_MEM_READ: begin
                MemRead = 1;
            end

            // -------------------------
            // MEMORY WRITE
            // -------------------------
            S_MEM_WRITE: begin
                MemWrite = 1;
                ByteEn   = (instr[14:12] == 3'b000); // sb
            end

            // -------------------------
            // WRITE BACK ALU
            // -------------------------
            S_WB_ALU: begin
                RegWrite  = 1;
                ResultSrc = 2'b00;     // ALUOut
            end

            // -------------------------
            // WRITE BACK LOAD
            // -------------------------
            S_WB_LW: begin
                RegWrite  = 1;
                ResultSrc = 2'b01;     // MDR
            end

            // -------------------------
            // BRANCH
            // -------------------------
            S_BRANCH: begin
                ALUSrcA     = 1;
                ALUSrcB     = 2'b00;
                ALUCtrl     = 3'b001;  // SUB
                PCSource    = 2'b01;   // ALUOut
                ImmSrc      = 3'b010;  // B-type

                if ((instr[14:12] == 3'b001 && !Zero) || // bne
                    (instr[14:12] == 3'b101 && Less))   // bge
                    PCWrite = 1;
            end

            // -------------------------
            // JUMP
            // -------------------------
            S_JUMP: begin
                PCWrite  = 1;
                PCSource = 2'b10;      // PC + immediate
                ImmSrc   = 3'b100;     // J-type
            end

        endcase
    end

endmodule
