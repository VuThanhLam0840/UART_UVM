//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// The test package provides a test layer between the top module and the environment. More than
// one test can be included here.
//***************************************************************************************************************
package uart_test_pkg;

   import uvm_pkg::*;
   import uart_env_pkg::*;
   import uart_tlm_pkg::*;
   import uart_seq_pkg::*;
   import uart_cfg_pkg::*;
   
   `include "uvm_macros.svh"  
   //
   // All new tests must derive from base_test and must be listed here.
   // Each test is saved as one file
   //
   `include "uart_demo_test.sv"       // single sequence test
   // X Todo: include uart_err_test.sv
endpackage
