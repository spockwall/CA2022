module CPU
(
    clk_i,
    rst_i,
    start_i
);

// Ports
input       clk_i;
input       rst_i;
input       start_i;

// Program counter
wire [31:0] pc_w;
wire [31:0] pc_r;

// instruction decode
wire [31:0] instruction;
wire [6:0] op;
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
wire [11:0] immediate;
wire [2:0] funct3;
wire [6:0] funct7;
wire [31:0] rd_data;
wire [31:0] rs1_data;
wire [31:0] rs2_data;

// imm gen
wire [31:0] immediate_32;

// ALU
wire [2:0] ALU_Ctrl;
wire [31:0] ALU_result;

// Multiplexer
wire [31:0] MUX_out;
wire [31:0] MUX_A_out;
wire [31:0] MUX_B_out;
wire [31:0] MUX_PC_out;
wire [31:0] MUX_PC_out2;

// memory;
wire [31:0] read_data;

// Branch
wire [31:0] Branch_address;
wire zero; // for ALU_out
wire predict;


// control
wire [1:0] ALUOp;
wire ALUSrc;
wire RegWrite;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire Branch;

// Pipeline Register
wire [31:0] IF_ID_inst;
wire [31:0] IF_ID_PC;

wire ID_EX_RegWrite;
wire ID_EX_MemtoReg;
wire ID_EX_MemRead;
wire ID_EX_MemWrite;
wire [1:0] ID_EX_ALUOp;
wire ID_EX_ALUSrc;
wire [31:0] ID_EX_rs1_data;
wire [31:0] ID_EX_rs2_data;
wire [31:0] ID_EX_immediate_32;
wire [4:0] ID_EX_rs1;
wire [4:0] ID_EX_rs2;
wire [4:0] ID_EX_rd;
wire [9:0] ID_EX_funct;
wire [31:0] ID_EX_pc_next; // lab2
wire [31:0] ID_EX_Branch_address; // lab2
wire ID_EX_prev_predict; // lab2
wire ID_EX_update;

wire EX_MEM_RegWrite;
wire EX_MEM_MemtoReg;
wire EX_MEM_MemRead;
wire EX_MEM_MemWrite;
wire [31:0] EX_MEM_ALU_result;
wire [31:0] EX_MEM_MUX_B_out;
wire [4:0] EX_MEM_rd;

wire MEM_WB_RegWrite;
wire MEM_WB_MemtoReg;
wire [31:0] MEM_WB_read_data;
wire [31:0] MEM_WB_ALU_result;
wire [4:0] MEM_WB_rd;

// Hazard
wire stall;
wire NoOp;
wire PCWrite;
wire Flush;

// Forward
wire [1:0] Forward_A;
wire [1:0] Forward_B;

assign immediate = (op == 7'b0100011) ? {IF_ID_inst[31:25], IF_ID_inst[11:7]} : // sw
                   (op == 7'b1100011) ? {IF_ID_inst[31], IF_ID_inst[7], IF_ID_inst[30:25], IF_ID_inst[11:8]} : // beq
                   IF_ID_inst[31:20]; // lw or I-type
assign op = IF_ID_inst[6:0];
assign funct3 = IF_ID_inst[14:12];
assign funct7 = IF_ID_inst[31:25];
assign rd = IF_ID_inst[11:7];
assign rs1 = IF_ID_inst[19:15];
assign rs2 = IF_ID_inst[24:20];

// lab2 branch preditor
wire [31:0] pc_restore;

assign IF_ID_EX_Flush = (ID_EX_update && (ID_EX_prev_predict != zero));
assign pc_restore = (ID_EX_prev_predict==1 && zero==0) ? ID_EX_pc_next : ID_EX_Branch_address;

Control Control(
    .Op_i       (op),
    .NoOp_i     (NoOp),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .RegWrite_o (RegWrite),
    .MemtoReg_o (MemtoReg),
    .MemRead_o  (MemRead),
    .MemWrite_o (MemWrite),
    .Branch_o   (Branch)
);

Adder Add_PC(
    .data1_in   (pc_w),
    .data2_in   (32'd4),
    .data_o     (pc_r)
);

Adder Add_Branch(
    .data1_in   (IF_ID_PC),
    .data2_in   (immediate_32 << 1),
    .data_o     (Branch_address)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (PCWrite),
    .pc_i       (MUX_PC_out2), // lab2
    .pc_o       (pc_w)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_w),
    .instr_o    (instruction)
);

Data_Memory Data_Memory (
    .clk_i      (clk_i),
    .addr_i     (EX_MEM_ALU_result),
    .MemRead_i  (EX_MEM_MemRead),
    .MemWrite_i (EX_MEM_MemWrite),
    .data_i     (EX_MEM_MUX_B_out),
    .data_o     (read_data)
);

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (rs1),
    .RS2addr_i   (rs2),
    .RDaddr_i    (MEM_WB_rd),
    .RDdata_i    (rd_data),
    .RegWrite_i  (MEM_WB_RegWrite),
    .RS1data_o   (rs1_data),
    .RS2data_o   (rs2_data)
);

// lab2
MUX32 MUX32A (
    .data1_i   (pc_r),
    .data2_i   (Branch_address),
    .select_i  (Branch && predict),
    .data_o    (MUX_PC_out)
);

// lab2
MUX32 MUX32B (
    .data1_i   (MUX_PC_out),
    .data2_i   (pc_restore),
    .select_i  (IF_ID_EX_Flush),
    .data_o    (MUX_PC_out2)
);

MUX32 MUX_ALUSrc(
    .data1_i    (MUX_B_out),
    .data2_i    (ID_EX_immediate_32),
    .select_i   (ID_EX_ALUSrc),
    .data_o     (MUX_out)
);

MUX32W MUX32W (
    .MemtoReg   (MEM_WB_MemtoReg),
    .ALU_result (MEM_WB_ALU_result),
    .read_data  (MEM_WB_read_data),
    .data_o     (rd_data)
);

MUX32_Forward MUX32_A(
    .Forward_i           (Forward_A),
    .ID_EX_rs_data_i     (ID_EX_rs1_data),
    .EX_MEM_ALU_result_i (EX_MEM_ALU_result),
    .write_data_i        (rd_data), // write back data
    .data_o              (MUX_A_out)
);

MUX32_Forward MUX32_B(
    .Forward_i           (Forward_B),
    .ID_EX_rs_data_i     (ID_EX_rs2_data),
    .EX_MEM_ALU_result_i (EX_MEM_ALU_result),
    .write_data_i        (rd_data), // write back data
    .data_o              (MUX_B_out)
);

Sign_Extend Sign_Extend(
    .data_i     (immediate),
    .data_o     (immediate_32)
);

ALU ALU(
    .data1_i    (MUX_A_out),
    .data2_i    (MUX_out),
    .ALUCtrl_i  (ALU_Ctrl),
    .data_o     (ALU_result),
    .zero_o     (zero)
);

ALU_Control ALU_Control(
    .funct_i    (ID_EX_funct),
    .ALUOp_i    (ID_EX_ALUOp),
    .ALUCtrl_o  (ALU_Ctrl)
);

// pipeline registers
IF_ID IF_ID (
    .clk_i         (clk_i),
    .rst_i         (rst_i),
    .start_i       (start_i),
    .stall_i       (stall),
    .flush_i        ((Branch && predict) || IF_ID_EX_Flush), // lab2
    .PC_i          (pc_w),
    .instruction_i (instruction),
    .IF_ID_inst_o  (IF_ID_inst),
    .IF_ID_PC_o    (IF_ID_PC)
);

ID_EX ID_EX(
    .clk_i              (clk_i),
    .rst_i              (rst_i),
    .start_i            (start_i),
    .flush_i             (IF_ID_EX_Flush),
    .RegWrite_i         (RegWrite),
    .MemtoReg_i         (MemtoReg),
    .MemRead_i          (MemRead),
    .MemWrite_i         (MemWrite),
    .ALUOp_i            (ALUOp),
    .ALUSrc_i           (ALUSrc),
    .rs1_data_i         (rs1_data),
    .rs2_data_i         (rs2_data),
    .immediate_32_i     (immediate_32),
    .rs1_i              (rs1),
    .rs2_i              (rs2),
    .rd_i               (rd),
    .funct_i            ({funct7, funct3}), // funct7 + funct3
    .Branch_i           (Branch), // lab2
    .pc_next_i          (IF_ID_PC+32'd4),// lab2
    .Branch_address_i   (Branch_address),// lab2
    .prev_predict_i     (predict),// lab2

    .RegWrite_o         (ID_EX_RegWrite),
    .MemtoReg_o         (ID_EX_MemtoReg),
    .MemRead_o          (ID_EX_MemRead),
    .MemWrite_o         (ID_EX_MemWrite),
    .ALUOp_o            (ID_EX_ALUOp),
    .ALUSrc_o           (ID_EX_ALUSrc),
    .rs1_data_o         (ID_EX_rs1_data),
    .rs2_data_o         (ID_EX_rs2_data),
    .immediate_32_o     (ID_EX_immediate_32),
    .rs1_o              (ID_EX_rs1),
    .rs2_o              (ID_EX_rs2),
    .rd_o               (ID_EX_rd),
    .funct_o            (ID_EX_funct),
    .Branch_o           (ID_EX_update), // lab2
    .pc_next_o          (ID_EX_pc_next), // lab2
    .Branch_address_o   (ID_EX_Branch_address), // lab2
    .prev_predict_o     (ID_EX_prev_predict) // lab2
);

EX_MEM EX_MEM (
    .clk_i        (clk_i),
    .start_i      (start_i),
    .rst_i         (rst_i),

    .RegWrite_i   (ID_EX_RegWrite),
    .MemtoReg_i   (ID_EX_MemtoReg),
    .MemRead_i    (ID_EX_MemRead),
    .MemWrite_i   (ID_EX_MemWrite),
    .ALU_result_i (ALU_result),
    .MUX_B_out_i  (MUX_B_out), // unknown
    .rd_i         (ID_EX_rd),

    .RegWrite_o   (EX_MEM_RegWrite),
    .MemtoReg_o   (EX_MEM_MemtoReg),
    .MemRead_o    (EX_MEM_MemRead),
    .MemWrite_o   (EX_MEM_MemWrite),
    .ALU_result_o (EX_MEM_ALU_result),
    .MUX_B_out_o  (EX_MEM_MUX_B_out),
    .rd_o         (EX_MEM_rd)
);

MEM_WB MEM_WB (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .start_i      (start_i),

    .RegWrite_i   (EX_MEM_RegWrite),
    .MemtoReg_i   (EX_MEM_MemtoReg),
    .read_data_i  (read_data),
    .ALU_result_i (EX_MEM_ALU_result),
    .rd_i         (EX_MEM_rd),

    .RegWrite_o   (MEM_WB_RegWrite),
    .MemtoReg_o   (MEM_WB_MemtoReg),
    .read_data_o  (MEM_WB_read_data),
    .ALU_result_o (MEM_WB_ALU_result),
    .rd_o         (MEM_WB_rd)
);

Forwarding_Unit Forwarding_Unit (
    .ID_EX_rs1_i       (ID_EX_rs1),
    .ID_EX_rs2_i       (ID_EX_rs2),
    .EX_MEM_RegWrite_i (EX_MEM_RegWrite),
    .EX_MEM_rd_i       (EX_MEM_rd),
    .MEM_WB_rd_i       (MEM_WB_rd),
    .MEM_WB_RegWrite_i (MEM_WB_RegWrite),

    .Forward_A         (Forward_A),
    .Forward_B         (Forward_B)
);

Hazard_Detection Hazard_Detection (
    .rs1_i           (rs1),
    .rs2_i           (rs2),
    .ID_EX_MemRead_i (ID_EX_MemRead),
    .ID_EX_rd_i      (ID_EX_rd),

    .PCWrite_o       (PCWrite),
    .Stall_o         (stall),
    .NoOp_o          (NoOp)
);

// lab2
branch_predictor branch_predictor (
    .clk_i     (clk_i),
    .start_i   (start_i),
    .rst_i     (rst_i),
    .update_i  (ID_EX_update),
    .result_i  (zero),
    .predict_o (predict)
);
endmodule
