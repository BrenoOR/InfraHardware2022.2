module booth_div(
    input wire clock,
    input wire reset,
    input wire divCtrl,
    input wire [31:0] valueA, // resto
    input wire [31:0] valueB, // divisor
    output reg [31:0] quociente,
    output reg [31:0] resto,
    output wire divEnd,
    output wire divZero
);
    integer count = 0;
    wire [31:0] nDV = (~valueB + 32'b00000000000000000000000000000001);
    reg regDivEnd;
    //32'b00000000000000000000000000000111;
    //32'b00000000000000000000000000000010;

    reg [63:0] fullRest[32:0];
    assign fullRest[0] = {32'b00000000000000000000000000000000, valueA};

    assign divEnd = regDivEnd;
    //condition ? value_if_true : value_if_false
    assign divZero = (valueB == 32'b00000000000000000000000000000000) ? 1'b1 : 1'b0;

    always @(posedge clock)begin
        if(reset)begin
            count = 0;
            fullRest[0] = 64'b0; fullRest[1] = 64'b0; fullRest[2] = 64'b0; 
            fullRest[3] = 64'b0; fullRest[4] = 64'b0; fullRest[5] = 64'b0;
            fullRest[6] = 64'b0; fullRest[7] = 64'b0; fullRest[8] = 64'b0; 
            fullRest[9] = 64'b0; fullRest[10] = 64'b0; fullRest[11] = 64'b0;
            fullRest[12] = 64'b0; fullRest[13] = 64'b0; fullRest[14] = 64'b0; 
            fullRest[15] = 64'b0; fullRest[16] = 64'b0; fullRest[17] = 64'b0;
            fullRest[18] = 64'b0; fullRest[19] = 64'b0; fullRest[20] = 64'b0; 
            fullRest[21] = 64'b0; fullRest[22] = 64'b0; fullRest[23] = 64'b0;
            fullRest[24] = 64'b0; fullRest[25] = 64'b0; fullRest[26] = 64'b0; 
            fullRest[27] = 64'b0; fullRest[28] = 64'b0; fullRest[29] = 64'b0;
            fullRest[30] = 64'b0; fullRest[31] = 64'b0; fullRest[32] = 64'b0;
        end
        else if(divCtrl == 1'b1)begin
            if(count < 32)begin
                if(divZero != 1'b1)begin
                    if(count == 0)begin
                        regDivEnd = 1'b0;
                    end
                    fullRest[count+1] = fullRest[count] + nDV;
                    if(fullRest[count+1][63])begin
                        fullRest[count+1] = fullRest[count];
                        quociente[31-count] = 1'b0;
                    end
                    else begin
                        quociente[31-count] = 1'b1;
                    end
                    fullRest[count+1] = {fullRest[count+1][62:0], 1'b0};

                    count = count + 1;
                end
                else begin
                    regDivEnd = 1'b1;
                    count = 0;
                end
            end
            else begin
                regDivEnd = 1'b1;
                count = 0;
            end
        end
    end
    
    assign resto = fullRest[32][63:32];

endmodule