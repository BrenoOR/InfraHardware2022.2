module signext32_16 (
    input wire [15:0] data_input,
    output wire [31:0] data_out
);

    assign data_out = {{16{data_input[15]}}, data_input};

endmodule