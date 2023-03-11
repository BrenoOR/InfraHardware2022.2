module complement2(
    input wire clock,
    input wire [31:0] orgnValue,
    output wire [31:0] complemento 
);

    reg [31:0] temp;
    
    always @(*)begin
        temp = (~orgnValue + 32'b00000000000000000000000000000001);
    end

    assign complemento = temp;

endmodule

module booth_action(
    input wire [64:0] A,
    input wire [64:0] S,
    input wire [64:0] this_P,
    output wire [64:0] new_P
);

    wire Qn = this_P[1];
    wire Qn1 = this_P[0];
    reg [64:0] temp;
    integer teste;

    always @(*)begin
        if(Qn != Qn1)begin
            if(Qn == 1'b0)begin
                teste = 1;
                temp = this_P + A;
            end
            else begin
                teste = 2;
                temp = this_P + S;
            end
        end
        else begin
            teste = 3;
            temp = this_P;
        end
        temp = {temp[64], temp[64:1]};
    end

    assign new_P = temp;

endmodule


module booth_mult(
    input wire clock,
    input wire reset,
    input wire [31:0] valueA, // multiplicando (BR)
    input wire [31:0] valueB, // multiplicador (QR)
    output wire [31:0] mostSig,
    output wire [31:0] leastSig
);

    wire [31:0] nBR;
    //32'b00000000000000000000000000000011;
    //32'b00000000000000000000000000001100;

    complement2 comp(clock, valueA, nBR);

    wire [64:0] A = {valueA, 33'b000000000000000000000000000000000};
    wire [64:0] S = {nBR, 33'b000000000000000000000000000000000};
    wire [64:0] P[32:0];
    assign P[0] = {32'b00000000000000000000000000000000, valueB, 1'b0};
    
    booth_action a1(A, S, P[0], P[1]);
    booth_action a2(A, S, P[1], P[2]);
    booth_action a3(A, S, P[2], P[3]);
    booth_action a4(A, S, P[3], P[4]);
    booth_action a5(A, S, P[4], P[5]);
    booth_action a6(A, S, P[5], P[6]);
    booth_action a7(A, S, P[6], P[7]);
    booth_action a8(A, S, P[7], P[8]);
    booth_action a9(A, S, P[8], P[9]);
    booth_action a10(A, S, P[9], P[10]);
    booth_action a11(A, S, P[10], P[11]);
    booth_action a12(A, S, P[11], P[12]);
    booth_action a13(A, S, P[12], P[13]);
    booth_action a14(A, S, P[13], P[14]);
    booth_action a15(A, S, P[14], P[15]);
    booth_action a16(A, S, P[15], P[16]);
    booth_action a17(A, S, P[16], P[17]);
    booth_action a18(A, S, P[17], P[18]);
    booth_action a19(A, S, P[18], P[19]);
    booth_action a20(A, S, P[19], P[20]);
    booth_action a21(A, S, P[20], P[21]);
    booth_action a22(A, S, P[21], P[22]);
    booth_action a23(A, S, P[22], P[23]);
    booth_action a24(A, S, P[23], P[24]);
    booth_action a25(A, S, P[24], P[25]);
    booth_action a26(A, S, P[25], P[26]);
    booth_action a27(A, S, P[26], P[27]);
    booth_action a28(A, S, P[27], P[28]);
    booth_action a29(A, S, P[28], P[29]);
    booth_action a30(A, S, P[29], P[30]);
    booth_action a31(A, S, P[30], P[31]);
    booth_action a32(A, S, P[31], P[32]);

    assign mostSig = P[32][64:33];
    assign leastSig = P[32][32:1];

endmodule
