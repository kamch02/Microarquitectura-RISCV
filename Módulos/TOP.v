module top_riscv_multiciclo (
    input logic clk,
    input logic reset
);

    // -------------------------------------------------
    // Program Counter
    // -------------------------------------------------
    logic [31:0] PC, PC_next;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'b0;
        else
            PC <= PC_next;
    end

    // -------------------------------------------------
    // Instruction Memory + IR
    // -------------------------------------------------
    logic [31:0] instr_mem_out;
    logic [31:0] IR;
    logic IRWrite;

    instr_mem IMEM (
        .addr (PC),
        .instr (instr_mem_out)
    );

    always_ff @(posedge clk) begin
        if (IRWrite)
            IR <= instr_mem_out;
    end

    // -------------------------------------------------
    // Register File
    // -------------------------------------------------
    logic [4:0] rs1, rs2, rd;
    logic [31:0] reg_rd1, reg_rd2;
    logic RegWrite;
    logic [31:0] write_data;

    assign rs1 = IR[19:15];
    assign rs2 = IR[24:20];
    assign rd  = IR[11:7];

    reg_file RF (
        .clk       (clk),
        .RegWrite  (RegWrite),
        .rs1       (rs1),
        .rs2       (rs2),
        .rd        (rd),
        .wd        (write_data),
        .rd1       (reg_rd1),
        .rd2       (reg_rd2)
    );

    // -------------------------------------------------
    // A / B Registers
    // -------------------------------------------------
    logic [31:0] A, B;

    always_ff @(posedge clk) begin
        A <= reg_rd1;
        B <= reg_rd2;
    end

    // -------------------------------------------------
    // Immediate Generator
    // -------------------------------------------------
    logic [31:0] imm_ext;
    logic [2:0] ImmSrc;

    imm_gen IMM (
        .instr   (IR),
        .ImmSrc  (ImmSrc),
        .imm_ext (imm_ext)
    );

    // -------------------------------------------------
    // ALU + ALUOut
    // -------------------------------------------------
    logic [31:0] ALU_inA, ALU_inB;
    logic [31:0] ALU_result;
    logic Zero, Less;
    logic [2:0] ALUCtrl;
    logic ALUSrcA;
    logic [1:0] ALUSrcB;
    logic [31:0] ALUOut;

    assign ALU_inA = (ALUSrcA) ? A : PC;

    assign ALU_inB = (ALUSrcB == 2'b00) ? B :
                     (ALUSrcB == 2'b01) ? 32'd4 :
                     (ALUSrcB == 2'b10) ? imm_ext :
                                           32'b0;

    alu ALU (
        .A      (ALU_inA),
        .B      (ALU_inB),
        .ALUCtrl(ALUCtrl),
        .Result (ALU_result),
        .Zero   (Zero),
        .Less   (Less)
    );

    always_ff @(posedge clk) begin
        ALUOut <= ALU_result;
    end

    // -------------------------------------------------
    // Data Memory + MDR
    // -------------------------------------------------
    logic MemRead, MemWrite, ByteEn;
    logic [31:0] mem_read_data;
    logic [31:0] MDR;

    data_mem DMEM (
        .clk        (clk),
        .MemRead    (MemRead),
        .MemWrite   (MemWrite),
        .ByteEn     (ByteEn),
        .addr       (ALUOut),
        .write_data (B),
        .read_data  (mem_read_data)
    );

    always_ff @(posedge clk) begin
        MDR <= mem_read_data;
    end

    // -------------------------------------------------
    // Write Back MUX
    // -------------------------------------------------
    logic [1:0] ResultSrc;

    assign write_data =
        (ResultSrc == 2'b00) ? ALUOut :
        (ResultSrc == 2'b01) ? MDR :
        (ResultSrc == 2'b10) ? (PC + 4) :
                               32'b0;

    // -------------------------------------------------
    // PC Update Logic
    // -------------------------------------------------
    logic PCWrite, PCWriteCond;
    logic [1:0] PCSource;

    assign PC_next =
        (PCSource == 2'b00) ? ALU_result :
        (PCSource == 2'b01) ? ALUOut :
        (PCSource == 2'b10) ? (PC + imm_ext) :
                               PC;

    always_comb begin
        if (PCWrite)
            PC_next = PC_next;
        else
            PC_next = PC;
    end

    // -------------------------------------------------
    // Control Unit (FSM)
    // -------------------------------------------------
    control_unit CU (
        .clk        (clk),
        .reset      (reset),
        .instr      (IR),
        .Zero       (Zero),
        .Less       (Less),

        .PCWrite    (PCWrite),
        .PCWriteCond(PCWriteCond),
        .IRWrite    (IRWrite),
        .RegWrite   (RegWrite),
        .MemRead    (MemRead),
        .MemWrite   (MemWrite),
        .ByteEn     (ByteEn),

        .ALUSrcA    (ALUSrcA),
        .ALUSrcB    (ALUSrcB),
        .ALUCtrl    (ALUCtrl),

        .ResultSrc  (ResultSrc),
        .ImmSrc     (ImmSrc),
        .PCSource   (PCSource)
    );

endmodule
