`include "tlc.svh"  // Include the header file for traffic light controller constants and definitions

module tlc
    (
        input logic clk, clk_en,                 // Clock and clock enable signals
        input logic rst,                         // Reset signal
        input logic car_ns, car_ew, ped,         // Input signals for car detection in NS and EW directions, and pedestrian request
        input logic [3:0] timer_out,             // Timer output signal
        output logic [3:0] timer_init,           // Timer initialization value
        output logic [2:0] light_ns, light_ew,   // Output signals for North-South and East-West traffic lights
        output logic [1:0] light_ped,            // Output signal for pedestrian lights
        output logic timer_load, timer_en        // Timer control signals
    );

    // State definitions for the traffic light controller's finite state machine (FSM)
    typedef enum {s_idle, s_ped_ns, s_ped_ew, s_ped_ns_t, s_ped_ew_t,
                  s_ped_ns_ns, s_ped_ns_ew,
                  s_ped_ew_ns, s_ped_ew_ew,
                  s_ped_ns_ns_yellow, s_ped_ns_ew_yellow,
                  s_ped_ew_ns_yellow, s_ped_ew_ew_yellow,
                  s_ped_ns_ns_t, s_ped_ns_ew_t,
                  s_ped_ew_ns_t, s_ped_ew_ew_t,
                  s_ped_ns_ns_yellow_t, s_ped_ns_ew_yellow_t,
                  s_ped_ew_ns_yellow_t, s_ped_ew_ew_yellow_t} state_t;
    state_t state, next_state;  // Current and next state variables

    // Synchronous logic: Update the state on the rising edge of the clock or reset signal
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= s_idle;  // Set the initial state to idle on reset
        end
        else if (clk_en) begin
            state <= next_state;  // Update the state to the next state on the clock edge
        end
    end

    // Combinational logic: Determine the next state and control signals based on the current state
    always_comb begin
        // Default output values to avoid latches
        light_ns = `LIGHT_RED;
        light_ew = `LIGHT_RED;
        light_ped = `PED_NEITHER;
        timer_en = 0;
        timer_load = 0;
        timer_init = 4'b0000;

        unique case (state)
            s_idle: begin
                // Idle state: All lights are red, no pedestrian crossing allowed
                light_ns = `LIGHT_RED;
                light_ew = `LIGHT_RED;
                light_ped = `PED_NEITHER;

                next_state = s_ped_ew_t;  // Transition to pedestrian crossing state for EW direction
            end

            s_ped_ns_t: begin
                // Timer load state for NS pedestrian crossing
                timer_en = 0;
                timer_load = 1;  // Load the timer with a value
                timer_init = 4'b1111;  // Initialize the timer to a specific value
                
                next_state = s_ped_ns;  // Move to NS pedestrian crossing state
            end

            s_ped_ns: begin
                // NS pedestrian crossing state
                light_ns = `LIGHT_RED;
                light_ew = `LIGHT_RED;
                light_ped = `PED_BOTH;  // Allow pedestrian crossing in both directions
                timer_en = 1;  // Enable the timer
                timer_load = 0;
                
                // Determine next state based on timer and car presence
                if (timer_out == 4'b0) begin
                    if (car_ns && !car_ew) begin
                        next_state = s_ped_ns_ns_t;
                    end
                    else next_state = s_ped_ns_ew_t;
                end
                else next_state = s_ped_ns;
            end

            s_ped_ew_t: begin
                // Timer load state for EW pedestrian crossing
                timer_en = 0;
                timer_load = 1;  // Load the timer with a value
                timer_init = 4'b1111;  // Initialize the timer to a specific value
                
                next_state = s_ped_ew;  // Move to EW pedestrian crossing state
            end

            s_ped_ew: begin
                // EW pedestrian crossing state
                light_ns = `LIGHT_RED;
                light_ew = `LIGHT_RED;
                light_ped = `PED_BOTH;  // Allow pedestrian crossing in both directions
                timer_en = 1;  // Enable the timer
                timer_load = 0;
                
                // Determine next state based on timer and car presence
                if (timer_out == 4'b0) begin
                    if (!car_ns && car_ew) begin
                        next_state = s_ped_ew_ew_t;
                    end
                    else next_state = s_ped_ew_ns_t;
                end
                else next_state = s_ped_ew;
            end

            // Additional states for handling traffic light transitions, timing, and pedestrian requests
            // States s_ped_ns_ns_t, s_ped_ns_ns, s_ped_ns_ns_yellow_t, s_ped_ns_ns_yellow, s_ped_ns_ew_t, s_ped_ns_ew,
            // s_ped_ns_ew_yellow_t, s_ped_ns_ew_yellow, s_ped_ew_ns_t, s_ped_ew_ns, s_ped_ew_ns_yellow_t, s_ped_ew_ns_yellow,
            // s_ped_ew_ew_t, s_ped_ew_ew, s_ped_ew_ew_yellow_t, s_ped_ew_ew_yellow follow a similar structure.

            // Example of a green light for NS direction and yellow light transition for EW direction
            s_ped_ns_ns: begin
                light_ns = `LIGHT_GREEN;
                light_ew = `LIGHT_RED;
                light_ped = `PED_NS;
                timer_en = 1;
                timer_load = 0;

                if (timer_out == 4'b0) next_state = s_ped_ns_ns_yellow_t;
                else next_state = s_ped_ns_ns;
            end

            s_ped_ns_ns_yellow_t: begin
                timer_en = 0;
                timer_load = 1;
                timer_init = 4'b0101;
                
                next_state = s_ped_ns_ns_yellow;
            end

            s_ped_ns_ns_yellow: begin
                light_ns = `LIGHT_YELLOW;
                light_ew = `LIGHT_RED;
                light_ped = `PED_NS;
                timer_en = 1;
                timer_load = 0;
                
                if (timer_out == 4'b0) begin
                    if (ped == 1) next_state = s_ped_ns_t;
                    else next_state = s_ped_ns_ew_t;
                end
                else next_state = s_ped_ns_ns_yellow;
            end

            // Other states continue in this pattern...

        endcase
    end
endmodule
