module control_ALU(
    input wire       clock,
    input wire [5:0] Funct,
    input wire [5:0] ALUOp,
    output reg [2:0] ALUControl_Out
);

reg [5:0] operation;

// ALU Control selector
// Tipo R
parameter Use_Funct = 6'b000000;

parameter Add       = 6'b100000;
parameter And       = 6'b100100;
parameter Jr        = 6'b001000;
parameter Slt       = 6'b101010;
parameter Sub       = 6'b100010;

// Tipo I - Add
parameter Addi      = 6'b001000;
parameter Addiu     = 6'b001001;

// Tipo I - Branchs condicionais
parameter Beq       = 6'b000100;
parameter Bne       = 6'b000101;
parameter Ble       = 6'b000110;
parameter Bgt       = 6'b000111;

// Tipo I - Acesso à memória
parameter Sram      = 6'b000001;
parameter Lb        = 6'b100000;
parameter Lh        = 6'b100001;
parameter Lw        = 6'b100011;
parameter Sb        = 6'b101000;
parameter Sh        = 6'b101001;
parameter Sw        = 6'b101011;

// Tipo I - Shift imediato
parameter Lui       = 6'b001111;

// Tipo I - Set
parameter Slti      = 6'b001010;

// Tipo J
parameter J         = 6'b000010;
parameter Jal       = 6'b000011;

initial begin
    operation = 6'b000000;
end

always @(posedge clock) begin
    operation = ALUOp;
    case (operation)
        Use_Funct: begin
            case(Funct)
                Add: begin
                    ALUControl_Out = 3'b001;
                end
                And: begin
                    ALUControl_Out = 3'b011;
                end
                Jr: begin
                    ALUControl_Out = 3'b000;
                end
                Slt: begin
                    ALUControl_Out = 3'b111;
                end
                Sub: begin
                    ALUControl_Out = 3'b010;
                end
                default: begin
                    ALUControl_Out = 3'b000;
                end
            endcase
        end
        Addi, Addiu: begin
            ALUControl_Out = 3'b001;
        end
        Beq, Bne, Ble, Bgt: begin
            ALUControl_Out = 3'b111;
        end
        Sram, Lb, Lh, Lw, Sb, Sh, Sw : begin
            ALUControl_Out = 3'b001;
        end
        Slti: begin
            ALUControl_Out = 3'b111;
        end
        Jal: begin
            ALUControl_Out = 3'b001;
        end
        default: begin
            ALUControl_Out = 3'b000;
        end
    endcase
end

endmodule