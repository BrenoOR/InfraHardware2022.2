module control_Unit(
    input wire clock,
    input wire reset,

    // ALU
    input wire overflow,
    input wire negative,
    input wire zero,

    // Opcode
    input wire [5:0] opcode,
    input wire [5:0] funct,

    // Controles 1 bit
    
    output reg PC_Write,
    output reg PC_Write_Cond,
    output reg MEM_ReadWrite,
    output reg IR_Write,
    output reg Xchg_Write,
    output reg Xchg_Src,
    output reg Use_Mult,
    output reg Reg_Write,
    output reg AB_Write,
    output reg ALUOut_Write,
    output reg Use_Overflow,
    output reg Opcode_Error,
    output reg EPC_Read,
    output reg Shift_Control,
    output reg Flag_Eq,
    output reg Flag_Gt,
    output reg Flag_Lt

    // Controles de mais de 1 bit

    output reg [1:0] Word_Length,
    output reg [5:0] ALU_Op,

    // Controles de muxes
    
    output reg ALUSrc_A,
    output reg Use_Shamt,

    output reg [1:0] IorD,
    output reg [1:0] Reg_Dst,
    output reg [1:0] ALUSrc_B,

    output reg [2:0] Mem_To_Reg,
    output reg [2:0] PC_Src,

    // Controle de reset

    output reg reset_Out
);

reg [5:0] state;

reg [2:0] counter; // TBC

// Estados da Máquina de estados

// Common e Reset
parameter State_Common  = 6'b000000;
parameter State_Reset   = 6'b111111;

// Tipo R
parameter State_Add     = 6'b000001;
parameter State_And     = 6'b000010;
parameter State_Div     = 6'b000011;
parameter State_Mult    = 6'b000100;
parameter State_Jr      = 6'b000101;
parameter State_Mfhi    = 6'b000110;
parameter State_Mflo    = 6'b000111;
parameter State_Sll     = 6'b001000;
parameter State_Sllv    = 6'b001001;
parameter State_Slt     = 6'b001010;
parameter State_Sra     = 6'b001011;
parameter State_Srav    = 6'b001100;
parameter State_Srl     = 6'b001101;
parameter State_Sub     = 6'b001110;
parameter State_Break   = 6'b001111;
parameter State_Rte     = 6'b010000;
parameter State_Xchg    = 6'b010001;

// Tipo I
parameter State_Addi    = 6'b010010;
parameter State_Addiu   = 6'b010011;
parameter State_Beq     = 6'b010100;
parameter State_Bne     = 6'b010101;
parameter State_Ble     = 6'b010110;
parameter State_Bgt     = 6'b010111;
parameter State_Sram    = 6'b011000;
parameter State_Lb      = 6'b011001;
parameter State_Lh      = 6'b011010;
parameter State_Lui     = 6'b011011;
parameter State_Lw      = 6'b011100;
parameter State_Sb      = 6'b011101;
parameter State_Sh      = 6'b011110;
parameter State_Slti    = 6'b011111;
parameter State_Sw      = 6'b100000;

// Tipo J
parameter State_J       = 6'b100001;
parameter State_Jal     = 6'b100010;


// Opcodes
// Tipo R
parameter R     = 6'b000000;
parameter Add   = 6'b100000;
parameter And   = 6'b100100;
parameter Div   = 6'b100000;
parameter Mult  = 6'b100000;
parameter Jr    = 6'b100000;
parameter Mfhi  = 6'b100000;
parameter Mflo  = 6'b100000;
parameter Sll   = 6'b100000;
parameter Sllv  = 6'b100000;
parameter Slt   = 6'b100000;
parameter Sra   = 6'b100000;
parameter Srav  = 6'b100000;
parameter Srl   = 6'b100000;
parameter Sub   = 6'b100000;
parameter Break = 6'b100000;
parameter Rte   = 6'b100000;
parameter Xchg  = 6'b100000;

// Tipo I
parameter Addi  = 6'b001000;
parameter Addiu = 6'b001001;
parameter Beq   = 6'b000100;
parameter Bne   = 6'b000101;
parameter Ble   = 6'b000110;
parameter Bgt   = 6'b000111;
parameter Sram  = 6'b000001;
parameter Lb    = 6'b100000;
parameter Lh    = 6'b100001;
parameter Lui   = 6'b001111;
parameter Lw    = 6'b100011;
parameter Sb    = 6'b101000;
parameter Sh    = 6'b101001;
parameter Slti  = 6'b001010;
parameter Sw    = 6'b101011;

// Tipo J
parameter J     = 6'b000010;
parameter Jal   = 6'b000011;

// Reset
parameter Reset = 6'b111111;

initial begin
    reset_Out = 1'b1;
end

always @(posedge clock) begin
    if (reset == 1'b1) begin
        if (state != State_Reset) begin
            state = State_Reset;

            // Set signals
            PC_Write        = 1'b0;
            PC_Write_Cond   = 1'b0;
            MEM_ReadWrite   = 1'b0;
            IR_Write        = 1'b0;
            Xchg_Write      = 1'b0;
            Xchg_Src        = 1'b0;
            Reg_Write       = 1'b0;
            AB_Write        = 1'b0;
            ALUOut_Write    = 1'b0;
            Use_Overflow    = 1'b0;
            Opcode_Error    = 1'b0;
            EPC_Read        = 1'b0;
            Shift_Control   = 1'b0;
            Word_Length     = 2'b00;
            ALU_Op          = 6'b000000;
            ALUSrc_A        = 1'b0;
            Use_Shamt       = 1'b0;
            IorD            = 2'b00;
            Reg_Dst         = 2'b00;
            ALUSrc_B        = 2'b00;
            Mem_To_Reg      = 3'b000;
            PC_Src          = 3'b000;
            Flag_Eq         = 1'b0;
            Flag_Gt         = 1'b0;
            Flag_Lt         = 1'b0;
            reset_Out       = 1'b1;

            // Set counter
            counter         = 3'b000;
        end
        else begin
            state = State_Common;

            // Set signals
            PC_Write        = 1'b0;
            PC_Write_Cond   = 1'b0;
            MEM_ReadWrite   = 1'b0;
            IR_Write        = 1'b0;
            Xchg_Write      = 1'b0;
            Xchg_Src        = 1'b0;
            Reg_Write       = 1'b0;
            AB_Write        = 1'b0;
            ALUOut_Write    = 1'b0;
            Use_Overflow    = 1'b0;
            Opcode_Error    = 1'b0;
            EPC_Read        = 1'b0;
            Shift_Control   = 1'b0;
            Word_Length     = 2'b00;
            ALU_Op          = 6'b000000;
            ALUSrc_A        = 1'b0;
            Use_Shamt       = 1'b0;
            IorD            = 2'b00;
            Reg_Dst         = 2'b00;
            ALUSrc_B        = 2'b00;
            Mem_To_Reg      = 3'b000;
            PC_Src          = 3'b000;
            Flag_Eq         = 1'b0;
            Flag_Gt         = 1'b0;
            Flag_Lt         = 1'b0;
            reset_Out       = 1'b0;         //<---------

            // Set counter
            counter         = 3'b000;
        end
    end
    else begin
        case (state)
            State_Common: begin
                if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010) begin
                    state = State_Common;
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;         //
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b0;
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = 6'b100000;    //<--------- Indicates do ALU control that it's a PC + 4 OP
                    ALUSrc_A        = 1'b0;         //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b01;        //<---------
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = counter + 1;
                end
                else if (counter == 3'b011) begin
                    state = State_Common;
                    // Set signals
                    PC_Write        = 1'b1;         //<---------
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;         //
                    IR_Write        = 1'b1;         //<---------
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b0;
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = 6'b100000;    // Indicates do ALU control that it's a PC + 4 OP
                    ALUSrc_A        = 1'b0;         //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b01;        //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = counter + 1;
                end
                else if (counter == 3'b100) begin
                    state = State_Common;
                    // Set signals
                    PC_Write        = 1'b0;         //<---------
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;         //<---------
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b0;
                    AB_Write        = 1'b1;         //<---------
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = 6'b100000;    // Indicates do ALU control that it's a PC + 4 OP
                    ALUSrc_A        = 1'b0;         //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b00;        //<---------
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = counter + 1;
                end
                else if (counter == 3'b101) begin
                    case (opcode)
                        R: begin
                            case (funct)
                                Add: begin
                                    state = State_Add;
                                end
                            endcase
                        end
                        Addi: begin
                            state = State_Addi;
                        end
                        Reset: begin
                            state = State_Reset;
                        end
                    endcase
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b0;
                    AB_Write        = 1'b0;         //<---------
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = 6'b100000;    // Indicates do ALU control that it's a PC + 4 OP
                    ALUSrc_A        = 1'b0;         //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b00;        //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = 3'b000;
                end
            end
            State_Add: begin
                if (counter == 3'b000) begin
                    state = State_Add;
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b1;         //<---------
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = opcode;       //<---------
                    ALUSrc_A        = 1'b1;         //<---------
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b01;
                    ALUSrc_B        = 2'b00;        //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = counter + 1;
                end
                else if (counter == 3'b001) begin
                    state = State_Add;
                    
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b1;         //
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b1;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = opcode;       //
                    ALUSrc_A        = 1'b1;         //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b01;
                    ALUSrc_B        = 2'b00;        //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = 3'b010;
                end
                else if (counter == 3'b010) begin
                    state = State_Common;
                    
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b1;         //
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b1;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = opcode;       //
                    ALUSrc_A        = 1'b1;         //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b01;
                    ALUSrc_B        = 2'b00;        //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = 3'b000;
                end
            end
            State_Addi: begin
                if (counter == 3'b000) begin
                    state = State_Addi;
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b0;         //<---------
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b1;         //
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = opcode;       //<---------
                    ALUSrc_A        = 1'b1;         //<---------
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b10;        //<---------
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = counter + 1;
                end
                else if (counter == 3'b001 || counter == 3'b010) begin
                    state = State_Addi;
                    
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b1;         //
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b1;         //<---------
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = opcode;       //
                    ALUSrc_A        = 1'b1;         //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b10;        //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = counter + 1;
                end
                else if (counter == 3'b011) begin
                    state = State_Addi;
                    
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b1;         //
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b1;         //
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = opcode;       //
                    ALUSrc_A        = 1'b1;         //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b10;        //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = counter + 1;
                end
                else if (counter == 3'b100) begin
                    state = State_Common;
                    
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b1;         //
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b1;         //
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = opcode;       //
                    ALUSrc_A        = 1'b1;         //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b10;        //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = 3'b000;
                end
            end
            State_Break: begin

            end
            State_Reset: begin
                if (counter == 3'b000) begin
                    state = State_Reset;
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b0;
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = 6'b000000;
                    ALUSrc_A        = 1'b0;
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b00;
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b1;

                    // Set counter
                    counter         = 3'b000;
                end
            end
            State_Beq: begin
                if (counter == 3'b000) begin
                    state = State_Beq;
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b0;
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = 6'b000111;//
                    ALUSrc_A        = 1'b1;     //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b00;    //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b1;     //
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = 3'b000;
                end
            end
            State_Bne: begin
                if (counter == 3'b000) begin
                    state = State_Bne;
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b0;
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = 6'b000111;//
                    ALUSrc_A        = 1'b1;     //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b00;    //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;     //
                    Flag_Gt         = 1'b0;
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = 3'b000;
                end
            end
            State_Ble: begin
                if (counter == 3'b000) begin
                    state = State_Ble;
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b0;
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = 6'b000111;//
                    ALUSrc_A        = 1'b1;     //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b00;    //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;     //
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = 3'b000;
                end
            end
            State_Bgt: begin
                if (counter == 3'b000) begin
                    state = State_Bgt;
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Reg_Write       = 1'b0;
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = 6'b000111;//
                    ALUSrc_A        = 1'b1;     //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b00;    //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;
                    Flag_Gt         = 1'b0;     //
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = 3'b000;
                end
            end
<<<<<<< Updated upstream
            
=======
            State_Mult: begin
                if(counter == 3'b000) begin
                    state = State_Mult;
                    // Set signals
                    PC_Write        = 1'b0;
                    PC_Write_Cond   = 1'b0;
                    MEM_ReadWrite   = 1'b0;
                    IR_Write        = 1'b0;
                    Xchg_Write      = 1'b0;
                    Xchg_Src        = 1'b0;
                    Use_Mult        = 1'b1;
                    Reg_Write       = 1'b0;
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b0;
                    Use_Overflow    = 1'b0;
                    Opcode_Error    = 1'b0;
                    EPC_Read        = 1'b0;
                    Shift_Control   = 1'b0;
                    Word_Length     = 2'b00;
                    ALU_Op          = 6'b000111;//
                    ALUSrc_A        = 1'b1;     //
                    Use_Shamt       = 1'b0;
                    IorD            = 2'b00;
                    Reg_Dst         = 2'b00;
                    ALUSrc_B        = 2'b00;    //
                    Mem_To_Reg      = 3'b000;
                    PC_Src          = 3'b000;
                    Flag_Eq         = 1'b0;     
                    Flag_Gt         = 1'b0;     //
                    Flag_Lt         = 1'b0;
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = 3'b000;
                end
            end
>>>>>>> Stashed changes
        endcase
    end
end

endmodule