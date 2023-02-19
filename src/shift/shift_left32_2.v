module shift_left32_2(
    input [31:0]  data_input,
    output [31:0] data_output
);

    wire [29:0] input_used;

    assign input_used = data_input[29:0];
    assign data_output = {input_used, 2'b00};

endmodule