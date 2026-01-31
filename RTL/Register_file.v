// Register File Module
// Stores 32 32-bit registers with dual-read and single-write capability
module register_file (
    input clk,                  // Clock signal
    input reset,                // Reset signal
    input reg_write,            // Write enable signal
    input [4:0]read_reg1,       // Source register 1 (rs1) address
    input [4:0]read_reg2,       // Source register 2 (rs2) address
    input [4:0]write_reg,       // Destination register (rd) address
    input [31:0]write_data,     // Data to write into destination register
    output [31:0]read_data1,    // Data read from rs1
    output [31:0]read_data2     // Data read from rs2
);

   // 32 registers, each 32 bits
   reg [31:0]register[0:31];
   
   // Read operations: return 0 if reading from register 0 (hardwired zero), else return register value
   assign read_data1 = (read_reg1 == 5'b0) ? 32'h0 : register[read_reg1];
   assign read_data2 = (read_reg2 == 5'b0) ? 32'h0 : register[read_reg2];
   
   integer i;
   always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset: Initialize all registers to zero
        for (i = 0; i < 32 ; i= i+1)
        register[i] <= 32'h00000000;
    end else if(reg_write && write_reg != 5'b00000) begin
        // Write operation: Update register on clock edge
        register[write_reg] <= write_data;
    end
  end
endmodule