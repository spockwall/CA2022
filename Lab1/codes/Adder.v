module Adder (
    input  [31:0] data1_in,
    input  [31:0] data2_in,
    output [31:0] data_o
);
assign data_o = data1_in + data2_in;
// always @(*) begin

//     // $display("rqwqweqweqeqweqweqwe: %b", data1_in);
//     // $display("rqwqweqweqeqweqweqwe: %b", data2_in);
//     // $display("sum : %b", data_o);
// end
endmodule
