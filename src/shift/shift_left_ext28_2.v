module shift_left_ext28_2(
    input [26:0]  data_input,
    output [28:0] data_output
);

    assign data_output = {data_input, 2'b00};

endmodule