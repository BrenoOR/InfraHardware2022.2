module cpu(
    input wire clock,
    input wire reset
);

    // Flags da ALU
    
    wire overflow;
    wire neg;
    wire zero;
    wire eq;
    wire gt;
    wire lt;

    // Sinais da Unidade de Controle

    wire PC_Write;
    wire PC_Write_Cond;
    wire MEM_ReadWrite;
    wire IR_Write;
    wire Xchg_Write;
    wire Xchg_Src;
    wire Reg_Write;
    wire AB_Write;
    wire ALUOut_Write;
    wire Use_Overflow;
    wire Opcode_Error;
    wire EPC_Read;
    wire Shift_Control;
    wire ALUSrc_A;
    wire Use_Shamt;

    wire [1:0] Reg_Dst;
    wire [1:0] Word_Length;
    wire [1:0] ALUSrc_B;
    wire [1:0] IorD;

    wire [2:0] Mem_To_Reg;
    wire [2:0] PC_Src;

    wire [5:0] ALUOp;

    // Instrução

    wire [5:0]  INSTR_31_26;
    wire [4:0]  INSTR_25_21;
    wire [4:0]  INSTR_20_16;
    wire [15:0] INSTR_15_0;

    // JA

    wire [27:0] shift_JA_Out;

    // Escrita no Banco de Registradores

    wire [4:0] WriteReg_In;

    // Fios de dados

    wire [2:0] ALUControl_Out;

    wire [31:0] PC_In;
    wire [31:0] PC_Out;
    wire [31:0] MEM_Address;
    wire [31:0] MEM_In;
    wire [31:0] MEM_Out;
    wire [31:0] WriteRegData_In;
    wire [31:0] RegA_In;
    wire [31:0] RegB_In;
    wire [31:0] RegA_Out;
    wire [31:0] RegB_Out;
    wire [31:0] Offset_Ext;
    wire [31:0] Offset_Ext_SL2;
    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [31:0] ALUResult_Out;
    wire [31:0] ALU_Out;
    wire [31:0] LSC_Out;
    wire [31:0] LO_Out;
    wire [31:0] HI_Out;
    wire [31:0] RegShift_Out;
    wire [31:0] XchgAux_Out;
    wire [31:0] SL16_Out;
    wire [31:0] ExceptAddr_Out;

    // Control Unit

    control_Unit control_Unit(
        clock,
        reset,
        overflow,
        neg,
        zero,
        eq,
        gt,
        lt,
        INSTR_31_26,
        INSTR_15_0[5:0],
        PC_Write,
        PC_Write_Cond,
        MEM_ReadWrite,
        IR_Write,
        Xchg_Write,
        Xchg_Src,
        Reg_Write,
        AB_Write,
        ALUOut_Write,
        Use_Overflow,
        Opcode_Error,
        EPC_Read,
        Shift_Control,
        Word_Length,
        ALUOp,
        ALUSrc_A,
        Use_Shamt,
        IorD,
        Reg_Dst,
        ALUSrc_B,
        Mem_To_Reg,
        PC_Src,
        reset
    );

    //    PC_Write: Sinal da Unidade de Controle
    //    PC_in: Entrada do PC; Saída do mux controlado por PCSource
    //    PC_out: Saída do PC

    Registrador PC(
        clock,
        reset,
        PC_Write,
        PC_In,
        PC_Out
    );

    mux32_02 mux_MEMAddress(
        IorD,
        PC_Out,
        ALU_Out,
        ExceptAddr_Out,
        MEM_Address
    );

    //    MEM_address: Endereço a ser lido/escrito
    //    MEM_ReadWrite: Sinal da Unidade de Controle
    //    MEM_in: Entrada de escrita da memória; Saída do Load Size Controller
    //    MEM_out: Saída da leitura da memória

    Memoria MEM(
        MEM_Address,
        clock,
        MEM_ReadWrite,
        MEM_In,
        MEM_Out
    );

    // IR_Write: Sinal da Unidade de Controle
    // INSTR_31_26: Opcode
    // INSTR_25_21: rs
    // INSTR_20_16: rt
    // INSTR_15_0:  offset

    Instr_Reg IR(
        clock,
        reset,
        IR_Write,
        MEM_Out,
        INSTR_31_26,
        INSTR_25_21,
        INSTR_20_16,
        INSTR_15_0
    );

    // Reg_Dst: Sinal da Unidade de Controle
    // WriteReg_In: Entrada do Write register

    mux5_02 mux_WriteReg(
        Reg_Dst,
        INSTR_20_16,
        INSTR_15_0[15:11],
        INSTR_25_21,
        WriteReg_In
    );

    // Mem_To_Reg: Sinal da Unidade de Controle
    // LSC_Out: Load Size Controller

    mux32_06 mux_WriteRegData(
        Mem_To_Reg,         //done
        ALU_Out,            //done
        LSC_Out,
        LO_Out,
        HI_Out,
        RegShift_Out,
        XchgAux_Out,
        SL16_Out,
        WriteRegData_In     // done
    );

    Banco_reg REGs(
        clock,
        reset,
        Reg_Write,
        INSTR_25_21,
        INSTR_20_16,
        WriteReg_In,
        WriteRegData_In,
        RegA_In,
        RegB_In
    );
    
    //    AB_Write: Sinal da Unidade de Controle
    //    RegA_in: Entrada do A; Saída A do banco de registradores
    //    RegA_out: Saída do A; Entrada 1 do mux da primeira entrada da ULA

    Registrador A(
        clock,
        reset,
        AB_Write,
        RegA_In,
        RegA_Out
    );
        
    //    AB_Write: Sinal da Unidade de Controle
    //    RegB_in: Entrada do B; Saída B do banco de registradores
    //    RegB_out: Saída do B; Entrada 0 do mux da segunda entrada da ULA

    Registrador B(
        clock,
        reset,
        AB_Write,
        RegB_In,
        RegB_Out
    );

    //  Offset_Ext: INSTR_15_0 extendido para 32 bits

    signext32_16 signext_Instr_15_0(
        INSTR_15_0,
        Offset_Ext
    );

    shift_left32_2 shift_Instr_15_0(
        Offset_Ext,
        Offset_Ext_SL2
    );

    //  ALUSrc_A: Sinal da Unidade de Controle
    //  ALU_A: Entrada A da ULA

    mux32_01 mux_ALUSrcA(
        ALUSrc_A,
        PC_Out,
        RegA_Out,
        ALU_A
    );

    //  ALUSrc_B: Sinal da Unidade de Controle
    //  ALU_B: Entrada B da ULA

    mux32_ALUB mux_ALUSrcB(
        ALUSrc_B,
        RegB_Out,
        Offset_Ext,
        Offset_Ext_SL2,
        ALU_B
    );

    control_ALU ALU_Control(
        clock,
        INSTR_15_0[5:0],
        ALUOp,
        ALUControl_Out
    );

    Ula32 ALU(
        ALU_A,
        ALU_B,
        ALUControl_Out,
        ALUResult_Out,
        overflow,
        neg,
        zero,
        eq,
        gt,
        lt
    );

    Registrador ALUOut(
        clock,
        reset,
        ALUOut_Write,
        ALUResult_Out,
        ALU_Out
    );

    overflow_Reg IgnoreOverflow(
        Use_Overflow,
        overflow,
        IgnoreOverflow_Out
    );

    shift_left_ext28_2 shift_JA(
        {{INSTR_25_21, INSTR_20_16}, INSTR_15_0},
        shift_JA_Out
    );

    mux32_04 mux_PCSrc(
        PC_Src,
        ALUResult_Out,
        ALU_Out,
        {PC_Out[31:28], shift_JA_Out},
        EPC_Out,
        PCExcept_Address,
        PC_In
    );

    comparer comparer_(

        gt,
        eq,
        zero,
        PC_Write,
        PC_Out

    )

endmodule