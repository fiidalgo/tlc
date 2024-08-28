module clk_divider
    #(
        parameter div_amt = 10 // Parameter to set the division amount (number of input clock edges per output clock pulse)
    )
    (
        input logic clk_in, rst,   // Input clock and reset signals
        output logic clk_out       // Output clock signal (divided clock)
    );

    // A long counter to track the number of clock cycles
    logic [63:0] counting_vj; // Counter variable to count the number of input clock edges

    // Always block to generate the divided clock
    // The block is triggered on the rising edge of the input clock (clk_in) or the reset signal (rst)
    always_ff @(posedge clk_in, posedge rst) begin
        if (rst) begin
            clk_out <= 0;           // Reset the output clock to 0 on reset
            counting_vj <= 0;       // Reset the counter to 0 on reset
        end else begin
            if (counting_vj == div_amt - 1) begin
                clk_out <= 1;       // Generate a positive edge on clk_out when the counter reaches the division amount
                counting_vj <= 0;   // Reset the counter after reaching the division amount
            end else begin
                clk_out <= 0;       // Keep clk_out low otherwise
                counting_vj <= counting_vj + 1; // Increment the counter on each clock cycle
            end
        end
    end
endmodule
