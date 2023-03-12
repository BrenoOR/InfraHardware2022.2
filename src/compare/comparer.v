module comparer (

       input  wire gt,
       input  wire eq,
       input  wire zero,
       input  wire pc_write,
       input  wire Flag_Eq,
       input  wire Flag_Gt,
       output wire data_output

);

    assign data_output = (eq && Flag_Eq) || (!eq && !Flag_Eq) || (gt && Flag_Gt) || (gt && !Flag_Gt) || (pc_write);

endmodule