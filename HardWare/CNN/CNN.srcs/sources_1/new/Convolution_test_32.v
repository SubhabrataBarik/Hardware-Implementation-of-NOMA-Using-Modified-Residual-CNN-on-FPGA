`timescale 1ns / 1ps
module Convolution_test_32(
    input signed [2*200*16*64-1:0] matrix,     // Flattened matrix, 193x2=386 entries of 16 bits each
    input signed [2*4*16*64 -1:0] filter,   //// Flattened filter, 2x4 entries of 16 bits each // 64 inputs = 64x2x4x16
    input signed [15:0] bias_32,  // Single bias value for all outputs
    output reg signed [197*16 -1:0] result, // 190*2=380 output values, 16 bits per entry
    input clk
);
    
    // Define 16-bit signed limits
    parameter signed [15:0] MAX_16BIT = 16'sd32767;
    parameter signed [15:0] MIN_16BIT = -16'sd32768;
    
    parameter MATRIX_ROWS = 1;
    parameter MATRIX_COLS_32 = 200;
    
    parameter SUB_FILTERS = 64;
    parameter FILTER_ROWS = 2;
    parameter FILTER_COLS_32 = 4;
    parameter SUB_FILTER_ELEMENT = FILTER_ROWS*FILTER_COLS_32;
    
    parameter RESULT_ROWS = 2;
    parameter RESULT_COLS = MATRIX_COLS_32 - FILTER_COLS_32 + 1;    //190
    
    
    integer i, j, k;                 // Loop variables
    reg signed [31:0] product;    // Temporary variable for storing signed product
    reg signed [31:0] product_2nd;    // Temporary variable for storing signed product
    reg signed [31:0] partial_sum; // Accumulated result, 16 bits wide
    reg signed [31:0] biased_sum;


    always @(posedge clk) begin
    
//        for (k = 0; k < SUB_FILTERS; k = k + 1) begin // Number of subfilters
//            $display("MATRIX[%0d]: %d %d",k*203*16, k*203*16+16 , $signed(matrix[ 203*16*k + : 16]));
//        end
        
//        for (k = 0; k < FILTER_ROWS*FILTER_COLS_32*SUB_FILTERS; k = k + 1) begin // Number of subfilters
//            $display("Sub_FIlter[%0d]: %d %d",k/8, k%8+1 , $signed(filter[ 16*k + : 16]));
//        end
        
        
        
        for (i = 0; i < RESULT_COLS; i = i + 1) begin  // Limit to 190 iterations
//        for (i = 0; i < 5; i = i + 1) begin  // Limit to 190 iterations
            partial_sum = 16'sh0000; // Reset partial sum to 0 in hexadecimal (signed)
//            $display("\n\nResult Number :                                                                                                   ", i+1);
            
            
            for (k = 0; k < SUB_FILTER_ELEMENT * SUB_FILTERS; k = k + 8) begin    //Sub up Filters 8*64
//                $display("Filter Number :  ", (k/8)+1); // INUSE
                // Convolution for the first half of the filter
                for (j = 0; j < FILTER_COLS_32; j = j + 1) begin    //first 4 element
               
                        product = $signed(matrix[((k/8)*(MATRIX_ROWS * MATRIX_COLS_32) + i + j + 1) * 16 - 1 -: 16]) * $signed(filter[(k + j + 1) * 16 - 1 -: 16]);    //original
                        product_2nd = $signed(matrix[MATRIX_COLS_32*16*64 + ((k/8)*(MATRIX_ROWS * MATRIX_COLS_32) + i + j + 1) * 16 - 1 -: 16]) * $signed(filter[(k + j + FILTER_COLS_32 + 1) * 16 - 1 -: 16]);
                        partial_sum = partial_sum + product + product_2nd; // Accumulate the lower 16 bits of the product
                    
//                         Display debugging information
//                        $display("First Half - Matrix[%0d]: %d, Filter[%0d]: %d, Product: %d, Partial Sum: %d",
//                            ((k/8)%(MATRIX_ROWS * MATRIX_COLS_32) + i + 0 + 1),
//                            $signed(matrix[((k/8)*(MATRIX_ROWS * MATRIX_COLS_32) + i + j + 1) * 16 - 1 -: 16]),
//                            (k + j + 1),
//                            $signed(filter[(k + j + 1) * 16 - 1 -: 16]),
//                            $signed(product),
//                            $signed(partial_sum));
                            
//                        $display("Second Half - Matrix[%0d]: %d, Filter[%0d]: %d, Product: %d, Partial Sum: %d",
//                            ((k/8)%(MATRIX_ROWS * MATRIX_COLS_32) + i + 0 + 1),
//                            $signed(matrix[203*16*64 + ((k/8)*(MATRIX_ROWS * MATRIX_COLS_32) + i + j + 1) * 16 - 1 -: 16]),
//                            (k + j + FILTER_COLS_32 + 1),
//                            $signed(filter[(k + j + FILTER_COLS_32 + 1) * 16 - 1 -: 16]),
//                            $signed(product_2nd),
//                            $signed(partial_sum));
                    
                    
                end //first 4 element
            end //sub up filters     


            biased_sum = partial_sum + bias_32;  // Use the same bias for all outputs
//            $display("biased_sum[0]: %d",$signed(biased_sum));

            // Check for overflow and underflow            
            if ({biased_sum[26:24], biased_sum[23:12]} > MAX_16BIT) begin
                result[(i + 1) * 16 - 1 -: 16] = MAX_16BIT;
            end
            else if (biased_sum < 0) begin
                result[(i + 1) * 16 - 1 -: 16] = 0;
            end
            else begin
                result[(i + 1) * 16 - 1 -: 16] = {biased_sum[31], biased_sum[26:24], biased_sum[23:12]};
            end

            // Display the final result for this index
//            $display("Result[%0d]: %d", i, $signed(result[(i + 1) * 16 - 1 -: 16]));
        end
    end

endmodule