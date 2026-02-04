`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2024 16:36:51
// Design Name: 
// Module Name: CNN
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module CNN(
    input [15:0] matrix [0:399],    // 2x200 matrix, 400 entries, 16 bits per entry 
    input [15:0] filter [0:15],      // 2x8 filter
    input clk,
    output reg [5:0] result [0:385] // 386 output, convolution result, 16 bits per entry

    );
    
    integer i, j; // Loop variables for matrix and filter
    reg [31:0] product; // Temporary variable for storing product of matrix and filter elements

    always @(posedge clk) begin
        // Iterate through the matrix and filter to perform convolution
        for(i = 0; i < 193; i = i + 1) begin // We need 386 outputs (2x200 - 2x8 + 1)
            result[i] = 0; // Initialize result at index i
            result[i+193] = 0;

            // Perform the convolution at each step by iterating through the filter
            for(j = 0; j < 8; j = j + 1) begin
//                if((i + j) < 400) begin  // Ensure we don't exceed the matrix bounds
                    product = matrix[i + j] * filter[j]; // Multiply corresponding matrix and filter values
                    result[i] = result[i] + product[15:0];  // Accumulate the result (6 bits per output)
//                end
            end
            
            for(j = 0; j < 8; j = j + 1) begin
//                if((i + j) < 400) begin  // Ensure we don't exceed the matrix bounds
                    product = matrix[i + j + 200] * filter[j + 8]; // Multiply corresponding matrix and filter values
                    result[i] = result[i] + product[15:0];  // Accumulate the result (6 bits per output)
//                end
            end
            result[i+193] = result[i+193] + result[i];
        end
    end
    
endmodule
