module IF_ID(
    input clk_i,
    input rst_i,
    input start_i,
    input stall_i,
    input flush_i,
    input [31:0] PC_i, // pc_w
    input [31:0] instruction_i,
    output reg [31:0] IF_ID_inst_o,
    output reg [31:0] IF_ID_PC_o
);


always @(posedge clk_i or posedge rst_i) begin
    if (start_i) begin
        if (!stall_i) begin
            IF_ID_PC_o <= PC_i;
            IF_ID_inst_o <= instruction_i;
        end
        if (flush_i) begin
            IF_ID_PC_o <= 32'b0;
            IF_ID_inst_o <= 32'b0;
        end
    end
end

endmodule
