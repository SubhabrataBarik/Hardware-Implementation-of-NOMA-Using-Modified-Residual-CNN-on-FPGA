module conv2d_64_0(
    input [1:0] matrix [0:199],    // 2x200 matrix, 200 entries, 2 bits per entry
    input [1:0] filter [0:7],      // 2x8 filter
    output reg [3:0] result [0:193] // Output, convolution result, 4 bits per entry
);
    integer i, j;
    reg [3:0] sum;  // Temporary sum for convolution

    always @* begin
        // Perform the convolution operation
        for (i = 0; i < 194; i = i + 1) begin  // Convolution slides over 200 elements, but result size is 194
            sum = 0;  // Reset sum for each convolution result
            for (j = 0; j < 8; j = j + 1) begin
                sum = sum + (matrix[i + j][1:0] * filter[j][1:0]); // Multiply and accumulate
            end
            result[i] = sum;  // Store result for this position
        end
    end

endmodule

