//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class uart_driver #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_driver #(REQ,RSP);

  `uvm_component_param_utils(uart_driver #(REQ,RSP))

  string   my_name;
  
  virtual interface uart_if vif;
  virtual interface clk_rst_if clk_rst_vif;

  uvm_analysis_port #(REQ) ref_uart_ap;

  // X Todo: declare a uart_cfg handle named cfg
 
  //
  // NEW
  //
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction
  
  //
  // BUILD phase
  //
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // P2 Todo: instantiate ref_uart_ap 
  endfunction

  //
  // CONNECT phase
  //
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    my_name = get_name();
    // Get a handle to clk_rst_if
    if( !uvm_config_db #(virtual clk_rst_if)::get(this,"","CLK_RST_VIF",clk_rst_vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual clk_rst_if");
    end     
    //
    // Getting the interface handle via get_config_object call
    //
    if( !uvm_config_db #(virtual uart_if)::get(this,"","UART_VIF",vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual uart_if");
    end
    //
    // X Todo: use uvm_config_db get to retrieve the uart_cfg in cfg
  endfunction
 
  //
  // RUN phase
  //
  virtual task run_phase(uvm_phase phase);
    REQ req_pkt;
    RSP rsp_pkt;
    integer rsp_pkt_cnt;
    bit [9:0] out_data;
    
    rsp_pkt_cnt = 1;
    forever @(posedge vif.clk) begin
      //
      // seq_item_port object is part of the uvm_driver class
      // get_next_item method is part of the interface api between uvm_driver and uvm_sequencer
      //
      seq_item_port.get_next_item(req_pkt);
      if (req_pkt.do_reset == 1) begin
        // Packet is reset
      	clk_rst_vif.do_reset(5);
        `uvm_info(my_name,"I saw reset assertion",UVM_NONE)
			end else if (req_pkt.do_wait == 1) begin
        // Packet is wait
				clk_rst_vif.do_wait(5);
			end else begin
        `uvm_info(my_name,$psprintf("Sending rx_data=%0x",req_pkt.rx_data),UVM_NONE)
        ref_uart_ap.write(req_pkt); // Send reference data to the scoreboard
        // P2 Todo: send req_pkt to the scoreboard by calling write function
        // Form the data to send
        // Stop bit: rx_data: Start bit, LSB first
        out_data = {1'b1, req_pkt.rx_data, 1'b0};
        // X Todo: if inject_err==1, invert the value in rx_data: rx_data^8'hff
        for (int ii=0; ii<10; ii++) begin
          @(posedge vif.uart_clk);
          vif.rx_data <= out_data[ii];
        end
		  end
      
      // Send response packet back to the sequence
      rsp_pkt_cnt++;
      rsp_pkt = RSP::type_id::create($psprintf("rsp_pkt_id_%d",rsp_pkt_cnt));
      rsp_pkt.set_id_info(req_pkt);
      rsp_pkt.copy(req_pkt);
      seq_item_port.item_done(rsp_pkt);
    end
  endtask

endclass
  
