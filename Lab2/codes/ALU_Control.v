module ALU_Control(
    input [1:0] ALUOp_i,
    input [9:0] funct_i, // {funct7,funct3}
    output[2:0] ALUCtrl_o
);

reg [2:0] ALUCtrl;
assign ALUCtrl_o = ALUCtrl;
always @(*)
begin
    case (ALUOp_i)
        2'b00 : ALUCtrl = 3'b010;
        2'b01 : ALUCtrl = 3'b101;
        2'b10 :
            case(funct_i)
                10'b0000000111 : ALUCtrl = 3'b000; // and
                10'b0000000100 : ALUCtrl = 3'b111; // xor
                10'b0000000001 : ALUCtrl = 3'b011; // sll
                10'b0000000000 : ALUCtrl = 3'b010; // add
                10'b0100000000 : ALUCtrl = 3'b110; // sub
                10'b0000001000 : ALUCtrl = 3'b100; // mul
            endcase
        2'b11 :
            case(funct_i)
                // warning: if immediate is 01000000, the result will be broken.
                10'b0100000101 : ALUCtrl = 3'b001; // srai
                default: ALUCtrl = 3'b010; //addi
            endcase
    endcase
end
endmodule
