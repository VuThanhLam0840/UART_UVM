//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class uart_slave_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(uart_slave_monitor #(PKT))
  
  string   my_name;
  
  virtual interface uart_if       vif;
	virtual interface clk_rst_if clk_rst_vif;

	uvm_analysis_port #(PKT) act_uart_ap;
 
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
    // P2 Todo: instantiate act_uart_ap
  endfunction
  
  //
  // CONNECT phase
  //
  function void connect_phase(uvm_phase phase);
    //
    // Getting the interface handle
    //
		if( !uvm_config_db #(virtual clk_rst_if)::get(this,"","CLK_RST_VIF",clk_rst_vif) ) begin
			`uvm_error(my_name, "Could not retrieve virtual clk_rst_if");
		end
    // P2 Todo: retrieve the handle to uart_if in vif. Refer top.sv
  endfunction
  
  //
	// Monitor and capture SPI data
  //
  task monitoring_data;
		PKT act_pkt;
    bit [7:0] temp_rx;
    
    forever @(negedge vif.uart_clk) begin
      // P2 Todo: if recognizing start bit
      // P2 Todo: capture 8 data bits
      // P2 Todo: verify the next bit is a stop bit. If not, issue an error
      // P2 Todo: wait for o_valid to assert. Time out after 10 clocks. 
      // P2 Todo: if o_valid is asserted, create act_pkt and assign vif.o_data to act_pkt.o_data
      // P2 Todo: send act_pkt to act_uart_ap
    end
  endtask

  //
  // RUN phase
  //
  task run_phase(uvm_phase phase);
  	monitoring_data();
  endtask
   
endclass
