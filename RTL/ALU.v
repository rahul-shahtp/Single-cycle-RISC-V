// Arithmetic Logic Unit (ALU) Module
// Performs arithmetic and logical operations on 32-bit operands
module ALU (
    input [31:0]operand_a,       // First operand
    input [31:0]operand_b,       // Second operand
    input [3:0]alu_opcode,       // Operation code
    output reg [31:0]alu_result, // Result of ALU operation
    output zero_flag            // Flag set if result is zero
); 

localparam alu_add = 4'b0000;   // Addition
localparam alu_sub = 4'b0001;   // Subtraction
localparam alu_and = 4'b0010;   // Bitwise AND
localparam alu_or = 4'b0011;    // Bitwise OR
localparam alu_xor = 4'b0100;   // Bitwise XOR
localparam alu_SLT = 4'b0101;   // Set Less Than (signed)
localparam alu_SLTU = 4'b0110;  // Set Less Than Unsigned

// Set zero flag if result is zero
assign zero_flag = (alu_result == 32'h0);

always @(*) begin
    case (alu_opcode)
    alu_add : alu_result = operand_a + operand_b;   // Add
    alu_sub : alu_result = operand_a - operand_b;   // Subtract
    alu_and : alu_result = operand_a & operand_b;   // AND
    alu_or : alu_result = operand_a | operand_b;    // OR
    alu_xor : alu_result = operand_a ^ operand_b;   // XOR

    // SLT: Compare signed values, return 1 if a < b, else 0
    alu_SLT : alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'h00000001 : 32'h0;

    // SLTU: Compare unsigned values, return 1 if a < b, else 0
    alu_SLTU : alu_result = (operand_a < operand_b) ? 32'h00000001 : 32'h0;

    default: alu_result = 32'h0;  
    endcase
end
endmodule