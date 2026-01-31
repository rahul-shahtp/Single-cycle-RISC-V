// Program Counter (PC) Module
// Stores and updates the current instruction address
module program_counter (
    input clk,                  // Clock signal
    input reset,                // Reset signal
    input [31:0]pc_next,        // Next PC value
    output reg [31:0]pc_current // Current PC value
);
  always @(posedge clk or posedge reset) begin
    if (reset) 
      // Reset: PC starts at address 0x0
      pc_current <= 32'h00000000;
    else 
      // Update PC with next value on each clock cycle
      pc_current <= pc_next;
  end

endmodule