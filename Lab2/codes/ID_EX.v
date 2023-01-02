module ID_EX (
    input clk_i,
    input rst_i,
    input start_i,
    input flush_i,
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
    input Branch_i,
    input [31:0] pc_next_i,
    input [31:0] Branch_address_i,
    input prev_predict_i,

    output reg RegWrite_o,
    output reg MemtoReg_o,
    output reg MemRead_o,
    output reg MemWrite_o,
    output reg [1:0] ALUOp_o,
    output reg ALUSrc_o,
    output reg [31:0] rs1_data_o,
    output reg [31:0] rs2_data_o,
    output reg [31:0] immediate_32_o,
    output reg [4:0] rs1_o,
    output reg [4:0] rs2_o,
    output reg [4:0] rd_o,
    output reg [9:0] funct_o,
    output reg Branch_o,
    output reg [31:0] pc_next_o,
    output reg [31:0] Branch_address_o,
    output reg prev_predict_o
);

always @(posedge clk_i or posedge rst_i) begin // unknown assign
    if (flush_i) begin
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
        ALUOp_o <= 0;
        ALUSrc_o <= 0;
        rs1_data_o <= 0;
        rs2_data_o <= 0;
        immediate_32_o <= 0;
        rs1_o <= 0;
        rs2_o <= 0;
        rd_o <= 0;
        funct_o <= 0;
        Branch_o <= 0;
        pc_next_o <= 0;
        Branch_address_o <= 0;
        prev_predict_o <= 0;
    end
    else begin
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
        Branch_o <= Branch_i;
        pc_next_o <= pc_next_i;
        Branch_address_o <= Branch_address_i;
        prev_predict_o <= prev_predict_i;
    end
end
endmodule
