//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class uart_demo_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

  `uvm_object_param_utils(uart_demo_seq #(REQ,RSP))
  
  string my_name;
   
  //
  // NEW
  //
  function new(string name="");
    super.new(name);
		my_name = name;
  endfunction

  //
	// Start the transmission max_loop times. Each time num_chars of bits are transmitted
  //
  task body;
    REQ req_pkt;
    RSP rsp_pkt;

    // P1 Todo: implement a for loop that sends 10 packets. Each loop executes the following pseudo code
    //          - create the packet
    //          - randomize the packet
    //          - for P3, trigger event req_pkt.sample_e
    //          - send the req_pkt
    //          - get the response
  endtask
   
endclass
