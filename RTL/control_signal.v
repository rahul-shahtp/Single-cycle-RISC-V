// Control Signal Generator Module
// Decodes instruction fields and generates control signals for all processor components
module control_signal (
    input [6:0]opcode,          // 7-bit opcode field
    input [2:0]func3,           // 3-bit function code
    input [6:0]func7,           // 7-bit function code
    output reg reg_write,       // Register write enable
    output reg memory_read,     // Data memory read enable
    output reg memory_write,    // Data memory write enable
    output reg memory_to_reg,   // Mux select: ALU result or memory data
    output reg alu_src,         // ALU operand B source: register or immediate
    output reg branch,          // Branch instruction flag
    output reg jump,            // Jump instruction flag
    output reg [3:0]alu_opcode, // ALU operation code
    output reg [1:0]pc_src      // PC source select
);

// ALU operation
localparam alu_add = 4'b0000;
localparam alu_sub = 4'b0001;
localparam alu_and = 4'b0010;
localparam alu_or = 4'b0011;
localparam alu_xor = 4'b0100;
localparam alu_SLT = 4'b0101;
localparam alu_SLTU = 4'b0110;

// PC operation
localparam pc_plus4 = 2'b00;
localparam pc_branch =2'b01;
localparam pc_JAL = 2'b10;
localparam pc_JALR = 2'b11;

always @(*) begin
    reg_write = 1'b0;
    memory_read = 1'b0;
    memory_write = 1'b0;
    memory_to_reg = 1'b0;
    alu_src = 1'b0;
    branch = 1'b0;
    jump = 1'b0;
    alu_opcode = alu_add;
    pc_src = pc_plus4;

    case (opcode)
        // R - type 
        7'b0110011 : begin
            reg_write = 1'b1;
            alu_src = 1'b0;
            case (func3)
            3'b000 : alu_opcode = (func7[5]) ? alu_sub : alu_add ;
            3'b111 : alu_opcode = alu_and;
            3'b110 : alu_opcode = alu_or;
            3'b100 : alu_opcode = alu_xor;
            3'b010 : alu_opcode = alu_SLT;
            default : alu_opcode = alu_add;
            endcase
        end

        // I type 
        7'b0010011 : begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            case (func3)
            3'b000 : alu_opcode = alu_add ;
            3'b111 : alu_opcode = alu_and;
            3'b110 : alu_opcode = alu_or;
            3'b100 : alu_opcode = alu_xor;
            3'b010 : alu_opcode = alu_SLT;
            default : alu_opcode = alu_add;
            endcase
        end

        // load LW 
        7'b0000011 : begin
            reg_write = 1'b1;
            memory_to_reg = 1'b1;
            memory_read = 1'b1;
            alu_src = 1'b1;
            alu_opcode = alu_add;
        end

        // store SW
        7'b0100011 : begin
            memory_write = 1'b1;
            alu_src = 1'b1;
            alu_opcode = alu_add;
        end

        // branch
        7'b1100011 : begin
            branch = 1'b1;
            alu_src = 1'b0;
            pc_src = pc_branch;
            alu_opcode = alu_sub;
        end

        // JAL
        7'b1101111 : begin
            reg_write = 1'b1;
            jump = 1'b1;
            pc_src = pc_JAL;
        end

        // JALR 
        7'b1100111 : begin
            reg_write =1'b1;
            jump = 1'b1;
            alu_src = 1'b1;
            pc_src = pc_JALR;
            alu_opcode = alu_add;
        end
        
        // LUI
        7'b0110111 : begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            alu_opcode = alu_add;
        end
        default: begin
            // all signal at default
        end
    endcase
    
end
    
endmodule