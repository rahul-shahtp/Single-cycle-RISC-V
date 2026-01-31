// Immediate Value Generator Module
// Extracts and sign-extends immediate values from different instruction formats
module immediate_generator (
    input [31:0] instruction,   // 32-bit instruction
    output reg [31:0] imm_out   // Extracted and sign-extended immediate value
);

// Extract opcode to determine instruction format
wire [6:0]opcode;
assign opcode = instruction[6:0];

always @(*) begin
    case (opcode)
     // I-Type: ADDI, ANDI, ORI, XORI, SLTI, LW, JALR
        7'b0010011,
        7'b0000011,
        7'b1100111:
            imm_out = {{20{instruction[31]}}, instruction[31:20]};      

        // S-Type: SW
        7'b0100011:
            imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

        // B-Type: BEQ, BNE, BLT, BGE
        7'b1100011:
            imm_out = {{20{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

        // U-Type: LUI
        7'b0110111:
            imm_out = {instruction[31:12], 12'b0};

        // J-Type: JAL
        7'b1101111:
            imm_out = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        default: imm_out = 32'h00000000;
        endcase
end
    
endmodule