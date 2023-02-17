module shift_left32_2(
    input [31:0]  data_input,
    output [31:0] data_output
);

    assign data_output = {data_input[29:0], 2{1'b0}}

endmodule