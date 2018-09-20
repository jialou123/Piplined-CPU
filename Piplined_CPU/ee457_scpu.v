`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:57 03/22/2010 
// Design Name: 
// Module Name:    ee357_mcpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ee457_scpu(
	// I/O interface to memory
  output 		[31:0] 	imem_addr,
  output 		[31:0] 	imem_wdata,
  output 					     imemread,
  output 					     imemwrite,
 	input			[31:0]	  imem_rdata,

  output 		[31:0] 	dmem_addr,
  output 		[31:0] 	dmem_wdata,
  output 					     dmemread,
  output 					     dmemwrite,
	input			[31:0]	  dmem_rdata,
	

	// Register File I/O for debug/checking purposes
	output		[4:0]		reg_ra,
	output		[4:0]		reg_rb,
	output		[4:0]		reg_wa,
	output		[31:0]	reg_radata,
	output		[31:0]	reg_rbdata,
	output		[31:0]	reg_wdata,
	output					regwrite,
	 
	// Clock and reset
  	input 					clk,
   input 					rst
   );


	// Use these for opcode decoding
	localparam OP_LW    = 6'b100011;
	localparam OP_SW    = 6'b101011;
	localparam OP_RTYPE = 6'b000000;
	localparam OP_BEQ   = 6'b000100;
	localparam OP_BNE   = 6'b000101;
	localparam OP_JMP   = 6'b000010;
	localparam OP_ADDI  = 6'b001000;
	localparam OP_JAL   = 6'b000011;
	localparam FUNC_ADD = 6'b100000;
	localparam FUNC_SUB = 6'b100010;
	localparam FUNC_AND = 6'b100100;
	localparam FUNC_OR  = 6'b100101;
	localparam FUNC_XOR = 6'b100110;
	localparam FUNC_NOR = 6'b100111;
	localparam FUNC_SLT = 6'b101010;
	localparam FUNC_SLL = 6'b000000;
	localparam FUNC_SRL = 6'b000010;
	localparam FUNC_SRA = 6'b000011;
	localparam FUNC_JR  = 6'b001000;

	// ALU signals
	wire [31:0]		ina;
	wire [31:0]		inb;
	wire [31:0]		inc;
	wire [31:0]		ind;
	wire [31:0]		ine;
	
	reg [5:0]		alu_func;
	wire [31:0]		alu_res;
	wire 			sov;
	wire    uov;
	wire				zero;
	
	// Control Signals
	wire 				jump;
   wire 				branch;
   wire 				memtoreg;
   wire 				regdst;
   wire 				alusrc;
   wire [1:0]		aluop;

	wire [5:0]		opcode;
	wire [4:0]		rs;
	wire [4:0]		rt;
	wire [4:0]		rd;
	wire [4:0]		shamt;	
	wire [5:0]		func;
	wire [15:0]		imm;
	//wire [25:0]		jmpaddr;

	reg  [31:0]		pc;
	reg  [31:0]		pc_d;
	wire [31:0]		next_pc;
	wire [31:0] 	imm_sext;
	wire [31:0]		imm_sext_sh2;
	wire [31:0]		jump_target_pc;
	wire [31:0]		branch_target_pc;
	
	wire [4:0] wa;
	wire init_dmemread;
   wire init_dmemwrite;
   wire init_regwrite;
	
	reg [31:0] ID_addr;
	reg [31:0] ID_instr;
	reg [31:0] DE_addr;
	reg [25:0] ID_jmpaddr;
	reg [25:0] DE_jmpaddr;
	reg [31:0] EX_nextaddr;
	reg [31:0] EX_branchaddr;
	reg [31:0] EX_jumpaddr;
	reg [31:0] DE_imm_sext;
	reg [31:0] DE_reg_radata;
	reg [31:0] DE_reg_rbdata;
	reg [31:0] EX_reg_rbdata;
	reg [4:0] DE_rd;
	reg [4:0] DE_rt;
	reg [4:0] DE_rs;
	reg [4:0] EX_wa;
	reg [4:0] WB_wa;
	reg EX_zero;
	reg [31:0] EX_res;
	reg [31:0] WB_res;
	reg [31:0] WB_dmem_rdata;
	reg [5:0] DE_opcode;
	reg [5:0] EX_opcode;
	
   reg DE_jump;
   reg DE_dmemread;
   reg DE_dmemwrite;
   reg DE_regwrite;
   reg DE_memtoreg;
   reg DE_regdst;
   reg DE_alusrc;
   reg [1:0] DE_aluop;
	reg [5:0] DE_func;
	
   reg EX_jump;
   reg EX_dmemread;
   reg EX_dmemwrite;
   reg EX_regwrite;
   reg EX_memtoreg;
	
	reg WB_regwrite;
   reg WB_memtoreg;
	
	wire [1:0] ALUselA;
	wire [1:0] ALUselB;
	
	wire pcwrite;
	wire irwrite;
	wire stall;
	wire ppcwrite;
	
	reg bran;
	
	wire stallen;
	
	reg ID_bran;
	
	assign stallen = stall||bran||ID_bran;
	assign ppcwrite = pcwrite || bran;
	always @(posedge clk)
	begin
		//ID_addr <= next_pc;
		
		ID_instr <= imem_rdata;
		ID_jmpaddr <= imem_rdata[25:0];
		ID_bran <= bran;
		if(irwrite)
		begin
		ID_instr <= ID_instr;
		ID_jmpaddr <= ID_jmpaddr;
		ID_bran <= ID_bran;
		end
		
		//DE_addr <= ID_addr;
		DE_jmpaddr <= ID_jmpaddr;
		DE_imm_sext <= imm_sext;
		DE_reg_radata <= reg_radata;
		DE_reg_rbdata <= reg_rbdata;
		DE_rd <= rd;
		DE_rt <= rt;
		DE_rs <= rs;
		DE_opcode <= opcode;
		DE_func <= func;
		
		DE_jump <=jump & !stallen;
		DE_memtoreg <= memtoreg & !stallen;
		DE_regdst <= regdst & !stallen;
		DE_alusrc <= alusrc & !stallen;
		DE_aluop[1] <= aluop[0] & !stallen;
		DE_aluop[0] <= aluop[0] & !stallen;
		DE_dmemread <= init_dmemread & !stallen;
		DE_dmemwrite <= init_dmemwrite & !stallen;
		DE_regwrite <= init_regwrite & !stallen;
		
		EX_branchaddr <= branch_target_pc;
		EX_jumpaddr <= jump_target_pc;
		//EX_nextaddr <= DE_addr;
		EX_reg_rbdata <= inc;
		EX_wa <= wa;
		EX_res <= alu_res;
		EX_zero <= zero;
		EX_opcode <= DE_opcode;
		
		EX_jump <= bran? 0 : DE_jump;
		EX_dmemread <= bran? 0 : DE_dmemread;
		EX_dmemwrite <= bran? 0 : DE_dmemwrite;
		EX_regwrite <= bran? 0 : DE_regwrite;
		EX_memtoreg <= bran? 0 : DE_memtoreg;
		
		
		WB_wa <= EX_wa;
		WB_res <= EX_res;
		WB_dmem_rdata <= dmem_rdata;
		
		WB_regwrite <= EX_regwrite;
		WB_memtoreg <= EX_memtoreg;
	end
	
	// PC process
	always @(posedge clk)
	begin
		if(rst == 1)
		begin
			pc <= 32'b0;
			bran = 0;
		end
		else
			pc <= pc_d;
		if(ppcwrite)
			pc <= pc;
	end

  assign dmemread = EX_dmemread;
  assign dmemwrite = EX_dmemwrite;
  assign regwrite = WB_regwrite;	

  assign imemread = 1'b1;
  assign imemwrite = 1'b0;
  assign imem_addr = pc;
  assign imem_wdata = 32'b0;

  assign next_pc = pc + 32'd4;
  
	// IR Field Breakout
	assign opcode = ID_instr[31:26];
	assign rs = ID_instr[25:21];
	assign rt = ID_instr[20:16];
	assign rd = ID_instr[15:11];
	assign shamt = ID_instr[10:6];	
	assign func = ID_instr[5:0];
	assign imm = ID_instr[15:0];
	
	//assign jmpaddr = ID_instr[25:0];
	
	assign reg_ra = rs;
	assign reg_rb = rt;
	
	assign imm_sext = { {16{imm[15]}},imm};

	// Control Unit (state machine)
	ee457_scpu_cu ctrl_unit(
    .op(opcode),
    .func(func),
    .branch(branch),
    .jmp(jump),
    .mr(init_dmemread),
    .mw(init_dmemwrite),
    .regw(init_regwrite),
    .mtor(memtoreg),
    .rdst(regdst),
    .alusrc(alusrc),
    .aluop(aluop)
    );

	
	// Regfile instance
	ee457_regfile_2r1w regfile (
		.ra(reg_ra),
		.rb(reg_rb),
		.wa(WB_wa),
		.wdata(reg_wdata),
		.wen(WB_regwrite),
		.clk(clk),
		.rst(rst),
		.radata(reg_radata),
		.rbdata(reg_rbdata)
	);
	
	forwarding_unit forwarding_unit(
	.EX_MEM_regwrite(EX_regwrite),
	.EX_MEM_writereg(EX_wa),
	.ID_EX_reg1(DE_rs),
	.ID_EX_reg2(DE_rt),
	.MEM_WB_regwrite(WB_regwrite),
	.MEM_WB_writereg(WB_wa),
   .ALUselA(ALUselA),
   .ALUselB(ALUselB)
	);
	
	hd_unit hd_unit(
	.regwrite(DE_regwrite),
	.memtoreg(DE_memtoreg),
   .writert(DE_rt),
   .readreg1(rs),
   .readreg2(rt),
   .stall(stall),
   .pcwrite(pcwrite),
   .irwrite(irwrite)
	 );
	 

	assign ind = ALUselA[0] ? EX_res : DE_reg_radata;
	assign ina = ALUselA[1] ? reg_wdata : ind;
		
	assign ine = ALUselB[0] ? EX_res : DE_reg_rbdata;
	assign inc = ALUselB[1] ? reg_wdata : ine;
		

	assign imm_sext_sh2 = {DE_imm_sext[29:0],2'b0};
   assign branch_target_pc = DE_addr + imm_sext_sh2;
 	assign jump_target_pc = {DE_addr[31:28],DE_jmpaddr,2'b00};
 	
 	assign inb = DE_alusrc ? DE_imm_sext : inc;

  always @*
  begin
    if (DE_aluop == 2'b00)
      alu_func = FUNC_ADD;
    else if (DE_aluop == 2'b01)
      alu_func = FUNC_SUB;
    else
      alu_func = DE_func;
    
  end
 	
	// ALU instance
   ee457_alu alu (
		.opa(ina),
		.opb(inb),
		.func(alu_func),
    .res(alu_res), 
    .uov(), 
		.sov(sov),
    .zero(zero),
		.cout()
		);

  assign dmem_addr = EX_res;
  assign dmem_wdata = EX_reg_rbdata;
  
  always @*
  begin
    if(EX_opcode == OP_BEQ && EX_zero == 1 || EX_opcode == OP_BNE && EX_zero == 0)
		begin
	  pc_d = EX_branchaddr;
		bran = 1;
		end
    else if(EX_jump == 1)
      pc_d = EX_jumpaddr;
    else
      pc_d = next_pc;
  end

	assign reg_wdata = WB_memtoreg ? WB_dmem_rdata : WB_res;
	assign wa = DE_regdst ? DE_rd : DE_rt;
	assign reg_wa = WB_wa;
  	

endmodule

