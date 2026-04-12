//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// An error injection test case.
//***************************************************************************************************************
class uart_err_test extends uart_demo_test;

	`uvm_component_utils(uart_err_test)
	
	string	my_name;
	
  //
  // NEW
  //
	function new(string name, uvm_component parent);
		super.new(name,parent);
		my_name = name;
	endfunction
	
  //
  // BUILD phase
  //
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
  
  //
  // CONNECT phase
  //
	function void connect_phase(uvm_phase phase);
		// X Todo: assign inject_err to 1
	endfunction
  
endclass
