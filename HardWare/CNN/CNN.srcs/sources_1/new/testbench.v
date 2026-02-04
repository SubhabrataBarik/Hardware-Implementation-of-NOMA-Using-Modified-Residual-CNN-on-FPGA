module testbench;
    reg [1:0] matrix [0:199];  // 2x200 matrix
    reg [1:0] filter [0:7];    // 2x8 filter
    wire [3:0] result [0:193]; // Convolution result

    // Instantiate the convolution module
    conv2d_64_0 uut (
        .matrix(matrix),
        .filter(filter),
        .result(result)
    );

    initial begin
        // Load matrix and filter data from .mif files
        $readmemh("matrix_2x200.mif", matrix);  // Load matrix from mif file
        $readmemh("f_64_0.mif", filter);        // Load filter from mif file

        // Apply stimulus (for testing)
        #10;
        // Check result or observe waveform
    end
endmodule
