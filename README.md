# Traffic Light Controller Project

## Overview
This project implements a Traffic Light Controller (TLC) using SystemVerilog. The design is implemented for an FPGA board and includes a testbench for simulation and verification. The TLC controls traffic lights and pedestrian signals at an intersection, managing different states for vehicles and pedestrians.

## Project Structure
The project consists of the following modules:

- **`clk_divider`**: A clock divider that reduces the system clock frequency to a slower clock (e.g., 1 Hz) for use in the traffic light controller.
- **`tlc`**: The main traffic light controller module, managing the states of the traffic and pedestrian signals.
- **`timer`**: A countdown timer used within the traffic light controller to manage timing for different states.
- **`hex_to_sseg`**: Converts a 4-bit hexadecimal input to a 7-segment display output, useful for displaying the timer value on an FPGA.
- **`tlc_tb`**: The testbench for simulating and verifying the functionality of the TLC.

## Files

- **`clk_divider.sv`**: Implements a clock divider.
- **`tlc.sv`**: Contains the traffic light controller logic.
- **`timer.sv`**: Implements a simple countdown timer.
- **`hex_to_sseg.sv`**: Converts hex input to a 7-segment display format.
- **`tlc_tb.sv`**: Testbench for verifying the TLC module.
- **`tlc_tb_tested_inputs.sv`**: A testbench with specific input scenarios to test the traffic light controller.

## How to Run the Simulation
To simulate the design:

1. **Setup**:
   - Ensure all `.sv` files are in the same directory.
   - Use Vivado or another SystemVerilog simulation tool to compile the modules.

2. **Running the Simulation**:
   - Open Vivado or your preferred simulation tool.
   - Add all source files to the project.
   - Set `tlc_tb.sv` or `tlc_tb_tested_inputs.sv` as the top-level module for simulation.
   - Run the simulation to observe the traffic light controller's behavior under different conditions.

3. **Analyzing the Results**:
   - The simulation output will display the state transitions of the traffic lights and pedestrian signals.
   - The testbench includes checks (`$display` statements) to validate that the TLC behaves as expected during each state transition.

## Design Notes
- **Clock Management**: The `clk_divider` module is critical for reducing the system clock frequency to a manageable rate for the TLC.
- **State Transitions**: The TLC module uses a finite state machine (FSM) to manage transitions between different traffic light states, ensuring safe and efficient traffic flow.
- **Simulation**: The testbench simulates various scenarios, including vehicle and pedestrian presence, to validate the design's robustness.

## Future Work
- **Extended Functionality**: Consider adding more complex traffic patterns, such as left turn signals or multiple intersections.
- **Optimization**: Explore optimizing the FSM to reduce resource usage on the FPGA.