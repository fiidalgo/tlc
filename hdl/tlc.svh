// Define traffic light controller states
`define IDLE 4'b0000            // Idle state: No action, waiting for an event
`define SAMPLE_STATE1 4'b0001    // Sample state 1: Represents a specific state in the FSM
`define SAMPLE_STATE2 4'b0010    // Sample state 2: Represents another state in the FSM

// Define light color macros for the traffic lights
`define LIGHT_RED 3'b001         // Red light
`define LIGHT_YELLOW 3'b010      // Yellow light
`define LIGHT_GREEN 3'b100       // Green light

// Define pedestrian light states
`define PED_NS 2'b10             // Pedestrian lights active for North-South direction
`define PED_EW 2'b01             // Pedestrian lights active for East-West direction
`define PED_BOTH 2'b11           // Pedestrian lights active for both directions
`define PED_NEITHER 2'b00        // Pedestrian lights inactive (no pedestrian crossing allowed)
