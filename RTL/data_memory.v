// Data Memory Module
// Reads from and writes to memory during load/store operations
module data_memory (
    input clk,                  // Clock signal
    input memory_read,          // Read enable signal
    input memory_write,         // Write enable signal
    input [31:0]address,        // Memory address
    input [31:0]write_data,     // Data to write
    output [31:0]read_data      // Data read from memory
);

// Memory array: 1024 words of 32 bits
reg [31:0]memory[0:1023];

// Combinational read: return memory data if read enabled, else 0
assign read_data = (memory_read) ? memory[address[11:2]] : 32'h0;

always @(posedge clk ) begin
    // Write data on clock edge if write is enabled
    if (memory_write)
      memory[address[11:2]] <= write_data;  // address[11:2] gives word address (ignore lower 2 bits)
end
    
endmodule