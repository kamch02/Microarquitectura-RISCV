`timescale 1ns / 1ps
module tb_top_riscv_multiciclo;
    reg clk;
    reg reset;
    integer k;
 
    // 
    // DUT
    // 
    top_riscv_multiciclo DUT (
        .clk(clk),
        .reset(reset)
    );
 
    // 
    // Clock: 100 MHz (10 ns)
    // 
    always #5 clk = ~clk;
 
    // 
    // FETCH monitor (diagnóstico)
    // 
    initial begin
        k = 0;
        wait (reset == 0);
        for (k = 0; k < 200; k = k + 1) begin
            @(posedge clk);
            if (DUT.IRWrite) begin
                $display("FETCH pc=%h instr=%h", DUT.PC, DUT.instr);
            end
            if (DUT.PC > 32'h00000100) begin
                $display("PC SE SALIO: PC=%h IR=%h", DUT.PC, DUT.IR);
                $stop;
            end
        end
    end
 
    // 
    // 
    initial begin
        // Inicialización
        clk   = 0;
        reset = 1;
 
        // Reset activo
        #20;
        reset = 0;
 
        // 
        // EJECUCIÓN MULTICICLO
        // 
        // 
        wait (DUT.PC == 32'h0000008C);
 

        #10;
 
        // 
        // VERIFICACIÓN EN MEMORIA
        // 
        $display("================================");
        $display(" Verificacion TOP RISC-V ");
        $display("================================");
        // Dump alrededor del stack frame
        $display("mem[56] = %h", DUT.DMEM.mem[56]);
        $display("mem[57] = %h", DUT.DMEM.mem[57]);
        $display("mem[58] = %h", DUT.DMEM.mem[58]);
        $display("mem[59] = %h", DUT.DMEM.mem[59]);
        $display("mem[60] = %h", DUT.DMEM.mem[60]);
        // Interpretación esperada según los requerimientos del proyecto y el código original en C
        $display("--------------------------------");
        $display("a (char) = %c", DUT.DMEM.mem[56][7:0]);
        $display("b (int)  = %h", DUT.DMEM.mem[59]);
        $display("--------------------------------");
     // PC / IR final (control de flujo) para detectar errores
        $display("PC final = %h", DUT.PC);
        $display("IR final = %h", DUT.IR);
        $display("PC=%h IR=%h opcode=%b ImmSrc=%b ImmExt=%h",
                 DUT.PC, DUT.IR, DUT.IR[6:0], DUT.CU.ImmSrc, DUT.ImmExt);
        $display("================================");
 
        // Detener simulación
        $stop;
    end
endmodule
