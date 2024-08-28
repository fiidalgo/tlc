module timer
    #(parameter N = 4)  // Parameter for bit-width of the timer
    (
        input logic clk, clk_en,       // System clock and clock enable signal
        input logic rst, en, load,     // Reset, enable, and load signals
        input logic [N-1:0] init,      // Initial value for the timer
        output logic [N-1:0] out       // Timer output
    );

    // Synchronous process for the timer
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            // If reset is asserted, set output to maximum value
            out <= {N{1'b1}};
        end
        else if (load) begin
            // If load signal is asserted, load the initial value into the timer
            out <= init;
        end
        else if (clk_en) begin
            // On each clock cycle when clock enable is active
            if (en && out > 0) begin
                // If enabled and output is not zero, decrement the timer
                out <= out - 1;
            end 
        end
    end

endmodule
