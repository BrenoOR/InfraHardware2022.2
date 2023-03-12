module booth_mult(
    input wire clock,
    input wire reset,
    input wire [31:0] valueA, // multiplicando (BR)
    input wire [31:0] valueB, // multiplicador (QR)
    output wire [31:0] mostSig,
    output wire [31:0] leastSig
);
    integer count = 0;
    wire [31:0] nBR = (~valueA + 32'b00000000000000000000000000000001);
    reg Qn, Qn1;
    //32'b00000000000000000000000000000011;
    //32'b11111111111111111111111111111100;

    wire [64:0] A = {valueA, 33'b000000000000000000000000000000000};
    wire [64:0] S = {nBR, 33'b000000000000000000000000000000000};
    reg [64:0] P[32:0];
    assign P[0] = {32'b00000000000000000000000000000000, valueB, 1'b0};
    
    always @(posedge clock)begin
        if(reset)begin
            count = 0;
            Qn = 0;
            Qn1 = 0;
        end
        else if(count < 32)begin
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
    end

    assign mostSig = P[32][64:33];
    assign leastSig = P[32][32:1];

endmodule