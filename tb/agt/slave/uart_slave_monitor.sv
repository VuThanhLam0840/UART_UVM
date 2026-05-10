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
    act_uart_ap = new("act_uart_ap", this);
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
    if( !uvm_config_db #(virtual uart_if)::get(this,"","UART_VIF",vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual uart_if");
    end
  endfunction
  
  //
	// Monitor and capture SPI data
  //
  task monitoring_data;
		PKT act_pkt;
    bit [7:0] temp_rx;
    bit       valid_seen;
    bit       stop_bit_ok;
    bit       prev_rx;
    int       timeout_clk_cycles;
    
    timeout_clk_cycles = 120;
    prev_rx = 1'b1;

    forever @(negedge vif.uart_clk) begin
      if ((prev_rx == 1'b1) && (vif.rx_data == 1'b0)) begin
        for (int ii = 0; ii < 8; ii++) begin
          @(negedge vif.uart_clk);
          temp_rx[ii] = vif.rx_data;
        end

        valid_seen = 1'b0;
        stop_bit_ok = 1'b1;
        fork
          begin : wait_for_o_valid
            for (int ii = 0; ii < timeout_clk_cycles; ii++) begin
              @(posedge vif.clk);
              if (vif.o_valid) begin
                valid_seen = 1'b1;
                break;
              end
            end
          end

          begin : check_stop_bit
            @(negedge vif.uart_clk);
            if (vif.rx_data != 1'b1) begin
              stop_bit_ok = 1'b0;
              `uvm_error(my_name, "Stop bit was not high")
            end
          end
        join

        prev_rx = vif.rx_data;

        if (!stop_bit_ok) begin
          continue;
        end

        if (!valid_seen) begin
          `uvm_error(my_name,
                     $psprintf("Timed out waiting for o_valid after RX=0x%0h after %0d clk cycles",
                               temp_rx, timeout_clk_cycles))
          continue;
        end

        act_pkt = PKT::type_id::create($psprintf("act_pkt_%0t", $time), this);
        act_pkt.o_data = vif.o_data;
        act_uart_ap.write(act_pkt);
        prev_rx = 1'b1;
      end else begin
        prev_rx = vif.rx_data;
      end
    end
  endtask

  //
  // RUN phase
  //
  task run_phase(uvm_phase phase);
  	monitoring_data();
  endtask
   
endclass
