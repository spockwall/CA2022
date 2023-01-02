module branch_predictor
(
    input clk_i,
    input start_i,
    input rst_i,

    input update_i,
	input result_i,
	output predict_o
);

// TODO
reg [1:0] state;
assign predict_o = !state[1];

always@(posedge clk_i or posedge rst_i) begin
    if(start_i && update_i)begin
        if(result_i == 1) begin
            // predict taken
            if(state != 2'd0)begin
                state <= state-1;
            end
        end
        else begin
            // predict not taken
            if(state != 2'd3)begin
                state <= state+1;
            end
        end
    end
end

endmodule
