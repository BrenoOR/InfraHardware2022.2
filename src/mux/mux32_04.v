module mux32_04 (
    input wire [1:0]  signal,
    input wire [31:0] data_0;
    input wire [31:0] data_1;
    input wire [31:0] data_2;
    input wire [31:0] data_3;
    input wire [31:0] data_4;
    input wire [31:0] data_Out;
);

    wire [31:0] aux_0;
    wire [31:0] aux_1;
    wire [31:0] aux_2;

    assign aux_0 = (signal[0]) ? data_1 : data_0;
    assign aux_1 = (signal[0]) ? data_3 : data_2;
    assign aux_2 = (signal[1]) ? aux_1 : aux_0;

    assign data_Out = (signal[2]) ? data_4 : aux_2;

endmodule