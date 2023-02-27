module overflow_Reg(
    input wire use_Overflow,
    input wire overflow_Signal,
    output reg overflow_Out
);

    assign overflow_Out = (use_Overflow) ? overflow_Signal : 1'b0;


endmodule