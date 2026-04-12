//***************************************************************************************************************
// Clock and reset module
//***************************************************************************************************************
`timescale 1ns/1ps

interface uart_if (input logic clk, input logic rst);

  logic uart_clk;
  logic rx_data;
  wire  o_valid;
  wire [7:0] o_data;

  // Generate uart_clk to be used to send rx_data
	initial begin
    // Todo: initialize rx_data to 0
		// Todo: initialize uart_clk to 1
		forever begin
      // The BAUD rate is 115200
      // The clk 10Mhz
      // clk periods per bit is 88
      // Todo: generate the uart_clk
		end
	end

endinterface
