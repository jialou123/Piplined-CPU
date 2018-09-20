`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:00:26 04/06/2010
// Design Name:   ee457_scpu_tb
// Project Name:  ee457_scpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Testbench for module: ee457_smcpu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ee457_scpu_tb;

	// UUT Inputs
	wire [31:0] dmem_wdata;
	wire [31:0] dmem_rdata;
	wire [31:0] dmem_addr;
	wire        dmemread;
	wire        dmemwrite;
  
	wire [31:0] imem_wdata;
	wire [31:0] imem_rdata;
	wire [31:0] imem_addr;
	wire        imemread;
	wire        imemwrite;
	
	reg clk;
	reg rst;

	// UUT Outputs
	wire [4:0] reg_ra;
	wire [4:0] reg_rb;
	wire [4:0] reg_wa;
	wire [31:0] reg_radata;
	wire [31:0] reg_rbdata;
	wire [31:0] reg_wdata;
	wire regwrite;

	// Golden Model Signals
//	wire [31:0] mem_rdata_g;
//	wire [31:0] mem_addr_g;
//	wire [31:0] mem_wdata_g;
//	wire memread_g;
//	wire memwrite_g;
//	wire [4:0] reg_ra_g;
//	wire [4:0] reg_rb_g;
//	wire [4:0] reg_wa_g;
//	wire [31:0] reg_radata_g;
//	wire [31:0] reg_rbdata_g;
//	wire [31:0] reg_wdata_g;
//	wire regwrite_g;
//
//	reg  lw_flag;
	
	localparam OP_LW = 6'b100011;
	localparam OP_SW = 6'b101011;
	localparam OP_RTYPE = 6'b000000;
	localparam OP_BEQ = 6'b000100;
	localparam OP_BNE = 6'b000101;
	localparam OP_JMP = 6'b000010;
	localparam OP_ADDI = 6'b001000;
	localparam OP_JAL = 6'b000011;
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

	// Instantiate the Unit Under Test (UUT)
	ee457_scpu uut (
		.imem_addr(imem_addr), 
		.imem_rdata(imem_rdata), 
		.imem_wdata(imem_wdata), 
		.imemread(imemread), 
		.imemwrite(imemwrite), 
		.dmem_addr(dmem_addr), 
		.dmem_rdata(dmem_rdata), 
		.dmem_wdata(dmem_wdata), 
		.dmemread(dmemread), 
		.dmemwrite(dmemwrite), 
		.reg_ra(reg_ra), 
		.reg_rb(reg_rb), 
		.reg_wa(reg_wa), 
		.reg_radata(reg_radata), 
		.reg_rbdata(reg_rbdata), 
		.reg_wdata(reg_wdata), 
		.regwrite(regwrite), 
		.clk(clk), 
		.rst(rst)
	);

   ee457_mem #(.INIT_FILE("progmem.txt")) imem 
            (	.addr(imem_addr[9:2]), 
							.memread(imemread), 
							.memwrite(imemwrite), 
							.wdata(imem_wdata[31:0]),
							.clk(clk), 
							.rdata(imem_rdata[31:0])
						);

   ee457_mem #(.INIT_FILE("datamem.txt")) dmem 
            (	.addr(dmem_addr[9:2]), 
							.memread(dmemread), 
							.memwrite(dmemwrite), 
							.wdata(dmem_wdata[31:0]),
							.clk(clk), 
							.rdata(dmem_rdata[31:0])
						);

  always #5 clk = ~clk;
	
	initial begin
		// Initialize Inputs		clk = 0;
		clk = 0;
		rst = 1;
		#26;
		rst = 0;

		#1500;
        
		// Add stimulus here
		$stop();
	end
      
endmodule



