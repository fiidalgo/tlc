module hex_to_sseg
    (
        input  logic [3:0] hex,    // 4-bit hexadecimal input
        input  logic dp,           // Decimal point control
        output logic [7:0] sseg    // 7-segment display output (active low)
    );

    // Convert the 4-bit hex value to the corresponding 7-segment display pattern
    always_comb begin
        case (hex)
            4'h0: sseg[6:0] = 7'b1000000; // Display '0'
            4'h1: sseg[6:0] = 7'b1111001; // Display '1'
            4'h2: sseg[6:0] = 7'b0100100; // Display '2'
            4'h3: sseg[6:0] = 7'b0110000; // Display '3'
            4'h4: sseg[6:0] = 7'b0011001; // Display '4'
            4'h5: sseg[6:0] = 7'b0010010; // Display '5'
            4'h6: sseg[6:0] = 7'b0000010; // Display '6'
            4'h7: sseg[6:0] = 7'b1111000; // Display '7'
            4'h8: sseg[6:0] = 7'b0000000; // Display '8'
            4'h9: sseg[6:0] = 7'b0010000; // Display '9'
            4'ha: sseg[6:0] = 7'b0001000; // Display 'A'
            4'hb: sseg[6:0] = 7'b0000011; // Display 'b'
            4'hc: sseg[6:0] = 7'b1000110; // Display 'C'
            4'hd: sseg[6:0] = 7'b0100001; // Display 'd'
            4'he: sseg[6:0] = 7'b0000110; // Display 'E'
            default: sseg[6:0] = 7'b0001110; // Display 'F'
        endcase
        // Assign the decimal point value
        sseg[7] = dp;
    end
endmodule         
