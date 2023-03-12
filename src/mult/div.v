module booth_div(
    input wire clock,
    input wire reset,
    input wire [31:0] valueA, // resto
    input wire [31:0] valueB, // divisor
    output reg [31:0] quociente,
    output reg [31:0] resto,
    output wire divZero
);
    integer count = 0;
    wire [31:0] nDV = (~valueB + 32'b00000000000000000000000000000001);
    //32'b00000000000000000000000000000011;
    //32'b11111111111111111111111111111100;

    reg [63:0] fullRest[32:0];
    assign fullRest[0] = {32'b00000000000000000000000000000000, valueA};

    //condition ? value_if_true : value_if_false
    assign divZero = (valueB == 32'b00000000000000000000000000000000) ? 1'b1 : 1'b0;

    always @(posedge clock)begin
        if(reset)begin
            count = 0;
        end
        else if(count < 32)begin
            if(divZero != 1'b1)begin
                fullRest[count+1] = fullRest[count] + nDV;
                if(fullRest[count+1][63])begin
                    fullRest[count+1] = fullRest[count];
                end
                quociente[31-count] = (fullRest[count+1][63] == 1'b1) ? 1'b0 : 1'b1;

                fullRest[count+1] = {fullRest[count+1][62:0], 1'b0};

                count = count + 1;
            end
            else begin
                count = 32;
            end
        end
    end
    
    assign resto = fullRest[32][63:32];

endmodule