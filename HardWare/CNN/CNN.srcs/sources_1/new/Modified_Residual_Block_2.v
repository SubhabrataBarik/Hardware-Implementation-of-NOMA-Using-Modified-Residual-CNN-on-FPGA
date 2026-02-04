`timescale 1ns / 1ps


module Modified_Residual_Block_2 #(
    parameter RESULT_ROWS = 1,
    parameter RESULT_COLS_16 = 195,
    parameter SUB_FILTERS_MRB_M2 = 16,
    parameter SUB_FILTERS_MRB_S2 = 16,
    parameter FILTER_COLS_MRB_M2 = 8,
    parameter FILTER_COLS_MRB_S2 = 1,
    parameter FILTER_ROWS_MRB_M2 = 1,
    parameter FILTER_ROWS_MRB_S2 = 1,
    parameter RESULT_COLS_MRB_M2 = 195,
    parameter RESULT_ROWS_MRB_M2 = 1,
    parameter RESULT_COLS_MRB_S2 = 195,
    parameter RESULT_ROWS_MRB_S2 = 1,
    parameter RESULT_SIZE_16 = RESULT_ROWS * RESULT_COLS_16 * 16,
    parameter FILTER_SIZE_MRB_M2 = FILTER_ROWS_MRB_M2 * FILTER_COLS_MRB_M2 * SUB_FILTERS_MRB_M2 * 16,
    parameter FILTER_SIZE_MRB_S2 = FILTER_ROWS_MRB_S2 * FILTER_COLS_MRB_S2 * SUB_FILTERS_MRB_S2 * 16,
    parameter RESULT_SIZE_MRB_M2 = RESULT_ROWS_MRB_M2 * RESULT_COLS_MRB_M2 * 16,
    parameter RESULT_SIZE_MRB_S2 = RESULT_ROWS_MRB_S2 * RESULT_COLS_MRB_S2 * 16
    )(
    input signed [(RESULT_SIZE_16 + 7*16)*32 -1:0] result_memory_16_M,
    input signed [(RESULT_SIZE_16 + 0*16)*32 -1:0] result_memory_16_S,
    input signed [FILTER_SIZE_MRB_M2-1:0] filter_MRB_M2,
    input signed [FILTER_SIZE_MRB_S2-1:0] filter_MRB_S2,
    input signed [15:0] bias_MRB_M2,
    input signed [15:0] bias_MRB_S2,
    output signed [RESULT_SIZE_MRB_M2-1:0] result_MRB_M2,
    output signed [RESULT_SIZE_MRB_S2-1:0] result_MRB_S2,
    input clk
    );
    
    MRB_Top_2 MRB_Top_2 (
        .matrix(result_memory_16_M),
        .filter(filter_MRB_M2),
        .bias_MRB_M2(bias_MRB_M2),
        .result(result_MRB_M2),
        .clk(clk)
    );
    
    MRB_Buttom_2 MRB_Buttom_2 (
        .matrix(result_memory_16_S),
        .filter(filter_MRB_S2),
        .bias_MRB_S2(bias_MRB_S2),
        .result(result_MRB_S2),
        .clk(clk)
    );
    
    
endmodule