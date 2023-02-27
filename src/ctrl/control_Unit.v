module control_Unit(
    input wire clock,
    input wire reset,

    // ALU
    input wire overflow,
    input wire negative,
    input wire zero,
    input wire eq,
    input wire gt,
    input wire lt,

    // Opcode
    input wire [5:0] opcode,

    // Controles 1 bit
    
    output reg PC_Write,
    output reg PC_Write_Cond,
    output reg MEM_ReadWrite,
    output reg IR_Write,
    output reg Xchg_Write,
    output reg Xchg_Src,
    output reg Reg_Write,
    output reg AB_Write,
    output reg ALUOut_Write,
    output reg Use_Overflow,
    output reg Opcode_Error,
    output reg EPC_Read,
    output reg Shift_Control,

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

reg [1:0] state;

reg [2:0] counter;

// Estados da Máquina de estados
parameter State_Common  = 2'b00;
parameter State_Add     = 2'b01;
parameter State_Addi    = 2'b10;
parameter State_Reset   = 2'b11;

// Opcodes
parameter Add   = 6'b000000;
parameter Addi  = 6'b001000;
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
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = counter + 1;
                end
                else if (counter == 3'b101) begin
                    case (opcode)
                        Add: begin
                            state = State_Add;
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
                    Reg_Write       = 1'b1;         //<---------
                    AB_Write        = 1'b0;
                    ALUOut_Write    = 1'b0;         //
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
                    reset_Out       = 1'b0;

                    // Set counter
                    counter         = counter + 1;
                end
                else if (counter == 3'b001) begin
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
                    counter         = 3'b000;
                end
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
                    reset_Out       = 1'b1;

                    // Set counter
                    counter         = 3'b000;
                end
            end
        endcase
    end
end

endmodule