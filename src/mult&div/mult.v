module booth_mult(
    input wire clock,
    input wire reset,
    input wire multCtrl,
    input wire [31:0] valueA, // multiplicando (BR)
    input wire [31:0] valueB, // multiplicador (QR)
    output reg [31:0] mostSig, // HI
    output reg [31:0] leastSig,// LO
    output wire multEnd
);
    integer count = 0;
    wire [31:0] nBR = (~valueA + 32'b00000000000000000000000000000001);
    reg Qn, Qn1, regMultEnd;
    //32'b00000000000000000000000000000011;
    //32'b11111111111111111111111111111100;
    //64'b1111111111111111111111111111111111111111111111111111111111110100;

    wire [64:0] A = {valueA, 33'b000000000000000000000000000000000};
    wire [64:0] S = {nBR, 33'b000000000000000000000000000000000};
    reg [64:0] P[32:0];
    assign P[0] = {32'b00000000000000000000000000000000, valueB, 1'b0};
    assign multEnd = regMultEnd;
    
    always @(posedge clock)begin
        if(reset)begin
            count = 0;
            Qn = 1'b0;
            Qn1 = 1'b0;
            regMultEnd = 1'b0;
            P[0] = 65'b0; P[1] = 65'b0; P[2] = 65'b0; 
            P[3] = 65'b0; P[4] = 65'b0; P[5] = 65'b0;
            P[6] = 65'b0; P[7] = 65'b0; P[8] = 65'b0; 
            P[9] = 65'b0; P[10] = 65'b0; P[11] = 65'b0;
            P[12] = 65'b0; P[13] = 65'b0; P[14] = 65'b0; 
            P[15] = 65'b0; P[16] = 65'b0; P[17] = 65'b0;
            P[18] = 65'b0; P[19] = 65'b0; P[20] = 65'b0; 
            P[21] = 65'b0; P[22] = 65'b0; P[23] = 65'b0;
            P[24] = 65'b0; P[25] = 65'b0; P[26] = 65'b0; 
            P[27] = 65'b0; P[28] = 65'b0; P[29] = 65'b0;
            P[30] = 65'b0; P[31] = 65'b0; P[32] = 65'b0;
        end
        else if(multCtrl == 1'b1)begin
            if(count < 32)begin
                if(count == 0)begin
                    regMultEnd = 1'b0;
                end
                Qn = P[count][1];
                Qn1 = P[count][0];
                if(Qn != Qn1)begin
                    if(Qn == 1'b0)begin
                        P[count+1] = P[count] + A;
                    end
                    else begin
                        P[count+1] = P[count] + S;
                    end
                end
                else begin
                    P[count+1] = P[count];
                end
                P[count+1] = {P[count+1][64], P[count+1][64:1]};
                count = count + 1;
            end
            else begin
                regMultEnd = 1'b1;
                count = 0;
            end
        end
    end

    assign mostSig = P[32][64:33];
    assign leastSig = P[32][32:1];

endmodule