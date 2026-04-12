//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// Top level module. It is responsible for instantiating the dut and the interface modules. It also passes the
// interface handle using set_config_object.
//***************************************************************************************************************
 `timescale 1ns/1ps

import uvm_pkg::*;
import uart_test_pkg::*;

`include "uvm_macros.svh"

module top;
   
  wire clk;
  wire rst;
   
  //
  // Create interface instances here
  //
  clk_rst_if clk_rst_if0(.clk(clk),.rst(rst));
  uart_if uart_if0(.clk(clk),.rst(rst));
   
  //
  // Create DUT instance
  //
  receiver dut0(
    .i_Clock(clk),
    .i_Rx_Serial(uart_if0.rx_data),
    .o_Rx_DV(uart_if0.o_valid),
    .o_Rx_Byte(uart_if0.o_data)
  );

  initial begin
    // Put interface handles in resource database
    uvm_config_db #(virtual clk_rst_if)::set(null,"*","CLK_RST_VIF",clk_rst_if0);
    uvm_config_db #(virtual uart_if)::set(null,"*","UART_VIF",uart_if0);

    // Run test
    run_test();
  end

endmodule
