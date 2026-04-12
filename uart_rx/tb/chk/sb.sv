//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************

//============================================================================================================================
// Scoreboard responsible for data checking
//============================================================================================================================
class sb #(type REQ = uvm_sequence_item) extends uvm_scoreboard;

	`uvm_component_param_utils(sb #(REQ))
  
	uvm_tlm_analysis_fifo #(REQ) ref_ap_fifo; // reference data 
	uvm_tlm_analysis_fifo #(REQ) act_ap_fifo; // actual data 
  string  my_name;

  // X Todo: declare a uart_cfg handle named cfg
  
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
    // P2 Todo: instantiate ref_ap_fifo
    // P2 Todo: instantiate act_ap_fifo
	endfunction

  //
  // CONNECT phase
  //
	function void connect_phase(uvm_phase phase);
    // X Todo: use uvm_config_db::get to obtain the handle to uart_cfg
  endfunction

  //
  // CHECK phase
  //
	function void check_phase(uvm_phase phase);
    // At the end of simulation, if there are any packets left in the ref_ap_fifo, then
    // it is an error condition
    if (ref_ap_fifo.used() > 0) begin
      `uvm_error(my_name,$psprintf("ref_ap_fifo is not empty : %0d",ref_ap_fifo.used()))
    end
	endfunction

  //
  // RUN phase
  //
  task run_phase(uvm_phase phase);
		REQ ref_pkt;
		REQ act_pkt;

		forever begin
      // P2 Todo: get the next actual packet from the act_ap_fifo by calling get

      // P2 Todo: verify that the ref_ap_fifo is not empty, otherwise issue an fatal error
      // P2 Todo: get the next reference packet from the ref_ap_fifo by calling get
      // P2 Todo: perform comparison between the rx_data in the reference packet against the o_data in actual packet
      // P2 Todo: print match/mismatch message
      // X Todo: if inject_err==0, perform comparison as in the above two lines
      // X Todo: if inject_err==1, verify that the comparison fails as expected
		end
	endtask

endclass
