//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class uart_slave_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

  `uvm_component_param_utils(uart_slave_agent #(REQ,RSP))
  
  string   my_name;

  typedef uart_slave_monitor #(REQ) uart_slave_monitor_t;
  uart_slave_monitor_t    monitor;
 
  uvm_analysis_port #(REQ) act_uart_ap;  // This port is used to send coverage data
 
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
    // P2 Todo: instantiate act_uart_ap for hierarchical connection
  endfunction
  
  //
  // BUILD phase
  //
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // P2 Todo: instantiate the monitor
  endfunction
  
  //
  // CONNECT phase
  //
  function void connect;
    // P2 Todo: connect the monitor act_uart_ap to the agent act_uart_ap
  endfunction
  
endclass
