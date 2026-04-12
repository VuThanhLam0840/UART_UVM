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
  
  //
  // NEW
  //
  function new(string name = "uart_tlm");
    super.new(name);
    my_name = name;
    // P3 Todo: instantiate cfg_cov_grp
  endfunction
  
  //
  // Constraint block
  //
  constraint spi_c {
    do_reset == 0;
    do_wait == 0;
    // P3 Todo: use keyword dist to constrain equal distribution of rx_data to the following
    //       0
    //       8'hff
    //       8'h55
    //       8'haa
    //       others
 	}
  
endclass
