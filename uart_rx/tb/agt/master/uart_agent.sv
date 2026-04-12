//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class uart_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

  `uvm_component_param_utils(uart_agent #(REQ,RSP))

  typedef uvm_sequencer #(REQ,RSP) uart_sequencer_t;
  typedef uart_driver #(REQ,RSP) uart_driver_t;

  uart_sequencer_t sequencer;
  uart_driver_t    driver;

  uvm_analysis_port #(REQ) ref_uart_ap;
   
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
   
  //
  // BUILD phase
  // Create sequencer and driver and port instances
  //
  function void build_phase(uvm_phase phase);
    // P1 Todo: instantiate the sequencer
    // P1 Todo: instantiate the driver
    // P2 Todo: instantiate ref_uart_ap for hierarchicall connection
  endfunction
   
  //
  // CONNECT phase
  // Connect sequencer and driver and driver ports
  //
  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
    // P2 Todo: connect the driver ref_uart_ap to the agent ref_uart_ap
  endfunction
   
endclass
