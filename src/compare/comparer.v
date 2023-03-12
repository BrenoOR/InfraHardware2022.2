module comparer (

       input  wire gt,
       input  wire eq,
       input  wire zero,
       input  wire pc_write,
       output wire data_output

);

    assign data_output = (zero && eq) || (!zero && !eq) || (zero && gt) || (!zero && !gt) || (pc_write);

endmodule