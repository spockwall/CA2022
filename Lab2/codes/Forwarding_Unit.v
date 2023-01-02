module Forwarding_Unit(
    input [4:0] ID_EX_rs1_i,
    input [4:0] ID_EX_rs2_i,
    input [4:0] EX_MEM_rd_i,
    input EX_MEM_RegWrite_i,
    input [4:0] MEM_WB_rd_i,
    input MEM_WB_RegWrite_i,

    output [1:0] Forward_A,
    output [1:0] Forward_B
);

reg [1:0] Forward_A;
reg [1:0] Forward_B;

always @(*) begin // unknown assign
    // EX hazard
    Forward_A = 2'b00;
    Forward_B = 2'b00;
    if (EX_MEM_RegWrite_i
        && (EX_MEM_rd_i != 0)
        && (EX_MEM_rd_i == ID_EX_rs1_i)
    ) begin
            Forward_A = 2'b10;
    end

    if (EX_MEM_RegWrite_i
        && (EX_MEM_rd_i != 0)
        && (EX_MEM_rd_i == ID_EX_rs2_i)
    ) begin
            Forward_B = 2'b10;
    end

    // MEM Hazard
    if (MEM_WB_RegWrite_i
        && MEM_WB_rd_i != 0
        && !(EX_MEM_RegWrite_i && (EX_MEM_rd_i != 0) && (EX_MEM_rd_i == ID_EX_rs1_i))
        && (MEM_WB_rd_i == ID_EX_rs1_i)
    ) begin
        Forward_A = 2'b01;
    end

    if (MEM_WB_RegWrite_i
        && MEM_WB_rd_i != 0
        && !(EX_MEM_RegWrite_i && (EX_MEM_rd_i != 0) && (EX_MEM_rd_i == ID_EX_rs2_i))
        && (MEM_WB_rd_i == ID_EX_rs2_i)
    ) begin
        Forward_B = 2'b01;
    end

end
endmodule
