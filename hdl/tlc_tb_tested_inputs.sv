`include "tlc.svh"  // Include the necessary header file for traffic light controller definitions
`timescale  10 ns / 10 ns  // Set the time scale for the simulation

module tlc_tb;
    parameter div_amt = 10;  // Parameter for the clock division amount
    parameter N = 4;         // Parameter for the width of the timer

    // Internal signals used in the testbench
    logic clk_en, clk;                     // Clock signals
    logic rst, car_ns, car_ew, ped;        // Reset, car presence, and pedestrian request signals
    logic [N-1:0] timer_out;               // Timer output signal
    logic [N-1:0] timer_init;              // Timer initialization value
    logic [2:0] light_ns, light_ew;        // Traffic light signals for North-South and East-West directions
    logic [1:0] light_ped;                 // Pedestrian light signals
    logic timer_load, timer_en;            // Timer control signals
    
    int SECOND = 2 * div_amt;  // Define a second in simulation time, adjusted by the clock division amount
    
    // Instantiate the clock divider unit under test (CUUT)
    clk_divider cuut
    (
        .clk_in(clk),         // Input clock signal
        .clk_out(clk_en),     // Divided clock output signal
        .rst(rst)             // Reset signal
    );

    // Instantiate the timer unit under test (TUUT)
    timer timer_u 
    (
        .clk(clk),             // Input clock signal
        .clk_en(clk_en),       // Enable signal (divided clock)
        .rst(rst),             // Reset signal
        .en(timer_en),         // Enable signal for the timer
        .load(timer_load),     // Load signal for the timer
        .init(timer_init),     // Initial value for the timer
        .out(timer_out)        // Timer output signal
    );

    // Instantiate the traffic light controller unit under test (TLUUT)
    tlc tlc_u 
    (
        .clk(clk), 
        .clk_en(clk_en), 
        .rst(rst), 
        .timer_en(timer_en),
        .timer_load(timer_load), 
        .timer_init(timer_init), 
        .timer_out(timer_out),
        .car_ns(car_ns), 
        .car_ew(car_ew), 
        .ped(ped), 
        .light_ns(light_ns),
        .light_ew(light_ew), 
        .light_ped(light_ped)
    );

    // Generate the clock signal
    initial forever #1 clk = ~clk;  // Clock signal with a period of 2 time units

    // Initial block to drive the testbench simulation
    initial begin
        $display("RESET 1");  // Display a message indicating the start of the first reset sequence
        
        // Set up initial conditions
        clk = 0;
        rst = 1;
        car_ns = 0;
        car_ew = 0;
        ped = 0;
        
        // ------- STATE 0: IDLE -------
        // Pulse reset signal
        #(2);
        rst = 0;
        #(2);
        // Note: This testbench assumes an immediate transition from idle to pedestrian state. 
        // If your IDLE state lasts longer, adjust the delay accordingly.

        // ------- STATE 1: s_ped_ew -------
        #(2 * SECOND);
        #(2);
        
        // Check the state condition
        if (!(light_ns == `LIGHT_RED && light_ew == `LIGHT_RED && light_ped == `PED_BOTH)) begin
            $display("ERROR: STATE 1: s_ped_ew, %d, %d, %d", light_ns, light_ew, light_ped);
        end

        // Set up for the next state: s_ped_ew_ns
        car_ns = 0; 
        car_ew = 0;
        ped = 0; 
                
        #(15 * SECOND); 
        
        // ------- STATE 2: s_ped_ew_ns -------
        #(2 * SECOND);
        #(2);
        
        // Check the state condition
        if (!(light_ns == `LIGHT_GREEN && light_ew == `LIGHT_RED && light_ped == `PED_NS)) begin
            $display("ERROR: STATE 2: s_ped_ew_ns, %d, %d, %d", light_ns, light_ew, light_ped);
        end

        // Set up for the next state: s_ped_ew_ns_yellow
        car_ns = 0; 
        car_ew = 0;
        ped = 1; 
        
        #(10 * SECOND);

        // ------- STATE 3: s_ped_ew_ns_yellow -------
        #(2 * SECOND);
        #(2);

        // Check the state condition
        if (!(light_ns == `LIGHT_YELLOW && light_ew == `LIGHT_RED && light_ped == `PED_NS)) begin
            $display("ERROR: STATE 3: s_ped_ew_ns_yellow, %d, %d, %d", light_ns, light_ew, light_ped);
        end
        
        // Set up for the next state: s_ped_ns        
        // Hint: No change to inputs from the previous state


        #(5 * SECOND);
        
        // ------- STATE 4: s_ped_ns -------
        #(2 * SECOND);

        // Check the state condition
        if (!(light_ns == `LIGHT_RED && light_ew == `LIGHT_RED && light_ped == `PED_BOTH)) begin
            $display("ERROR: STATE 4: s_ped_ns, %d, %d, %d", light_ns, light_ew, light_ped);
        end
        
        // Set up for the next state: s_ped_ns_ew
        car_ns = 0; 
        car_ew = 0;
        ped = 1; 
                
        #(15 * SECOND); 
        
        // ------- STATE 5: s_ped_ns_ew -------
        #(2 * SECOND);
        
        
        // Check the state condition
        if (!(light_ns == `LIGHT_RED && light_ew == `LIGHT_GREEN && light_ped == `PED_EW)) begin
            $display("ERROR: STATE 5: s_ped_ns_ew, %d, %d, %d", light_ns, light_ew, light_ped);
        end
        
        // Set up for the next state: s_ped_ns_ew_yellow        
        car_ns = 0; 
        car_ew = 0;
        ped = 0; 
        
        #(10 * SECOND); 

        // ------- STATE 6: s_ped_ns_ew_yellow -------
        #(2 * SECOND);

        // Check the state condition
        if (!(light_ns == `LIGHT_RED && light_ew == `LIGHT_YELLOW && light_ped == `PED_EW)) begin
            $display("ERROR: STATE 6: s_ped_ns_ew_yellow, %d, %d, %d", light_ns, light_ew, light_ped);
        end
        
        // Set up for the next state: s_ped_ew_ns        
        // Hint: No change to inputs from the previous state
        
        
        #(5 * SECOND);
        
        // ------- STATE 7: s_ped_ew_ns -------
        #(2 * SECOND);
        
        // Check the state condition
        if (!(light_ns == `LIGHT_GREEN && light_ew == `LIGHT_RED && light_ped == `PED_NS)) begin
            $display("ERROR: STATE 7: s_ped_ew_ns, %d, %d, %d", light_ns, light_ew, light_ped);
        end
        
        // Set up for the next state: s_ped_ew_ns_yellow    
        car_ns = 0; 
        car_ew = 0;
        ped = 0; 
        
        #(10 * SECOND); 

        // ------- STATE 8: s_ped_ew_ns_yellow -------
        #(2 * SECOND);
        
        // Check the state condition
        if (!(light_ns == `LIGHT_YELLOW && light_ew == `LIGHT_RED && light_ped == `PED_NS)) begin
            $display("ERROR: STATE 8: s_ped_ew_ns_yellow, %d, %d, %d", light_ns, light_ew, light_ped);
        end
        
        // Set up for the next state: s_ped_ns_ew    
        // Hint: No change to inputs from the previous state
        
        #(5 * SECOND);
        
        // Continue with additional states in a similar pattern...

        $display("End of simulation.");  // Indicate the end of the simulation
        $stop;  // End the simulation
    end
endmodule
