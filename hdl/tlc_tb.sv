`include "tlc.svh"  // Include the header file for traffic light controller constants and definitions

module tlc_tb    
    #(parameter N = 4);  // Parameter N defines the bit-width of the timer

    // Clock signal
    logic clk = 0;
    always #5 clk = ~clk;  // Generate a clock with a period of 10 time units (5 units high, 5 units low)
    
    // Internal signals for the testbench
    logic clk_divided, reset_sig;  // Clock divider output and reset signal

    // Instantiate the clock divider unit under test (CUUT)
    clk_divider cuut
    (
        .clk_in(clk),         // Input clock
        .clk_out(clk_divided), // Divided clock output
        .rst(reset_sig)       // Reset signal
    );
    
    // Timer control signals
    logic en, load;  // Enable and load signals for the timer
    logic [N-1:0] init = 4'b0111;  // Initial value for the timer
    logic [N-1:0] timer_out;       // Timer output
    
    // Instantiate the timer unit under test (TUUT)
    timer tuut
    (
        .clk(clk),             // Input clock
        .clk_en(clk_divided),  // Enable signal (divided clock)
        .rst(reset_sig),       // Reset signal
        .en(en),               // Enable signal for the timer
        .load(load),           // Load signal for the timer
        .init(init),           // Initial value for the timer
        .out(timer_out)        // Timer output
    );
    
    // Initial block to drive the testbench simulation
    initial begin
        clk = 0;             // Initialize the clock signal
        reset_sig = 1;       // Assert reset signal
        
        #15;                 // Wait for 15 time units
        
        reset_sig = 0;       // Deassert reset signal
        
        #15;                 // Wait for 15 time units
        
        load = 1;            // Load the initial value into the timer
        #15;
        load = 0;            // Deassert load signal
        #15;
        en = 1;              // Enable the timer
        
        #300;                // Run the simulation for 300 time units
        
        en = 0;              // Disable the timer
        
        #100;                // Wait for 100 time units
        
        en = 1;              // Enable the timer again
        
        #300;                // Run the simulation for another 300 time units
        
        reset_sig = 1;       // Assert reset signal again
        
        #15;                 // Wait for 15 time units
        
        reset_sig = 0;       // Deassert reset signal
    end
    
endmodule
