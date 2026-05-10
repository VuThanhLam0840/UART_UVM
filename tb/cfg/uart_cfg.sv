//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class uart_cfg extends uvm_object;

  `uvm_object_utils(uart_cfg)

  bit inject_err;
  
  //
  // NEW
  //
  function new(string name = "");
    super.new(name);
    inject_err = 1'b0;
  endfunction

  
endclass
