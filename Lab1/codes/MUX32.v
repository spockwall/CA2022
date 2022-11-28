module MUX32(
    input  [31:0] data1_i,
    input  [31:0] data2_i,
    input  select_i,
    output [31:0] data_o
);

assign data_o = select_i ? data2_i : data1_i;
endmodule

module MUX32W(
    input  MemtoReg,
    input  [31:0] ALU_result,
    input  [31:0] read_data,
    output [31:0] data_o
);

assign data_o = MemtoReg ? read_data : ALU_result;
endmodule

// Forward A B
module MUX32_Forward (
    input [1:0]  Forward_i,
    input [31:0] ID_EX_rs_data_i, //00
    input [31:0] EX_MEM_ALU_result_i, // 10
    input [31:0] write_data_i, // 01
    output [31:0] data_o
);
assign data_o = Forward_i[1] ?
                (Forward_i[0] ? 32'bx : EX_MEM_ALU_result_i) :
                (Forward_i[0] ? write_data_i : ID_EX_rs_data_i) ;
endmodule

module MUX32_PC (
    input zero_i,
    input [31:0] PC_i,
    input [31:0] Branch_address_i,
    output [31:0] data_o
);
assign data_o = (zero_i) ? Branch_address_i : PC_i;
// always @(*) begin
    // $display ("zero PC: %b", zero_i);
    // $display ("data out PC: %b", data_o);
    // $display ("PC_i: %b", PC_i);
    // $display ("branch_addr: %b", Branch_address_i);
// end
endmodule
