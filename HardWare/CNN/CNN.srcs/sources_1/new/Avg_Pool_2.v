`timescale 1ns / 1ps

module Avg_Pool_2(
    input signed [195*16 -1:0] matrix,     // [MSR_M+MRB_S]*16 o/p
    input clk,
    output reg signed [188*16 -1:0] result // (200-3+1)*16=3168 output values, 16 bits per entry
    );
    
    // Define 16-bit signed limits
    parameter signed [15:0] MAX_16BIT = 16'sd32767;
    parameter signed [15:0] MIN_16BIT = -16'sd32768;
    
//    reg signed [6175:0] result;
    parameter MATRIX_ROWS_AVG2 = 1;
    parameter MATRIX_COLS_AVG2 = 195;
    parameter FILTER_ROWS_AVG2 = 1;
    parameter FILTER_COLS_AVG2 = 8;
    parameter RESULT_ROWS_AVG2 = 2;
    parameter RESULT_COLS_AVG2 = MATRIX_COLS_AVG2 - FILTER_COLS_AVG2 + 1;
    parameter ELEMENTS = FILTER_ROWS_AVG2 * FILTER_COLS_AVG2;
    
    integer i, j, k;                 // Loop variables
    reg signed [31:0] product;    // Temporary variable for storing signed product
    reg signed [31:0] partial_sum; // Accumulated result, 16 bits wide

    always @(posedge clk) begin
    
//        for (k = 0; k < 198; k = k + 1) begin // Number of subfilters
//            $display("MATRIX[%0d]: %d %d",k*16, k*16+16 , $signed(matrix[ 16*k+: 16]));
//        end


        for (i = 0; i < RESULT_COLS_AVG2; i = i + 1) begin  // Limit to 193 iterations
//        for (i = 0; i < 5; i = i + 1) begin  // Limit to 193 iterations
            partial_sum = 16'sh0000; // Reset partial sum to 0 in hexadecimal (signed)

            // Convolution for the first half of the filter
            for (j = 0; j < FILTER_COLS_AVG2; j = j + 1) begin
                if (((i + j + 1) * 16 - 1) < 198*16) begin
                    // Perform multiplication in hexadecimal
                    product = $signed(matrix[(i + j + 1) * 16 - 1 -: 16]) / ELEMENTS;
                    partial_sum = partial_sum + product; // Accumulate the lower 16 bits of the product

                    // Display debugging information
//                    $display("First Half - Matrix[%0d]: %d, Filter[%0d]: %d, Product: %d, Partial Sum: %d",
//                        (i + j + 1),
//                        $signed(matrix[(i + j + 1) * 16 - 1 -: 16]),
//                        (j + 1),
//                        $signed(8),
//                        $signed(product),
//                        $signed(partial_sum));
                end
            end


            // Store the result in the appropriate slice (in hexadecimal format)
            result[(i + 1) * 16 - 1 -: 16] = partial_sum;
            

//            // Check for overflow and underflow
//            if ({partial_sum[26:24],partial_sum[23:12]} > MAX_16BIT) begin
////                $display("Checking[%0d]: %d", i, $signed({partial_sum[31],partial_sum[26:24],partial_sum[23:12]}));
//                result[(i + 1) * 16 - 1 -: 16] = MAX_16BIT; // Saturate to max value
//            end
//            else if (partial_sum < 0) begin
//                result[(i + 1) * 16 - 1 -: 16] = 0; // Saturate to min value
//            end 
//            else begin
//                result[(i + 1) * 16 - 1 -: 16] = {partial_sum[31],partial_sum[26:24],partial_sum[23:12]}; // Store valid range
//            end
            

//            // Display the final result for this index
//            $display("Result[%0d]: %d", i, $signed(result[(i + 1) * 16 - 1 -: 16]));
        end
    end
   
endmodule
