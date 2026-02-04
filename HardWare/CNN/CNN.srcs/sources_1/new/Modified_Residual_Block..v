`timescale 1ns / 1ps


module Modified_Residual_Block #(
    parameter RESULT_ROWS = 1,
    parameter RESULT_COLS_32 = 197,
    parameter SUB_FILTERS_MRB_M1 = 32,
    parameter SUB_FILTERS_MRB_S1 = 32,
    parameter FILTER_COLS_MRB_M1 = 8,
    parameter FILTER_COLS_MRB_S1 = 1,
    parameter FILTER_ROWS_MRB_M1 = 1,
    parameter FILTER_ROWS_MRB_S1 = 1,
    parameter RESULT_COLS_MRB_M1 = 197,
    parameter RESULT_ROWS_MRB_M1 = 1,
    parameter RESULT_COLS_MRB_S1 = 197,
    parameter RESULT_ROWS_MRB_S1 = 1,
    parameter RESULT_SIZE_32 = RESULT_ROWS * RESULT_COLS_32 * 16,
    parameter FILTER_SIZE_MRB_M1 = FILTER_ROWS_MRB_M1 * FILTER_COLS_MRB_M1 * SUB_FILTERS_MRB_M1 * 16,
    parameter FILTER_SIZE_MRB_S1 = FILTER_ROWS_MRB_S1 * FILTER_COLS_MRB_S1 * SUB_FILTERS_MRB_S1 * 16,
    parameter RESULT_SIZE_MRB_M1 = RESULT_ROWS_MRB_M1 * RESULT_COLS_MRB_M1 * 16,
    parameter RESULT_SIZE_MRB_S1 = RESULT_ROWS_MRB_S1 * RESULT_COLS_MRB_S1 * 16
    )(
    input signed [(RESULT_SIZE_32 + 7*16)*32 -1:0] result_memory_32_M,
    input signed [(RESULT_SIZE_32 + 0*16)*32 -1:0] result_memory_32_S,
    input signed [FILTER_SIZE_MRB_M1-1:0] filter_MRB_M1,
    input signed [FILTER_SIZE_MRB_S1-1:0] filter_MRB_S1,
    input signed [15:0] bias_MRB_M1,
    input signed [15:0] bias_MRB_S1,
    output signed [RESULT_SIZE_MRB_M1-1:0] result_MRB_M1,
    output signed [RESULT_SIZE_MRB_S1-1:0] result_MRB_S1,
    input clk
    );
    
    MRB_Top MRB_Top (
        .matrix(result_memory_32_M),
        .filter(filter_MRB_M1),
        .bias_MRB_M1(bias_MRB_M1),
        .result(result_MRB_M1),
        .clk(clk)
    );
    
    MRB_Buttom MRB_Buttom (
        .matrix(result_memory_32_S),
        .filter(filter_MRB_S1),
        .bias_MRB_S1(bias_MRB_S1),
        .result(result_MRB_S1),
        .clk(clk)
    );
    
    
endmodule