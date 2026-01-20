module control_unit (
    input        clk,
    input        reset,
    input  [31:0] instr,
    input        Zero,
    input        Less,
 
    output reg   PCWrite,
    output reg   IRWrite,
    output reg   RegWrite,
    output reg   MemRead,
    output reg   MemWrite,
    output reg   ByteEn,
 
    output reg   ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [2:0] ALUCtrl,
 
    output reg [1:0] ResultSrc,
    output reg [2:0] ImmSrc,
    output reg [1:0] PCSource
);
 
    // -----------------------------
    // Opcode extraction
    // -----------------------------
    wire [6:0] opcode;
    assign opcode = instr[6:0];
 
    // -----------------------------
    // FSM states
    // -----------------------------
    parameter S_FETCH      = 4'd0,
              S_DECODE     = 4'd1,
              S_EXEC_I     = 4'd2,
              S_MEM_ADDR   = 4'd3,
              S_MEM_READ   = 4'd4,
              S_MEM_WRITE  = 4'd5,
              S_WB_ALU     = 4'd6,
              S_WB_MEM     = 4'd7,
              S_BRANCH     = 4'd8,
              S_JUMP       = 4'd9;
 
    reg [3:0] state, next_state;
 
    // -----------------------------
    // State register
    // -----------------------------
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S_FETCH;
        else
            state <= next_state;
    end
 
    // -----------------------------
    // Next-state logic
    // -----------------------------
    always @(*) begin
        case (state)
 
            S_FETCH:
                next_state = S_DECODE;
 
            S_DECODE: begin
                case (opcode)
                    7'b0010011: next_state = S_EXEC_I;     // addi, andi, slli
                    7'b0000011: next_state = S_MEM_ADDR;   // lw
                    7'b0100011: next_state = S_MEM_ADDR;   // sw, sb
                    7'b1100011: next_state = S_BRANCH;     // bge, bne
                    7'b1101111: next_state = S_JUMP;       // jal
                    default:    next_state = S_FETCH;
                endcase
            end
 
            S_EXEC_I:
                next_state = S_WB_ALU;
 
            S_MEM_ADDR:
                if (opcode == 7'b0000011)
                    next_state = S_MEM_READ;
                else
                    next_state = S_MEM_WRITE;
 
            S_MEM_READ:
                next_state = S_WB_MEM;
 
            S_MEM_WRITE:
                next_state = S_FETCH;
 
            S_WB_ALU:
                next_state = S_FETCH;
 
            S_WB_MEM:
                next_state = S_FETCH;
 
            S_BRANCH:
                next_state = S_FETCH;
 
            S_JUMP:
                next_state = S_FETCH;
 
            default:
                next_state = S_FETCH;
 
        endcase
    end
 
    // -----------------------------
    // Output logic
    // -----------------------------
    always @(*) begin
        // Default values
        PCWrite   = 0;
        IRWrite   = 0;
        RegWrite  = 0;
        MemRead   = 0;
        MemWrite  = 0;
        ByteEn    = 0;
        ALUSrcA   = 0;
        ALUSrcB   = 2'b00;
        ALUCtrl   = 3'b000;
        ResultSrc = 2'b00;
        ImmSrc    = 3'b000;
        PCSource  = 2'b00;
 
        case (state)
 
            // -------------------------
            // FETCH
            // -------------------------
            S_FETCH: begin
                IRWrite = 1;
                PCWrite = 1;
                ALUSrcA = 0;        // PC
                ALUSrcB = 2'b01;    // +4
                ALUCtrl = 3'b000;   // ADD
                PCSource = 2'b00;   // ALU result
            end
 
            // -------------------------
            // DECODE (no control action)
            // -------------------------
            S_DECODE: begin
                // Just decode
            end
 
            // -------------------------
            // EXECUTE I-TYPE
            // -------------------------
            S_EXEC_I: begin
                ALUSrcA = 1;
                ALUSrcB = 2'b10;
                ALUCtrl = (instr[14:12] == 3'b000) ? 3'b000 : // addi
                          (instr[14:12] == 3'b111) ? 3'b010 : // andi
                          3'b011;                              // slli
                ImmSrc  = 3'b000;
            end
 
            // -------------------------
            // MEMORY ADDRESS CALC
            // -------------------------
            S_MEM_ADDR: begin
                ALUSrcA = 1;
                ALUSrcB = 2'b10;
                ALUCtrl = 3'b000;
                ImmSrc  = (opcode == 7'b0100011) ? 3'b001 : 3'b000;
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
            // WRITE BACK FROM ALU
            // -------------------------
            S_WB_ALU: begin
                RegWrite  = 1;
                ResultSrc = 2'b00;
            end
 
            // -------------------------
            // WRITE BACK FROM MEMORY
            // -------------------------
            S_WB_MEM: begin
                RegWrite  = 1;
                ResultSrc = 2'b01;
            end
 
            // -------------------------
            // BRANCH
            // -------------------------
            S_BRANCH: begin
                ALUSrcA  = 1;
                ALUSrcB  = 2'b10;
                ALUCtrl  = 3'b001;
                ImmSrc   = 3'b010;
                if (Less || !Zero) begin
                    PCWrite  = 1;
                    PCSource = 2'b10;
                end
            end
 
            // -------------------------
            // JUMP (jal)
            // -------------------------
            S_JUMP: begin
                RegWrite  = 1;
                ResultSrc = 2'b10; // PC+4
                PCWrite   = 1;
                PCSource  = 2'b10;
                ImmSrc    = 3'b100;
            end
 
        endcase
    end
 
endmodule
