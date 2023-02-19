module Overflow_Reg(
    input wire clock,
    input wire reset,
    input wire use_Overflow,
    input wire overflow_Signal,
    output reg overflow_Out
);

initial begin
    overflow_Out = 1'b0;
end

always @(edge clock) begin
    if (reset == 1'b1) begin
        overflow_Out = 1'b0;
    end
    else begin
        if (use_Overflow == 1'b0) begin
            overflow_Out = 1'b0;
        end
        else if (use_Overflow == 1'b1) begin
            overflow_Out = overflow_Signal;
        end
    end
end

endmodule