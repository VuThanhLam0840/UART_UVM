//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class uart_tlm extends uvm_sequence_item;

 
  string   my_name;
  
  rand bit [7:0]  rx_data; // data sent to the DUT
  bit [7:0]  o_data;       // data output by the DUT
  rand bit do_reset;     // 1 = reset
  rand bit do_wait;      // 1 = wait
  rand bit [2:0] rx_data_pat_sel;
  event sample_e;

  `uvm_object_utils_begin(uart_tlm)
    `uvm_field_int(o_data,UVM_ALL_ON)
  `uvm_object_utils_end

  // P3 Todo: create a covergroup called cfg_cov_grp sampled on sample_e with the following bins:
  //       pat_0: all rx_data bits are 0
  //       pat_1: all rx_data bits are 1
  //       pat_01: rx_data is 8'h55
  //       pat_10: rx_data is 8'haa
  //       others[] : default
  covergroup cfg_cov_grp @(sample_e);
    coverpoint rx_data {
      bins pat_0  = {8'h00};
      bins pat_1  = {8'hff};
      bins pat_01 = {8'h55};
      bins pat_10 = {8'haa};
      bins others[] = default;
    }
  endgroup
  
  //
  // NEW
  //
  function new(string name = "uart_tlm");
    super.new(name);
    my_name = name;
    // P3 Todo: instantiate cfg_cov_grp
    cfg_cov_grp = new();
  endfunction
  
  //
  // Constraint block
  //
  constraint spi_c {
    do_reset == 0;
    do_wait == 0;
    rx_data_pat_sel inside {[0:4]};
    // P3 Todo: use keyword dist to constrain equal distribution of rx_data to the following
    //       0
    //       8'hff
    //       8'h55
    //       8'haa
    //       others
    rx_data_pat_sel dist {0 := 1, 1 := 1, 2 := 1, 3 := 1, 4 := 1};
    if (rx_data_pat_sel == 0) rx_data == 8'h00;
    if (rx_data_pat_sel == 1) rx_data == 8'hff;
    if (rx_data_pat_sel == 2) rx_data == 8'h55;
    if (rx_data_pat_sel == 3) rx_data == 8'haa;
    if (rx_data_pat_sel == 4) rx_data inside {[8'h01:8'h54], [8'h56:8'ha9], [8'hab:8'hfe]};
 	}
  
endclass
