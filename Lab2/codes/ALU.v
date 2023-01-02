module ALU(
    input signed [31:0] data1_i   ,
    input signed [31:0] data2_i   ,
    input signed [2:0]  ALUCtrl_i ,
    output signed [31:0] data_o,
    output reg zero_o
);
reg signed [31:0] data;
assign data_o = data;
always @(*)
begin
    case (ALUCtrl_i)
        3'b000 : data = data1_i & data2_i; // and
        3'b111 : data = data1_i ^ data2_i; // xor
        3'b011 : data = data1_i << data2_i; // sll
        3'b010 : data = data1_i + data2_i; // add, addi
        3'b110 : data = data1_i - data2_i; // sub
        3'b100 : data = data1_i * data2_i; // mul
        3'b001 : data = data1_i >>> data2_i[4:0]; // srai
        3'b101 : begin
                    data = data1_i - data2_i;
                    zero_o = (data1_i == data2_i) ? 1 : 0;
                 end
    endcase
end
endmodule
