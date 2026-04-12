//***************************************************************************************************************
// Clock and reset module
//***************************************************************************************************************
`timescale 1ns/1ps

interface clk_rst_if (output logic clk, output logic rst);
// pragma attribute clk_rst_if partition_interface_xif

  //
  // Task to assert rst by a number of clocks given in reset_length
  //
	task do_reset (integer reset_length); // pragma tbx xtf
		rst = 0;
		repeat (reset_length) @(posedge clk);
		rst = 1;
	endtask

  //
  // Task to wait a num number of clocks
  //
	task do_wait(integer num);
		repeat (num) @(posedge clk);
	endtask
	
  //
  // Generate 10MHz clk
  //
	initial begin
		#1;
		clk = 1;
		rst = 0;
		forever begin
			#5 clk = ~clk;
		end
	end

endinterface
