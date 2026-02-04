
module top_cnn #(
    // Parameters
    parameter MATRIX_ROWS = 2,
    parameter MATRIX_COLS = 207,
    parameter MATRIX_COLS_32 = 203,

    parameter FILTER_ROWS = 2,
    parameter FILTER_COLS = 8,

    parameter FILTER_COLS_32 = 4,
    parameter SUB_FILTERS_32 = 64,

    parameter SUB_FILTERS_MRB_M1 = 32,
    parameter SUB_FILTERS_MRB_S1 = 32,
    parameter FILTER_COLS_MRB_M1 = 8,
    parameter FILTER_COLS_MRB_S1 = 1,
    parameter FILTER_ROWS_MRB_M1 = 1,
    parameter FILTER_ROWS_MRB_S1 = 1,

    parameter INPUT_ROWS_AVG1 = 1,
    parameter INPUT_COLS_AVG1 = 200,
    parameter SUB_INPUT_AVG1 = 32,

    parameter FILTER_ROWS_16 = 1,
    parameter FILTER_COLS_16 = 3,
    parameter SUB_FILTERS_16 = 32,

    parameter SUB_FILTERS_MRB_M2 = 16,
    parameter SUB_FILTERS_MRB_S2 = 16,
    parameter FILTER_COLS_MRB_M2 = 8,
    parameter FILTER_COLS_MRB_S2 = 1,
    parameter FILTER_ROWS_MRB_M2 = 1,
    parameter FILTER_ROWS_MRB_S2 = 1,

    parameter INPUT_ROWS_AVG2 = 1,
    parameter INPUT_COLS_AVG2 = 198,
    parameter SUB_INPUT_AVG2 = 32,

    parameter FILTER_ROWS_8 = 1,
    parameter FILTER_COLS_8 = 3,
    parameter SUB_FILTERS_8 = 32,

    // RESULT
    parameter RESULT_ROWS = 1,
    parameter RESULT_COLS_64 = 200,
    parameter RESULT_COLS_32 = 200,
    parameter RESULT_COLS_MRB_M1 = 200,
    parameter RESULT_ROWS_MRB_M1 = 1,
    parameter RESULT_COLS_MRB_S1 = 200,
    parameter RESULT_ROWS_MRB_S1 = 1,
    parameter RESULT_COLS_AVG1 = 198,
    parameter RESULT_ROWS_AVG1 = 1,
    parameter RESULT_COLS_16 = 198,
    parameter RESULT_COLS_MRB_M2 = 198,
    parameter RESULT_ROWS_MRB_M2 = 1,
    parameter RESULT_COLS_MRB_S2 = 198,
    parameter RESULT_ROWS_MRB_S2 = 1,
    parameter RESULT_COLS_AVG2 = 191,
    parameter RESULT_ROWS_AVG2 = 1,
    parameter RESULT_COLS_8 = 191,

    // Derived parameters
    parameter MATRIX_SIZE = MATRIX_ROWS * MATRIX_COLS * 16,  // 6400 bits
    parameter FILTER_SIZE = FILTER_ROWS * FILTER_COLS * 16,  // 256 bits
    parameter FILTER_SIZE_32 = FILTER_ROWS * FILTER_COLS_32 * SUB_FILTERS_32 * 16,  // 256 bits and 64 I/p
    parameter FILTER_SIZE_MRB_M1 = FILTER_ROWS_MRB_M1 * FILTER_COLS_MRB_M1 * SUB_FILTERS_MRB_M1 * 16,  // 4096 bits and 32 I/p
    parameter FILTER_SIZE_MRB_S1 = FILTER_ROWS_MRB_S1 * FILTER_COLS_MRB_S1 * SUB_FILTERS_MRB_S1 * 16,  // 512 bits and 64 I/p
    parameter INPUT_SIZE_AVG1 = INPUT_ROWS_AVG1 * INPUT_COLS_AVG1 * 16,  // 4096 bits and 32 I/p
    parameter FILTER_SIZE_16 = FILTER_ROWS_16 * FILTER_COLS_16 * SUB_FILTERS_16 * 16,  // 256 bits and 32 I/p
    parameter FILTER_SIZE_MRB_M2 = FILTER_ROWS_MRB_M2 * FILTER_COLS_MRB_M2 * SUB_FILTERS_MRB_M2 * 16,  // 4096 bits and 32 I/p
    parameter FILTER_SIZE_MRB_S2 = FILTER_ROWS_MRB_S2 * FILTER_COLS_MRB_S2 * SUB_FILTERS_MRB_S2 * 16,  // 512 bits and 64 I/p
    parameter INPUT_SIZE_AVG2 = INPUT_ROWS_AVG2 * INPUT_COLS_AVG2 * 16,  // 4096 bits and 32 I/p
    parameter FILTER_SIZE_8 = FILTER_ROWS_8 * FILTER_COLS_8 * SUB_FILTERS_8 * 16,  // 256 bits and 32 I/p

    parameter RESULT_SIZE_64 = RESULT_ROWS * RESULT_COLS_64 * 16,  // 6176 bits
    parameter RESULT_SIZE_32 = RESULT_ROWS * RESULT_COLS_32 * 16,  // 6080 bits
    parameter RESULT_SIZE_MRB_M1 = RESULT_ROWS_MRB_M1 * RESULT_COLS_MRB_M1 * 16,  // 6176 bits
    parameter RESULT_SIZE_MRB_S1 = RESULT_ROWS_MRB_S1 * RESULT_COLS_MRB_S1 * 16,  // 6176 bits
    parameter RESULT_SIZE_AVG1 = RESULT_ROWS_AVG1 * RESULT_COLS_AVG1 * 16,  // 6176 bits
    parameter RESULT_SIZE_16 = RESULT_ROWS * RESULT_COLS_16 * 16,  // 6080 bits
    parameter RESULT_SIZE_MRB_M2 = RESULT_ROWS_MRB_M2 * RESULT_COLS_MRB_M2 * 16,  // 6176 bits
    parameter RESULT_SIZE_MRB_S2 = RESULT_ROWS_MRB_S2 * RESULT_COLS_MRB_S2 * 16,  // 6176 bits
    parameter RESULT_SIZE_AVG2 = RESULT_ROWS_AVG2 * RESULT_COLS_AVG2 * 16,  // 6176 bits
    parameter RESULT_SIZE_8 = RESULT_ROWS * RESULT_COLS_8 * 16  // 6080 bits

)
( 
    input clk, reset,
    input signed [MATRIX_SIZE-1:0] matrix,
    input signed [MATRIX_SIZE-1:0] matrix_2,
    input signed [FILTER_SIZE-1:0] filter,
    input signed [(RESULT_SIZE_64 + 3*16)*64*2 -1:0] result_memory,
    input signed [FILTER_SIZE_32-1:0] filter_32,
    input signed [(RESULT_SIZE_32 + 7*16)*32 -1:0] result_memory_32_M,
    input signed [(RESULT_SIZE_32 + 0*16)*32 -1:0] result_memory_32_S,
    input signed [FILTER_SIZE_MRB_M1-1:0] filter_MRB_M1,
    input signed [FILTER_SIZE_MRB_S1-1:0] filter_MRB_S1,
    input signed [INPUT_SIZE_AVG1-1:0] Input_Avg1,
    input signed [(RESULT_SIZE_AVG1 + 2*16)*32-1:0] result_memory_Avg1,
    input signed [FILTER_SIZE_16-1:0] filter_16,
    input signed [(RESULT_SIZE_16 + 7*16)*32 -1:0] result_memory_16_M,
    input signed [(RESULT_SIZE_16 + 0*16)*32 -1:0] result_memory_16_S,
    input signed [FILTER_SIZE_MRB_M2-1:0] filter_MRB_M2,
    input signed [FILTER_SIZE_MRB_S2-1:0] filter_MRB_S2,
    input signed [INPUT_SIZE_AVG2-1:0] Input_Avg2,
    input signed [(RESULT_SIZE_AVG2 + 2*16)*32-1:0] result_memory_Avg2,
    input signed [FILTER_SIZE_8-1:0] filter_8,
    input [255:0] count,

    output signed [RESULT_SIZE_64-1:0] result_64,
    output signed [RESULT_SIZE_64-1:0] result_64_2,
    output signed [RESULT_SIZE_32-1:0] result_32,
    output signed [RESULT_SIZE_MRB_M1-1:0] result_MRB_M1,
    output signed [RESULT_SIZE_MRB_S1-1:0] result_MRB_S1,
    output signed [RESULT_SIZE_AVG1-1:0] result_AVG1,
    output signed [RESULT_SIZE_16-1:0] result_16,
    output signed [RESULT_SIZE_MRB_M2-1:0] result_MRB_M2,
    output signed [RESULT_SIZE_MRB_S2-1:0] result_MRB_S2,
    output signed [RESULT_SIZE_AVG2-1:0] result_AVG2,
    output signed [RESULT_SIZE_8-1:0] result_8
);
    
    Convolution_test_1 Convolution_test_1 (
        .matrix(matrix),
        .filter(filter),
        .result(result_64),
        .reset(reset),
        .count(count),
        .clk(clk)
    );
    
    Convolution_test_1 Convolution_test_2 (
        .matrix(matrix_2),
        .filter(filter),
        .result(result_64_2),
        .reset(reset),
        .count(count),
        .clk(clk)
    );
    
    Convolution_test_32 Convolution_test_32 (
        .matrix(result_memory),
        .filter(filter_32),
        .result(result_32),
        .clk(clk)
    );
    
//    MRB_Top MRB_Top (
//        .matrix(result_memory_32_M),
//        .filter(filter_MRB_M1),
//        .result(result_MRB_M1),
//        .clk(clk)
//    );
    
//    MRB_Buttom MRB_Buttom (
//        .matrix(result_memory_32_S),
//        .filter(filter_MRB_S1),
//        .result(result_MRB_S1),
//        .clk(clk)
//    );
    
    Modified_Residual_Block Modified_Residual_Block (
        .result_memory_32_M(result_memory_32_M),
        .result_memory_32_S(result_memory_32_S),
        .filter_MRB_M1(filter_MRB_M1),
        .filter_MRB_S1(filter_MRB_S1),
        .result_MRB_M1(result_MRB_M1),
        .result_MRB_S1(result_MRB_S1),
        .clk(clk)
    );
    
    Avg_Pool_1 Avg_Pool_1 (
        .matrix(Input_Avg1),
        .result(result_AVG1),
        .clk(clk)
    );
    
    Convolution_test_16 Convolution_test_16 (
        .matrix(result_memory_Avg1),
        .filter(filter_16),
        .result(result_16),
        .clk(clk)
    );
    
    
//    MRB_Top_2 MRB_Top_2 (
//        .matrix(result_memory_16_M),
//        .filter(filter_MRB_M2),
//        .result(result_MRB_M2),
//        .clk(clk)
//    );
    
//    MRB_Buttom_2 MRB_Buttom_2 (
//        .matrix(result_memory_16_S),
//        .filter(filter_MRB_S2),
//        .result(result_MRB_S2),
//        .clk(clk)
//    );
    
    Modified_Residual_Block_2 Modified_Residual_Block_2 (
        .result_memory_16_M(result_memory_16_M),
        .result_memory_16_S(result_memory_16_S),
        .filter_MRB_M2(filter_MRB_M2),
        .filter_MRB_S2(filter_MRB_S2),
        .result_MRB_M2(result_MRB_M2),
        .result_MRB_S2(result_MRB_S2),
        .clk(clk)
    );
    
    Avg_Pool_2 Avg_Pool_2 (
        .matrix(Input_Avg2),
        .result(result_AVG2),
        .clk(clk)
    );
    
    Convolution_test_8 Convolution_test_8 (
        .matrix(result_memory_Avg2),
        .filter(filter_8),
        .result(result_8),
        .clk(clk)
    );
    
    

endmodule