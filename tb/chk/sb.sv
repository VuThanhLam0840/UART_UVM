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

  uart_cfg cfg;
  
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
    ref_ap_fifo = new("ref_ap_fifo", this);
    act_ap_fifo = new("act_ap_fifo", this);
	endfunction

  //
  // CONNECT phase
  //
	function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db #(uart_cfg)::get(this,"","UART_CFG",cfg)) begin
      `uvm_fatal(my_name, "Could not retrieve uart_cfg")
    end
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
      act_ap_fifo.get(act_pkt);

      if (ref_ap_fifo.is_empty()) begin
        `uvm_fatal(my_name, "Reference FIFO is empty while actual data arrived")
      end

      ref_ap_fifo.get(ref_pkt);
      if (!cfg.inject_err) begin
        if (ref_pkt.rx_data == act_pkt.o_data) begin
          `uvm_info(my_name,
                    $psprintf("MATCH ref_rx_data=0x%0h act_o_data=0x%0h", ref_pkt.rx_data, act_pkt.o_data),
                    UVM_NONE)
        end else begin
          `uvm_error(my_name,
                     $psprintf("MISMATCH ref_rx_data=0x%0h act_o_data=0x%0h", ref_pkt.rx_data, act_pkt.o_data))
        end
      end else begin
        if (ref_pkt.rx_data != act_pkt.o_data) begin
          `uvm_info(my_name,
                    $psprintf("EXPECTED MISMATCH ref_rx_data=0x%0h act_o_data=0x%0h",
                              ref_pkt.rx_data, act_pkt.o_data),
                    UVM_NONE)
        end else begin
          `uvm_error(my_name,
                     $psprintf("Unexpected match during error injection ref_rx_data=0x%0h act_o_data=0x%0h",
                               ref_pkt.rx_data, act_pkt.o_data))
        end
      end
		end
	endtask

endclass
