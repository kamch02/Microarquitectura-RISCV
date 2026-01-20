module top_riscv_multiciclo (
    input clk,
    input reset
);
 
    // -------------------------
    // Program Counter
    // -------------------------
    reg [31:0] PC;
    wire [31:0] PC_next;
 
    // -------------------------
    // Instruction Register
    // -------------------------
    reg [31:0] IR;
 
    // -------------------------
    // Memories
    // -------------------------
    wire [31:0] instr;
    wire [31:0] mem_data;
 
    // -------------------------
    // Register file
    // -------------------------
    wire [31:0] RD1, RD2;
 
    // -------------------------
    // ALU
    // -------------------------
    reg  [31:0] ALU_A, ALU_B;
    wire [31:0] ALU_result;
    wire Zero, Less;
 
    // -------------------------
    // Sign extension
    // -------------------------
    wire [31:0] ImmExt;
 
    // -------------------------
    // Control signals
    // -------------------------
    wire PCWrite, IRWrite, RegWrite;
    wire MemRead, MemWrite, ByteEn;
    wire ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [2:0] ALUCtrl;
    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
    wire [1:0] PCSource;
 
    // -------------------------
    // Internal registers (multicycle)
    // -------------------------
    reg [31:0] A, B, ALUOut, MDR;
 
    // -------------------------
    // PC logic
    // -------------------------
    assign PC_next = (PCSource == 2'b00) ? ALU_result :
                     (PCSource == 2'b10) ? ALUOut :
                     PC;
 
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'b0;
        else if (PCWrite)
            PC <= PC_next;
    end
 
    // -------------------------
    // Instruction Register
    // -------------------------
    always @(posedge clk) begin
        if (IRWrite)
            IR <= instr;
    end
 
    // -------------------------
    // Instruction memory
    // -------------------------
    instr_mem IMEM (
        .addr(PC),
        .instr(instr)
    );
 
    // -------------------------
    // Register file
    // -------------------------
    reg_file RF (
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(IR[19:15]),
        .rs2(IR[24:20]),
        .rd(IR[11:7]),
        .wd(
            (ResultSrc == 2'b00) ? ALUOut :
            (ResultSrc == 2'b01) ? MDR :
            PC + 4
        ),
        .rd1(RD1),
        .rd2(RD2)
    );
 
    // -------------------------
    // A & B registers
    // -------------------------
    always @(posedge clk) begin
        A <= RD1;
        B <= RD2;
    end
 
    // -------------------------
    // Immediate generator
    // -------------------------
    imm_gen IMM (
        .instr(IR),
        .ImmSrc(ImmSrc),
        .imm_ext(ImmExt)
    );
 
    // -------------------------
    // ALU input mux
    // -------------------------
    always @(*) begin
        ALU_A = (ALUSrcA) ? A : PC;
 
        case (ALUSrcB)
            2'b00: ALU_B = B;
            2'b01: ALU_B = 32'd4;
            2'b10: ALU_B = ImmExt;
            default: ALU_B = B;
        endcase
    end
 
    // -------------------------
    // ALU
    // -------------------------
    ALU ALU_inst (
        .A(ALU_A),
        .B(ALU_B),
        .ALUCtrl(ALUCtrl),
        .Result(ALU_result),
        .Zero(Zero),
        .Less(Less)
    );
 
    // -------------------------
    // ALUOut register
    // -------------------------
    always @(posedge clk) begin
        ALUOut <= ALU_result;
    end
 
    // -------------------------
    // Data memory
    // -------------------------
    data_mem DMEM (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ByteEn(ByteEn),
        .addr(ALUOut),
        .write_data(B),
        .read_data(mem_data)
    );
 
    // -------------------------
    // MDR register
    // -------------------------
    always @(posedge clk) begin
        MDR <= mem_data;
    end
 
    // -------------------------
    // Control Unit
    // -------------------------
    control_unit CU (
        .clk(clk),
        .reset(reset),
        .instr(IR),
        .Zero(Zero),
        .Less(Less),
        .PCWrite(PCWrite),
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
 
endmodule
