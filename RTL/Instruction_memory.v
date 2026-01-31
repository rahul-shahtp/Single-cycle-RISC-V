// Instruction Memory Module
// Stores and retrieves 32-bit instructions based on address from PC
module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);
    parameter MAX_SIZE = 1024;
    parameter HEX_FILE = "hex/instruction.hex";
    
    reg [31:0] memory [0:MAX_SIZE-1];
    assign instruction = memory[address[$clog2(MAX_SIZE)-1:2]];
    
    integer i;
    initial begin
        for (i = 0; i < MAX_SIZE; i = i + 1) begin
            memory[i] = 32'h00000013;
        end
        $readmemh(HEX_FILE, memory);
        $display("Instruction Memory initialized from: %s", HEX_FILE);
    end

endmodule