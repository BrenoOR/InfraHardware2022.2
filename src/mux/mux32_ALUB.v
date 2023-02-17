module mux32_ALUB (
    input wire [1:0]  signal,
    input wire [31:0] data_0;
    input wire [31:0] data_1;
    input wire [31:0] data_2;
    output wire [31:0] data_Out;
);

/*
   input 0: data_0 = B
   input 1:  4
   input 2: data_1 = instr[15:0] ext
   input 3: data_2 = instr[15:0] ext sft
*/

    wire [31:0] aux_0;
    wire [31:0] aux_1;

    assign aux_0 = (signal[0]) ? 32'b00000000000000000000000000000100 : data_0;
    assign aux_1 = (signal[0]) ? data_2 : data_1;

    assign data_Out = (signal[1]) ? aux_1 : aux;

endmodule