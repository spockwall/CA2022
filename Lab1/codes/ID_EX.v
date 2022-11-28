module ID_EX (
    input clk_i,
    input start_i,
    input RegWrite_i,
    input MemtoReg_i,
    input MemRead_i,
    input MemWrite_i,
    input [1:0] ALUOp_i,
    input ALUSrc_i,
    input [31:0] rs1_data_i,
    input [31:0] rs2_data_i,
    input [31:0] immediate_32_i,
    input [4:0] rs1_i,
    input [4:0] rs2_i,
    input [4:0] rd_i,
    input [9:0] funct_i, // funct7 + funct3

    output RegWrite_o,
    output MemtoReg_o,
    output MemRead_o,
    output MemWrite_o,
    output [1:0] ALUOp_o,
    output ALUSrc_o,
    output [31:0] rs1_data_o,
    output [31:0] rs2_data_o,
    output [31:0] immediate_32_o,
    output [4:0] rs1_o,
    output [4:0] rs2_o,
    output [4:0] rd_o,
    output [9:0] funct_o
);

reg RegWrite_o;
reg MemtoReg_o;
reg MemRead_o;
reg MemWrite_o;
reg [1:0] ALUOp_o;
reg ALUSrc_o;
reg [31:0] rs1_data_o;
reg [31:0] rs2_data_o;
reg [31:0] immediate_32_o;
reg [4:0] rs1_o;
reg [4:0] rs2_o;
reg [4:0] rd_o;
reg [9:0] funct_o;

always @(posedge clk_i) begin // unknown assign
    if (start_i) begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUOp_o <= ALUOp_i;
        ALUSrc_o <= ALUSrc_i;
        rs1_data_o <= rs1_data_i;
        rs2_data_o <= rs2_data_i;
        immediate_32_o <= immediate_32_i;
        rs1_o <= rs1_i;
        rs2_o <= rs2_i;
        rd_o <= rd_i;
        funct_o <= funct_i;
    end
end
endmodule
