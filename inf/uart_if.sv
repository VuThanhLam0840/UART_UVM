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
    rx_data  = 1'b1;   // UART RX line idles high
    uart_clk = 1'b1;   // Initialize uart_clk to 1

    forever begin
      // BAUD rate : 115200
      // CLK       : 10 MHz  → period = 100 ns
      // Periods per bit     : 88
      // uart_clk half-period: 88 * 100ns / 2 = 4400 ns
      #4400 uart_clk = ~uart_clk;
    end
  end

endinterface
