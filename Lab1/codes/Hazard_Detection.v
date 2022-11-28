module Hazard_Detection(
    input [4:0] rs1_i,
    input [4:0] rs2_i,
    input ID_EX_MemRead_i,
    input [4:0] ID_EX_rd_i,

    output PCWrite_o,
    output Stall_o,
    output NoOp_o
);


assign PCWrite_o = !(ID_EX_MemRead_i && ((ID_EX_rd_i == rs1_i) || (ID_EX_rd_i == rs2_i)));
assign Stall_o   = ID_EX_MemRead_i && ((ID_EX_rd_i == rs1_i) || (ID_EX_rd_i == rs2_i));
assign NoOp_o    = ID_EX_MemRead_i && ((ID_EX_rd_i == rs1_i) || (ID_EX_rd_i == rs2_i));
endmodule
