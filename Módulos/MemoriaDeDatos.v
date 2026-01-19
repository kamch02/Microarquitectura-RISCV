module data_mem (
    input  logic        clk,
    input  logic        MemRead,
    input  logic        MemWrite,
    input  logic        ByteEn,
    input  logic [31:0] addr,
    input  logic [31:0] write_data,
    output logic [31:0] read_data
);

    logic [31:0] mem [0:255];

    always_ff @(posedge clk) begin
        if (MemWrite) begin
            if (ByteEn)
                mem[addr[9:2]][7:0] <= write_data[7:0];
            else
                mem[addr[9:2]] <= write_data;
        end
    end

    assign read_data = (MemRead) ? mem[addr[9:2]] : 32'b0;

endmodule
