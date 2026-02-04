`timescale 1ns / 1ps

module MRB_Buttom(
    input signed [197*16*32-1:0] matrix,     // Flattened matrix, 32 (1*190)_Filter O/P entries of 16 bits each
    input signed [1*1*16*32-1:0] filter,      // Flattened filter, 32(1x1)*16=512 entries of 16 bits each
    input signed [15:0] bias_MRB_S1,  // Single bias value for all outputs
    input clk,
    output reg signed [197*16-1:0] result // 200*16=3040 output values, 16 bits per entry
    );
    
    // Define 16-bit signed limits
    parameter signed [15:0] MAX_16BIT = 16'sd32767;
    parameter signed [15:0] MIN_16BIT = -16'sd32768;
    
    parameter MATRIX_ROWS_MRB_S1 = 1;
    parameter MATRIX_COLS_MRB_S1 = 197;
    
    parameter SUB_FILTERS_MRB_S1 = 32;
    parameter FILTER_ROWS_MRB_S1 = 1;
    parameter FILTER_COLS_MRB_S1 = 1;
    parameter SUB_FILTER_ELEMENT = FILTER_ROWS_MRB_S1*FILTER_COLS_MRB_S1;
    
    parameter RESULT_ROWS_MRB_S1 = 1;
    parameter RESULT_COLS_MRB_S1 = MATRIX_COLS_MRB_S1 - FILTER_COLS_MRB_S1 + 1;    //190
    parameter ELEMENTS = FILTER_ROWS_MRB_S1 * FILTER_COLS_MRB_S1;
    
    
    integer i, j, k;                 // Loop variables
    reg signed [31:0] product;    // Temporary variable for storing signed product
    reg signed [31:0] partial_sum; // Accumulated result, 16 bits wide
    reg signed [31:0] biased_sum;


    always @(posedge clk) begin
    
//        for (k = 0; k < SUB_FILTERS_MRB_S1; k = k + 1) begin // Number of subfilters
//            $display("MATRIX[%0d]: %d %d",k, k*3200 , $signed(matrix[ 3200*k + : 16]));
//        end
        
//        for (k = 0; k < FILTER_ROWS_MRB_S1*FILTER_COLS_MRB_S1*SUB_FILTERS_MRB_S1; k = k + 1) begin // Number of subfilters
//            $display("Sub_FIlter[%0d]: %d %d",k*16, k*16+16 , $signed(filter[k*16 + : 16]));
//        end
        
        
        for (i = 0; i < RESULT_COLS_MRB_S1; i = i + 1) begin  // Limit to 190 iterations
            partial_sum = 16'sh0000; // Reset partial sum to 0 in hexadecimal (signed)
//            $display("\n\nResult Number :                                                                                                   ", i+1);
            
            
            for (k = 0; k < SUB_FILTER_ELEMENT * SUB_FILTERS_MRB_S1; k = k + ELEMENTS) begin    //Sub up Filters 8*64
//                $display("Filter Number :  ", (k/8)+1); // INUSE
                // Convolution for the first half of the filter
                for (j = 0; j < FILTER_COLS_MRB_S1; j = j + 1) begin    //first 4 element
                
                    if (((i + j + 1) * 16 - 1) < MATRIX_COLS_MRB_S1*16) begin //splitting first half
                        // Perform multiplication in hexadecimal

                        product = $signed(matrix[((k/ELEMENTS)*(MATRIX_ROWS_MRB_S1 * MATRIX_COLS_MRB_S1) + i + j + 1) * 16 - 1 -: 16]) * $signed(filter[(k + j + 1) * 16 - 1 -: 16]);    //original
                        partial_sum = partial_sum + product; // Accumulate the lower 16 bits of the product
                    
//                         Display debugging information
//                        $display("First Half - Matrix[%0d]: %d, Filter[%0d]: %d, Product: %d, Partial Sum: %d",
//                            ((k/ELEMENTS)%(MATRIX_ROWS_MRB_S1 * MATRIX_COLS_MRB_S1) + i + 1),
//                            $signed(matrix[((k/ELEMENTS)*(MATRIX_ROWS_MRB_S1 * MATRIX_COLS_MRB_S1) + i + j + 1) * 16 - 1 -: 16]),
//                            (k + j + 1),
//                            $signed(filter[(k + j + 1) * 16 - 1 -: 16]),
//                            $signed(product),
//                            $signed(partial_sum));
                            
                    end // IF    
                end //first 4 element
            end //sub up filters       
         
//            // Store the result in the appropriate slice (in hexadecimal format)
//            result[(i + 1) * 16 - 1 -: 16] = partial_sum;


            biased_sum = partial_sum + bias_MRB_S1;  // Use the same bias for all outputs
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

//            // Display the final result for this index
//            $display("Result[%0d]: %d", i, $signed(result[(i + 1) * 16 - 1 -: 16]));
        end
    end
endmodule
