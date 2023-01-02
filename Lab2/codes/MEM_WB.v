module MEM_WB (
    input clk_i,
    input rst_i,
    input start_i,

    input RegWrite_i,
    input MemtoReg_i,
    input [31:0] read_data_i,
    input [31:0] ALU_result_i,
    input [4:0] rd_i,

    output RegWrite_o,
    output MemtoReg_o,
    output [31:0] read_data_o,
    output [31:0] ALU_result_o,
    output [4:0] rd_o
);

reg RegWrite_o;
reg MemtoReg_o;
reg [31:0] read_data_o;
reg [31:0] ALU_result_o;
reg [4:0] rd_o;


always @(posedge clk_i) begin // unknown assign
    if (start_i) begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        read_data_o <= read_data_i;
        ALU_result_o <= ALU_result_i;
        rd_o <= rd_i;
    end
end
endmodule
