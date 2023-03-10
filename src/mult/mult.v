module complement2(
    input wire clock,
    input wire [31:0] orgnValue,
    output wire [31:0] complemento 
);

    wire [31:0] temp;

    always@(*) begin

        temp[0] = ~orgnValue[0];
        temp[1] = ~orgnValue[1];
        temp[2] = ~orgnValue[2];
        temp[3] = ~orgnValue[3];
        temp[4] = ~orgnValue[4];
        temp[5] = ~orgnValue[5];
        temp[6] = ~orgnValue[6];
        temp[7] = ~orgnValue[7];
        temp[8] = ~orgnValue[8];
        temp[9] = ~orgnValue[9];
        temp[10] = ~orgnValue[10];
        temp[11] = ~orgnValue[11];
        temp[12] = ~orgnValue[12];
        temp[13] = ~orgnValue[13];
        temp[14] = ~orgnValue[14];
        temp[15] = ~orgnValue[15];
        temp[16] = ~orgnValue[16];
        temp[17] = ~orgnValue[17];
        temp[18] = ~orgnValue[18];
        temp[19] = ~orgnValue[19];
        temp[20] = ~orgnValue[20];
        temp[21] = ~orgnValue[21];
        temp[22] = ~orgnValue[22];
        temp[23] = ~orgnValue[23];
        temp[24] = ~orgnValue[24];
        temp[25] = ~orgnValue[25];
        temp[26] = ~orgnValue[26];
        temp[27] = ~orgnValue[27];
        temp[28] = ~orgnValue[28];
        temp[29] = ~orgnValue[29];
        temp[30] = ~orgnValue[30];
        temp[31] = ~orgnValue[31];

        temp = temp + 32'b00000000000000000000000000000001
    end

    assign complemento = temp;

endmodule

module booth_action(
    input wire [64:0] A,
    input wire [64:0] S,
    input wire [64:0] P,
    output wire [64:0] new_P
);

    assign wire Qn = P[1];
    assign wire Qn1 = P[0];

    always @(*)begin
        if(Qn != Qn1)begin
            if(Qn == 1'b0)begin
                new_P = P + A;
            end
            else begin
                new_P = P + S;
            end
        end
        else begin
            new_P = P;
        end
        case(new_P[64])
            1'b1: new_P = {1'b1, P[63:0]};
            default: new_P = {1'b0, P[63:0]}
        endcase
    end

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
    //wire [31:0] acc = 32'b00000000000000000000000000000000;
    //wire [31:0] leastSig = valueB;
    //wire Qn = 1'b0;

    complement2 comp(clock, valueA, nBR);

    assign wire [64:0] A = {valueA, 33'b000000000000000000000000000000000};
    assign wire [64:0] S = {nBR, 33'b000000000000000000000000000000000};
    assign wire [64:0] P = {33'b000000000000000000000000000000000, valueB};

    //booth_action a1(valueA, valueB, nBR, Qn, acc, leastSig);
    booth_action a1(A, S, P, P);
    booth_action a2(A, S, P, P);
    booth_action a3(A, S, P, P);
    booth_action a4(A, S, P, P);
    booth_action a5(A, S, P, P);
    booth_action a6(A, S, P, P);
    booth_action a7(A, S, P, P);
    booth_action a8(A, S, P, P);
    booth_action a9(A, S, P, P);
    booth_action a10(A, S, P, P);
    booth_action a11(A, S, P, P);
    booth_action a12(A, S, P, P);
    booth_action a13(A, S, P, P);
    booth_action a14(A, S, P, P);
    booth_action a15(A, S, P, P);
    booth_action a16(A, S, P, P);
    booth_action a17(A, S, P, P);
    booth_action a18(A, S, P, P);
    booth_action a19(A, S, P, P);
    booth_action a20(A, S, P, P);
    booth_action a21(A, S, P, P);
    booth_action a22(A, S, P, P);
    booth_action a23(A, S, P, P);
    booth_action a24(A, S, P, P);
    booth_action a25(A, S, P, P);
    booth_action a26(A, S, P, P);
    booth_action a27(A, S, P, P);
    booth_action a28(A, S, P, P);
    booth_action a29(A, S, P, P);
    booth_action a30(A, S, P, P);
    booth_action a31(A, S, P, P);
    booth_action a32(A, S, P, P);

    assign wire mostSig = P[64:33];
    assign wire leastSig = P[32:1];

endmodule
