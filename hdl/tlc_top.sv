module tlc_top
    (
        input logic [7:0] sw,        // Input switches used to simulate car presence and pedestrian request
        input logic [4:0] btn,       // Input buttons for controlling the system
        input logic reset_n, clk,    // Reset signal (active low) and clock input
        output logic [7:0] led,      // LED output to display traffic light status
        output logic [7:0] sseg,     // 7-segment display output
        output logic [7:0] an        // Anode control for the 7-segment display
    );

    // Button signals
    logic btn_center, btn_down;
    assign btn_center = btn[4];  // Center button for manual control or other functions
    assign btn_down = btn[2];    // Down button used as a reset for the timer

    // Internal signals for traffic light controller and timer
    logic clk_1hz, car_ns, car_ew, ped, rst;     // Clock, car presence, pedestrian request, and reset signals
    logic [2:0] light_ew, light_ns;              // Traffic light signals for East-West and North-South directions
    logic [1:0] light_ped;                       // Pedestrian light signals

    logic en, load, timer_rst;                   // Timer control signals
    logic [3:0] init, out;                       // Timer initialization and output signals
    logic [7:0] out_sseg;                        // Output for the 7-segment display

    // Reset signal logic (active low)
    assign rst = !reset_n;  // Invert reset_n to create an active high reset signal

    // Timer reset is controlled by the down button
    assign timer_rst = btn_down;

    // Clock divider to generate a 1Hz clock from the input clock
    clk_divider #(.div_amt(100000000)) div_1hz (.clk_in(clk), .rst(rst), .clk_out(clk_1hz));

    // Timer module instantiation
    timer timer_u (.clk(clk), .clk_en(clk_1hz), .rst(timer_rst), .en(en),
                   .load(load), .init(init), .out(out));

    // Traffic light controller instantiation
    // Uncomment for part 2 of the project
     tlc tlc_u (.clk(clk), .clk_en(clk_1hz), .rst(timer_rst), .timer_en(en),
                .timer_load(load), .timer_init(init), .timer_out(out),
                .car_ns(car_ns), .car_ew(car_ew), .ped(ped), .light_ns(light_ns),
                .light_ew(light_ew), .light_ped(light_ped));

    // Part 1: Basic Timer I/O Control
    // Uncomment these lines for part 1, where the focus is on basic timer functionality
//    assign led[7:4] = 3'b0;  // Unused LEDs
//    assign led[3:0] = out;   // Display the timer output on LEDs
//    assign init = sw[3:0];   // Initialize the timer with the lower 4 bits of switches
//    assign load = btn_center; // Load the timer when the center button is pressed
//    assign en = 1'b1;        // Enable the timer

    // Part 2: Traffic Light Controller I/O Control
    // Uncomment these lines for part 2, where the focus is on the traffic light controller
     assign car_ns = |sw[7:5];  // Detect cars in the North-South direction based on switches
     assign car_ew = |sw[2:0];  // Detect cars in the East-West direction based on switches
     assign ped = |sw[4:3];     // Detect pedestrian request based on switches
     assign led[7:5] = light_ns; // Display the NS traffic light status on LEDs
     assign led[4:3] = light_ped; // Display the pedestrian light status on LEDs
     assign led[2:0] = light_ew; // Display the EW traffic light status on LEDs

    // Convert the timer output to a format suitable for the 7-segment display
    hex_to_sseg sseg_unit_0
      (.hex(out), .dp(1'b0), .sseg(out_sseg));

    // Assign the 7-segment display outputs
    assign sseg = out_sseg;
    assign an = 8'hFE;  // Enable only the first digit of the 7-segment display

endmodule
