// Branch Unit Module
// Determines if a branch should be taken based on comparison of two operands
module branch_unit (
    input branch,               // Branch instruction flag
    input [2:0]func3,           // Function code (specifies branch type)
    input [31:0]operand_a,      // First operand for comparison
    input [31:0]operand_b,      // Second operand for comparison
    output reg branch_taken     // Set if branch condition is true
);
// func3 field
localparam BEQ = 3'b000;  // Branch if Equal
localparam BNE = 3'b001;  // Branch if Not Equal
localparam BLT = 3'b100;  // Branch if Less Than (signed)
localparam BGE = 3'b101;  // Branch if Greater or Equal (signed)

always @(*) begin
    branch_taken = 1'b0;  // Default: branch not taken

    // Check branch condition based on instruction type
    if (branch) begin
        case (func3)
        BEQ : branch_taken = (operand_a == operand_b);                           // Equal
        BNE : branch_taken = (operand_a != operand_b);                           // Not equal
        BLT : branch_taken = ($signed(operand_a) < $signed(operand_b));         // Less than (signed)
        BGE : branch_taken = ($signed(operand_a) >= $signed(operand_b));        // Greater/equal (signed)
            default: branch_taken = 1'b0;  
        endcase
    end
end
endmodule