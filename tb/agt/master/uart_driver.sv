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

  uart_cfg cfg;
 
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
    ref_uart_ap = new("ref_uart_ap", this);
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
    if (!uvm_config_db #(uart_cfg)::get(this,"","UART_CFG",cfg)) begin
      `uvm_fatal(my_name, "Could not retrieve uart_cfg")
    end
  endfunction
 
  //
  // RUN phase
  //
  virtual task run_phase(uvm_phase phase);
    REQ req_pkt;
    RSP rsp_pkt;
    integer rsp_pkt_cnt;
    bit [9:0] out_data;
    bit [7:0] tx_data;
    
    rsp_pkt_cnt = 1;
   forever begin
  seq_item_port.get_next_item(req_pkt);

  @(posedge vif.clk); // clock sau khi lấy item

  if (req_pkt.do_reset == 1) begin
    clk_rst_vif.do_reset(5);
    `uvm_info(my_name,"I saw reset assertion",UVM_NONE)

  end else if (req_pkt.do_wait == 1) begin
    clk_rst_vif.do_wait(5);

  end else begin
    `uvm_info(my_name,$psprintf("Sending rx_data=%0x",req_pkt.rx_data),UVM_NONE)

    tx_data = req_pkt.rx_data;
    if (cfg.inject_err) begin
      tx_data ^= 8'h01;
      `uvm_info(my_name,
                $psprintf("Injecting error: tx_data=%0x ref_data=%0x", tx_data, req_pkt.rx_data),
                UVM_NONE)
    end

    out_data = {1'b1, tx_data, 1'b0};

    for (int ii=0; ii<10; ii++) begin
      @(posedge vif.uart_clk);
      vif.rx_data <= out_data[ii];
    end

    ref_uart_ap.write(req_pkt);
  end

  rsp_pkt_cnt++;
  rsp_pkt = RSP::type_id::create($psprintf("rsp_pkt_id_%d",rsp_pkt_cnt));
  rsp_pkt.set_id_info(req_pkt);
  rsp_pkt.copy(req_pkt);

  seq_item_port.item_done();
end
  endtask

endclass
  
