//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class uart_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_env;

   `uvm_component_param_utils(uart_env #(REQ,RSP))
   
   string my_name;
   
   typedef uart_agent  #(REQ,RSP) uart_agent_t;
   uart_agent_t uart_agent_0;
   typedef uart_slave_agent  #(REQ) uart_slave_agent_t;
   uart_slave_agent_t uart_slave_agent_0;
   typedef sb  #(REQ) sb_t;
   sb_t sb_0;
   
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
      uart_agent_0 = uart_agent_t::type_id::create("uart_agent_0", this);
      uart_slave_agent_0 = uart_slave_agent_t::type_id::create("uart_slave_agent_0", this);
      sb_0 = sb_t::type_id::create("sb_0", this);
   endfunction
   
   //
   // CONNECT phase
   //
   function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    uart_agent_0.driver.ref_uart_ap.connect(sb_0.ref_ap_fifo.analysis_export);
    uart_slave_agent_0.act_uart_ap.connect(sb_0.act_ap_fifo.analysis_export);
   endfunction
   
endclass
