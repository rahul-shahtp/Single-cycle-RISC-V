// Program Counter Logic Module
// Calculates the next PC value based on instruction type (normal, branch, or jump)
module pc_logic (
    input [31:0] pc_current,
    input [31:0] imm,
    input [31:0] alu_result,
    input branch_taken,
    input jump,
    input [1:0] pc_src,
    output reg [31:0] pc_next
);

    localparam pc_plus4 = 2'b00;  // Sequential: PC + 4 (next instruction)
    localparam pc_branch = 2'b01; // Conditional branch: PC + offset if taken, else PC + 4
    localparam pc_JAL = 2'b10;    // Unconditional jump: PC + offset
    localparam pc_JALR = 2'b11;   // Jump register (JALR): ALU result (used for indirect jumps)

    always @(*) begin
        case (pc_src)
            pc_plus4: begin
                pc_next = pc_current + 32'h4;
            end
            pc_branch: begin
                if (branch_taken)
                    pc_next = pc_current + imm;
                else
                    pc_next = pc_current + 32'h4;
            end
            pc_JAL: begin
                pc_next = pc_current + imm;
            end
            pc_JALR: begin
                pc_next = {alu_result[31:1], 1'b0};
            end
            default: pc_next = pc_current + 32'h4;
        endcase
    end
    
endmodule