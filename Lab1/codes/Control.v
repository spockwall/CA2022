module Control(
    input  [6:0] Op_i,
    input  NoOp_i,
    output [1:0] ALUOp_o,
    output ALUSrc_o,
    output RegWrite_o,
    output MemtoReg_o,
    output MemRead_o,
    output MemWrite_o,
    output Branch_o
);

reg [1:0] ALUOp_o;
reg ALUSrc_o;
reg RegWrite_o;
reg MemtoReg_o;
reg MemRead_o;
reg MemWrite_o;
reg Branch_o;

always @(*) begin
    if (!NoOp_i) begin
        if (Op_i == 7'b0110011) begin
            // R-type instruction
            ALUOp_o = 2'b10; // ALUop of a R-type: 10
            ALUSrc_o = 1'b0;
            RegWrite_o = 1'b1;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b0;
            Branch_o = 1'b0;

        end
        else if (Op_i == 7'b0010011 ) begin
            // I-type instruction
            ALUOp_o = 2'b11; // ALUop of a immediate: 11
            ALUSrc_o = 1'b1;
            RegWrite_o = 1'b1;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b0;
            Branch_o = 1'b0;
        end
        else if (Op_i == 7'b0000011) begin
            // load instruction
            // ALU: add
            ALUOp_o = 2'b11;
            ALUSrc_o = 1'b1;
            RegWrite_o = 1'b1;
            MemtoReg_o = 1'b1;
            MemRead_o = 1'b1;
            MemWrite_o = 1'b0;
            Branch_o = 1'b0;
        end
        // s-type
        else if (Op_i == 7'b0100011) begin
            // store instruction
            // ALU: add
            ALUOp_o = 2'b11;
            ALUSrc_o = 1'b1;
            RegWrite_o = 1'b0;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b1;
            Branch_o = 1'b0;
        end
        //SB-type
        else if (Op_i == 7'b1100011) begin
            // beq instruction
            ALUOp_o = 2'b11;
            ALUSrc_o = 1'b0;
            RegWrite_o = 1'b0;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b0;
            Branch_o = 1'b1;
        end
        else begin
            // default
            ALUOp_o = 2'b00;
            ALUSrc_o = 1'b0;
            RegWrite_o = 1'b0;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b0;
            Branch_o = 1'b0;
        end
    end
    else begin
        ALUOp_o = 2'b00; // ALUop of a immediate: 11
        ALUSrc_o = 1'b0;
        RegWrite_o = 1'b0;
        MemtoReg_o = 1'b0;
        MemRead_o = 1'b0;
        MemWrite_o = 1'b0;
        Branch_o = 1'b0;
    end
end
endmodule
