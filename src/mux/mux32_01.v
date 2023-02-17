module mux32_01 (
    input wire        signal,
    input wire [31:0] data_0;
    input wire [31:0] data_1;
    input wire [31:0] data_Out;
);

    assign data_Out = (signal) ? data_1 : data_0;

endmodule