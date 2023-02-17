module mux32_06 (
    input wire [1:0]  signal,
    input wire [31:0] data_0;
    input wire [31:0] data_1;
    input wire [31:0] data_2;
    input wire [31:0] data_3;
    input wire [31:0] data_4;
    input wire [31:0] data_5;
    input wire [31:0] data_6;
    output wire [31:0] data_Out;
);

/*
    0 => 000
    1 => 001
    2 => 010
    3 => 011
    4 => 100
    5 => 101
    6 => 110
*/

    wire [31:0] aux_0;
    wire [31:0] aux_1;
    wire [31:0] aux_2;
    wire [31:0] aux_3;
    wire [31:0] aux_4;

    assign aux_0 = (signal[0]) ? data_1 : data_0;
    assign aux_1 = (signal[0]) ? data_3 : data_2;
    assign aux_2 = (signal[0]) ? data_5 : data_4;

    assign aux_3 = (signal[1]) ? aux_1 : aux_0;
    assign aux_4 = (signal[1]) ? data_6 : aux_2;

    assign data_Out = (signal[2]) ? aux_4 : aux_3;

endmodule