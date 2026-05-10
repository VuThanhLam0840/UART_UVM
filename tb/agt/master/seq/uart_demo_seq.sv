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
	 for (int i = 0; i < 10; i++) begin
    // create packet
    req_pkt = REQ::type_id::create($sformatf("req_pkt_%0d", i));

    start_item(req_pkt);

    // randomize packet
    if (!req_pkt.randomize()) begin
      `uvm_error(my_name, "Randomization failed")
    end

    // trigger event (P3)
    -> req_pkt.sample_e;

    // send request
    finish_item(req_pkt);

    // get response
 //  get_response(rsp_pkt);
  end
  endtask
   
endclass
