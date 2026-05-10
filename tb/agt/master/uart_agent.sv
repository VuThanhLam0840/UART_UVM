class uart_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

  `uvm_component_param_utils(uart_agent #(REQ,RSP))

  typedef uvm_sequencer #(REQ,RSP) uart_sequencer_t;
  typedef uart_driver #(REQ,RSP) uart_driver_t;

  uart_sequencer_t sequencer;
  uart_driver_t    driver;

  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
   
  //
  // BUILD phase
  //
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // P1: instantiate sequencer
    sequencer = uart_sequencer_t::type_id::create("sequencer", this);

    // P1: instantiate driver
    driver = uart_driver_t::type_id::create("driver", this);
  endfunction
   
  //
  // CONNECT phase
  //
  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
   
endclass
