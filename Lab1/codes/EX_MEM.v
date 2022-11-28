module EX_MEM (
    input clk_i,
    input start_i,

    input RegWrite_i,
    input MemtoReg_i,
    input MemRead_i,
    input MemWrite_i,
    input [31:0] ALU_result_i,
    input [31:0] MUX_B_out_i, // unknown
    input [4:0] rd_i,

    output RegWrite_o,
    output MemtoReg_o,
    output MemRead_o,
    output MemWrite_o,
    output [31:0] ALU_result_o,
    output [31:0] MUX_B_out_o,
    output [4:0] rd_o
);

reg RegWrite_o;
reg MemtoReg_o;
reg MemRead_o;
reg MemWrite_o;
reg [31:0] ALU_result_o;
reg [31:0] MUX_B_out_o;
reg [4:0] rd_o;


always @(posedge clk_i) begin
    // 不知道能不能這樣寫
    if (start_i) begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALU_result_o <= ALU_result_i;
        MUX_B_out_o <= MUX_B_out_i;
        rd_o <= rd_i;
    end
end
endmodule
