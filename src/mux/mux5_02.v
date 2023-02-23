module mux5_02 (
    input wire [1:0]  signal,
    input wire [4:0] data_0,
    input wire [4:0] data_1,
    input wire [4:0] data_2,
    output wire [4:0] data_Out
);

    wire [4:0] aux;

    assign aux = (signal[0]) ? data_1 : data_0;

    assign data_Out = (signal[1]) ? data_2 : aux;

endmodule