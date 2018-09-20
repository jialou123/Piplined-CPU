`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:43:37 06/25/2018 
// Design Name: 
// Module Name:    hd_unit 
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
module hd_unit(
    input regwrite,
    input memtoreg,
    input [4:0] writert,
    input [4:0] readreg1,
    input [4:0] readreg2,
    output stall,
    output pcwrite,
    output irwrite
    );
	  reg s;
	  always@*
	  begin
	  if(regwrite && memtoreg && ((writert==readreg1) || (writert==readreg2)))
	  s = 1;
	  else
	  s = 0;
	  end
	 assign stall = s;
	 assign pcwrite = s;
	 assign irwrite = s;

endmodule
