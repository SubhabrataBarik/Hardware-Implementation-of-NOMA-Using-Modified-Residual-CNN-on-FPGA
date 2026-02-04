// MAIN CODE

//`timescale 1ns / 1ps

//module Convolution_test_1(
//    input signed [2*207*16 -1:0] matrix,     // Flattened matrix, 200*2=400 entries of 16 bits each
//    input signed [2*8*16 -1:0] filter,      // Flattened filter, 2x8=16 entries of 16 bits each
//    input reset,
//    output reg [255:0] count,
//    input clk,
//    output reg signed [200*16 -1:0] result // 193*1*16=386/2*16=3088 output values, 16 bits per entry*
   
//);

//    // Define 16-bit signed limits
//    parameter signed [15:0] MAX_16BIT = 16'sd32767;
//    parameter signed [15:0] MIN_16BIT = -16'sd32768;
    
////    reg signed [6175:0] result;
//    parameter MATRIX_ROWS = 2;
//    parameter MATRIX_COLS = 207;
//    parameter FILTER_ROWS = 2;
//    parameter FILTER_COLS = 8;
//    parameter RESULT_ROWS = 2;
//    parameter RESULT_COLS = MATRIX_COLS - FILTER_COLS + 1;
    
    
//    integer i, j;                 // Loop variables
//    reg signed [31:0] product;    // Temporary variable for storing signed product
//    reg signed [31:0] partial_sum; // Accumulated result, 16 bits wide

//    always @(posedge clk) begin
//        if (reset==0)
//            count=0; 
//        else
//            count=count+1;  
            
//    end
//    always @(posedge clk) begin
    
//        for (i = 0; i < RESULT_COLS; i = i + 1) begin  // Limit to 193 iterations
////        for (i = 0; i < 5; i = i + 1) begin  // Limit to 193 iterations
//            partial_sum = 16'sh0000; // Reset partial sum to 0 in hexadecimal (signed)

//            // Convolution for the first half of the filter
//            for (j = 0; j < FILTER_COLS; j = j + 1) begin
//                if (((i + j + 1) * 16 - 1) < MATRIX_COLS*16) begin
//                    // Perform multiplication in hexadecimal
//                    product = $signed(matrix[(i + j + 1) * 16 - 1 -: 16]) * $signed(filter[(j + 1) * 16 - 1 -: 16]);
//                    partial_sum = partial_sum + product; // Accumulate the lower 16 bits of the product

//                    // Display debugging information+
////                    $display("First Half - Matrix[%0d]: %d, Filter[%0d]: %d, Product: %d, Partial Sum: %d",
////                        (i + j + 1),
////                        $signed(matrix[(i + j + 1) * 16 - 1 -: 16]),
////                        (j + 1),
////                        $signed(filter[(j + 1) * 16 - 1 -: 16]),
////                        $signed(product),
////                        $signed(partial_sum));
//                end
//            end

//            // Convolution for the second half of the filter
//            for (j = 0; j < FILTER_COLS; j = j + 1) begin
//                if (((i + j + MATRIX_COLS + 1) * 16 - 1) < 2*MATRIX_COLS*16) begin
//                    // Perform multiplication in hexadecimal
//                    product = $signed(matrix[(i + j + MATRIX_COLS + 1) * 16 - 1 -: 16]) * $signed(filter[(j + 8 + 1) * 16 - 1 -: 16]);
//                    partial_sum = partial_sum + product;

//                    // Display debugging information
////                    $display("Second Half - Matrix[%0d]: %d, Filter[%0d]: %d, Product: %d, Partial Sum: %d",
////                        (i + j + MATRIX_COLS + 1),
////                        $signed(matrix[(i + j + MATRIX_COLS + 1) * 16 - 1 -: 16]),
////                        (j + 8 + 1),
////                        $signed(filter[(j + 8 + 1) * 16 - 1 -: 16]),
////                        $signed(product),
////                        $signed(partial_sum));
//                end
//            end

//            // Store the result in the appropriate slice (in hexadecimal format)
////            result[(i + 1) * 16 - 1 -: 16] = partial_sum;


////            // Check for overflow and underflow
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

////            // Display the final result for this index
////            $display("Result[%0d]: %d", i, $signed(result[(i + 1) * 16 - 1 -: 16]));
//        end
//    end
   
//endmodule






`timescale 1ns / 1ps

module Convolution_test_1(
    input signed [2*207*16 -1:0] matrix,     // Flattened matrix, 200*2=400 entries of 16 bits each
    input signed [2*8*16 -1:0] filter,      // Flattened filter, 2x8=16 entries of 16 bits each
    input signed [15:0] bias,  // Single bias value for all outputs
    input reset,
    output reg [255:0] count,
    input clk,
    output reg signed [200*16 -1:0] result // 193*1*16=386/2*16=3088 output values, 16 bits per entry*
   
);

    // Define 16-bit signed limits
    parameter signed [15:0] MAX_16BIT = 16'sd32767;
    parameter signed [15:0] MIN_16BIT = -16'sd32768;
    
//    reg signed [6175:0] result;
    parameter MATRIX_ROWS = 2;
    parameter MATRIX_COLS = 207;
    parameter FILTER_ROWS = 2;
    parameter FILTER_COLS = 8;
    parameter RESULT_ROWS = 2;
    parameter RESULT_COLS = MATRIX_COLS - FILTER_COLS + 1;
    
    
    integer i, j;                 // Loop variables
    reg signed [31:0] product;    // Temporary variable for storing signed product
    reg signed [31:0] partial_sum; // Accumulated result, 16 bits wide
    reg signed [31:0] biased_sum;


    always @(posedge clk) begin
        if (reset==0)
            count=0; 
        else
            count=count+1;  
            
    end
    always @(posedge clk) begin
    
//        $display("BIAS[0]: %d",$signed(bias));

    
        for (i = 0; i < RESULT_COLS; i = i + 1) begin  // Limit to 193 iterations
//        for (i = 0; i < 5; i = i + 1) begin  // Limit to 193 iterations
            partial_sum = 16'sh0000; // Reset partial sum to 0 in hexadecimal (signed)

            // Convolution for the first half of the filter
            for (j = 0; j < FILTER_COLS; j = j + 1) begin
                if (((i + j + 1) * 16 - 1) < MATRIX_COLS*16) begin
                    // Perform multiplication in hexadecimal
                    product = $signed(matrix[(i + j + 1) * 16 - 1 -: 16]) * $signed(filter[(j + 1) * 16 - 1 -: 16]);
                    partial_sum = partial_sum + product; // Accumulate the lower 16 bits of the product

                    // Display debugging information+
//                    $display("First Half - Matrix[%0d]: %d, Filter[%0d]: %d, Product: %d, Partial Sum: %d",
//                        (i + j + 1),
//                        $signed(matrix[(i + j + 1) * 16 - 1 -: 16]),
//                        (j + 1),
//                        $signed(filter[(j + 1) * 16 - 1 -: 16]),
//                        $signed(product),
//                        $signed(partial_sum));
                end
            end

            // Convolution for the second half of the filter
            for (j = 0; j < FILTER_COLS; j = j + 1) begin
                if (((i + j + MATRIX_COLS + 1) * 16 - 1) < 2*MATRIX_COLS*16) begin
                    // Perform multiplication in hexadecimal
                    product = $signed(matrix[(i + j + MATRIX_COLS + 1) * 16 - 1 -: 16]) * $signed(filter[(j + 8 + 1) * 16 - 1 -: 16]);
                    partial_sum = partial_sum + product;

                    // Display debugging information
//                    $display("Second Half - Matrix[%0d]: %d, Filter[%0d]: %d, Product: %d, Partial Sum: %d",
//                        (i + j + MATRIX_COLS + 1),
//                        $signed(matrix[(i + j + MATRIX_COLS + 1) * 16 - 1 -: 16]),
//                        (j + 8 + 1),
//                        $signed(filter[(j + 8 + 1) * 16 - 1 -: 16]),
//                        $signed(product),
//                        $signed(partial_sum));
                end
            end

            // Store the result in the appropriate slice (in hexadecimal format)
//            result[(i + 1) * 16 - 1 -: 16] = partial_sum;
            
            biased_sum = partial_sum + bias;  // Use the same bias for all outputs
//            $display("biased_sum[0]: %d",$signed(biased_sum));
            // Apply saturation
            if ({biased_sum[26:24], biased_sum[23:12]} > MAX_16BIT) begin
                result[(i + 1) * 16 - 1 -: 16] = MAX_16BIT;
            end
            else if (biased_sum < 0) begin
                result[(i + 1) * 16 - 1 -: 16] = 0;
            end
            else begin
                result[(i + 1) * 16 - 1 -: 16] = {biased_sum[31], biased_sum[26:24], biased_sum[23:12]};
            end

//            // Display the final result for this index
//            $display("Result[%0d]: %d", i, $signed(result[(i + 1) * 16 - 1 -: 16]));
        end
    end
   
endmodule