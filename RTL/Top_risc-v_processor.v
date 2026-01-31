// Top-level RISC-V Processor Module
// Integrates all components: PC, Instruction Memory, Register File, ALU, and Data Memory
module top_riscv (
    input clk,          // Clock signal
    input reset         // Reset signal
);
    // pc counter
    wire [31:0]pc_current;
    wire [31:0]pc_next;

    // instruction
    wire [31:0]instruction;

    // instruction field
    wire [6:0]opcode;
    wire [4:0]rs1,rs2,rd;
    wire [2:0]func3;
    wire [6:0]func7;

    // control signal
    wire reg_write;
    wire memory_read;
    wire memory_write;
    wire memory_to_reg;
    wire alu_src;
    wire branch;
    wire jump;
    wire [3:0]alu_opcode;
    wire [1:0]pc_src;

    // register file
    wire [31:0]read_data1;
    wire [31:0]read_data2;
    wire [31:0]write_data;

    // immedite
    wire [31:0]imm;

    // alu
    wire [31:0]alu_operand_b;
    wire [31:0]alu_result;
    wire zero_flag;

    // data memory
    wire [31:0]memory_read_data;

    // branch
    wire branch_taken;

    // pc
    wire [31:0]pc_plus4;
    assign pc_plus4 = pc_current + 32'h4;

    // 
    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign func3 = instruction[14:12];
    assign rs1 =  instruction[19:15];
    assign rs2 = instruction[24:20];
    assign func7 = instruction[31:25];

    assign alu_operand_b = (alu_src) ? imm : read_data2;

    assign write_data = (jump) ? pc_plus4 : (memory_to_reg) ? memory_read_data : alu_result;

    // Module Instantiations

    // pc
    program_counter pc(
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_current(pc_current)
    );

    // instruction memory
    instruction_memory im(
        .address(pc_current),
        .instruction(instruction)
    );

    // control unit
    control_signal cs(
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .reg_write(reg_write),
        .memory_read(memory_read),
        .memory_write(memory_write),
        .memory_to_reg(memory_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .alu_opcode(alu_opcode),
        .pc_src(pc_src)
    );

    // register file
    register_file rf(
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_reg1(rs1),
        .read_reg2(rs2),
        .write_reg(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // immediate generator
    immediate_generator img(
        .instruction(instruction),
        .imm_out(imm)
    );

    // alu
    ALU alu(
        .operand_a(read_data1),
        .operand_b(alu_operand_b),
        .alu_opcode(alu_opcode),
        .alu_result(alu_result),
        .zero_flag(zero_flag)
    );

    // data memory
    data_memory dm(
        .clk(clk),
        .memory_read(memory_read),
        .memory_write(memory_write),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(memory_read_data)
    );

    // branch unit
    branch_unit bu(
        .branch(branch),
        .func3(func3),
        .operand_a(read_data1),
        .operand_b(read_data2),
        .branch_taken(branch_taken)
    );

    // pc logic
    pc_logic pC(
        .pc_current(pc_current),
        .imm(imm),
        .alu_result(alu_result),
        .branch_taken(branch_taken),
        .jump(jump),
        .pc_src(pc_src),
        .pc_next(pc_next)
    );



endmodule