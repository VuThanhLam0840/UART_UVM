//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// A demo test case.
//***************************************************************************************************************
class uart_demo_test extends uvm_test;

	`uvm_component_utils(uart_demo_test)
	
	string	my_name;
	
  typedef uart_demo_seq #(uart_tlm,uart_tlm) uart_demo_seq_t;
  uart_demo_seq_t uart_demo_seq;
  typedef uart_env #(uart_tlm,uart_tlm) env_t;
  env_t env_h;
  // X Todo: declare a uart_cfg variable named cfg
  
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
    // P1 Todo: instantiate the environment class
    // P1 Todo: instantiate the demo sequence
    // X Todo: instantiate cfg
    // X Todo: use uvm_config_db set to place the cfg handle in the resource database
	endfunction
  
  //
  // RUN phase
  //
	task run_phase(uvm_phase phase);

    // When the last transaction is sent, this drain time allows the transfer
    // to complete before simulation ends
    uvm_test_done.set_drain_time(this,10us);

    `uvm_info(my_name,"Raising objection",UVM_NONE)
    phase.raise_objection(this,"Objection raised by uart_demo_test");
    
    // P1 Todo: start the demo sequence
   	uart_demo_seq.start(env_h.uart_agent_0.sequencer,null);

    `uvm_info(my_name,"Dropping objection",UVM_NONE)
    phase.drop_objection(this,"Objection dropped by uart_demo_test");
	endtask
	
endclass
