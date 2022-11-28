module Branch_Unit(
    input Branch_i,
    input [31:0] rs1_data_i,
    input [31:0] rs2_data_i,
    output zero_o
);
assign zero_o = Branch_i && (rs1_data_i == rs2_data_i);
endmodule
