#==========================================================================================
# Author: Van Le
# vanleatwork@yahoo.com
# Phone: VN: 0396221156, US: 5125841843
#
# To run simulation in a sim directory, must run the following
#   source env.sh
#   cd sim
#
# To compile for the UART TB:
#   make compile_uart
#
# To run UART demo test using Siemens Questa tool:
#   make coverage test_name=uart_demo_test
#   vcover dump top.ucdb > log
#   make vopt_gui test_name=uart_demo_test
#   make vopt_run test_name=uart_demo_test
#   make vis_run test_name=uart_demo_test cmd_args=10
#
# To run UART demo test using Cadence tool:
#   make compile_uart tool=Cadence
#   make run test_name=uart_demo_test tool=Cadence
#   make coverage test_name=uart_demo_test tool=Cadence
# To dump UCD file using Cadence tool:
#   imc -gui
#     merge test1 test2 -out all
#     load -run all
#     report -html/detailsummary-metrics -out path
#   Maybe the command line version
#     imc -execcmd "merge test1 test2 -out all"
#
# To run UART demo test using Synopsys tool:
# UVM_HOME = ../uvm-src/uvm-1.1d
# UVM_VERBOSITY = UVM_MEDIUM
# TEST = simpleadder_test
#
# VCS =	vcs -sverilog -timescale=1ns/1ns \
# 	+acc +vpi -PP \
# 		+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
# 			+incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv \
# 				-cm line+cond+fsm+branch+tgl -cm_dir ./coverage.vdb \
# 					$(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS
#
# SIMV = ./simv +UVM_VERBOSITY=$(UVM_VERBOSITY) \
# 	+UVM_TESTNAME=$(TEST) +UVM_TR_RECORD +UVM_LOG_RECORD \
# 		+verbose=1 +ntb_random_seed=244 -l vcs.log
#
# comp:
# 	$(VCS) +incdir+. simpleadder_tb_top.sv
#
# run:
# 	$(SIMV)
#==========================================================================================
#
# make must be run where in the same directory as Makefile
#
#
# To override the test name, use the command line argument: test_name=<test_name>
#
test_name = demo_test
cmd_args ?= 
tool = DEFAULT
TOP = top
VOPT_TOP = vopt_top
VSIM_CMD = vsim
VOPT_CMD = vopt +acc ${TOP} -o ${VOPT_TOP} +designfile

#
# To override default values in `define, specify a file name with: 
#         make defines=<file name>
#
ifeq (${tool},DEFAULT)
	VLOG_CMD = vlog 
else
	VLOG_CMD = xrun -c -uvm
endif

DUT_DIR = $(UART_TB_DIR)/dut
IF_DIR = $(UART_TB_DIR)/inf
UART_IF_DIR = $(UART_TB_DIR)/inf
TB_DIR  = $(UART_TB_DIR)/tb
SIM_DIR = $(UART_TB_DIR)/sim
AGT_MASTER  = $(TB_DIR)/agt/master
AGT_SLAVE  = $(TB_DIR)/agt/slave
TLM_DIR = $(TB_DIR)/tlm
CFG_DIR = $(TB_DIR)/cfg
CHK_DIR = $(TB_DIR)/chk
COV_DIR = $(TB_DIR)/cov
ENV_DIR = $(TB_DIR)/env
TST_DIR = $(TB_DIR)/tst

ifeq (${tool},DEFAULT)
compile_uart: setup_questa inf dut tlm cfg seq agt chk env tst top vopt
else
compile_uart: inf dut tlm cfg seq agt chk env tst top 
endif

setup_questa:
	@if [ ! -d work ]; then vlib work; fi
	@vmap work work

ifeq (${tool},DEFAULT)
top:
		${VLOG_CMD} -sv $(ENV_DIR)/top.sv
else
top:
		${VLOG_CMD} $(ENV_DIR)/top.sv
endif
udf:
	${VLOG_CMD} +incdir+$(ENV_DIR) $(ENV_DIR)/udf_pkg.svh
dut:
	${VLOG_CMD} +incdir+$(DUT_DIR) $(DUT_DIR)/receiver.v
inf:
	${VLOG_CMD} +incdir+$(ENV_DIR) $(UART_IF_DIR)/clk_rst_if.sv
	${VLOG_CMD} +incdir+$(ENV_DIR) $(UART_IF_DIR)/uart_if.sv
tlm:
	${VLOG_CMD} +incdir+$(TLM_DIR) +incdir+$(ENV_DIR) $(TLM_DIR)/uart_tlm_pkg.svh
cfg:
	${VLOG_CMD} +incdir+$(CFG_DIR) $(CFG_DIR)/uart_cfg_pkg.svh
seq:
	${VLOG_CMD} +incdir+$(AGT_MASTER)/seq +incdir+$(ENV_DIR) $(AGT_MASTER)/seq/uart_seq_pkg.svh
agt:
	${VLOG_CMD} +incdir+$(AGT_MASTER) +incdir+$(ENV_DIR) $(AGT_MASTER)/uart_agent_pkg.svh
	${VLOG_CMD} +incdir+$(AGT_SLAVE) +incdir+$(ENV_DIR) $(AGT_SLAVE)/uart_slave_agent_pkg.svh
chk:
	${VLOG_CMD} +incdir+$(TLM_DIR) +incdir+$(ENV_DIR) +incdir+$(CHK_DIR) $(CHK_DIR)/uart_chk_pkg.svh
cov:
env:
	${VLOG_CMD} +incdir+$(ENV_DIR) $(ENV_DIR)/uart_env_pkg.svh
tst:
	${VLOG_CMD} +incdir+$(ENV_DIR) +incdir+$(TST_DIR) $(TST_DIR)/uart_test_pkg.svh
vopt:
	${VOPT_CMD}
vopt_run:
	${VSIM_CMD} -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} ${cmd_args}
vopt_random:
	${VSIM_CMD} -sv_seed random -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} ${cmd_args}
vopt_gui:
	${VSIM_CMD} ${VOPT_TOP} +UVM_TESTNAME=${test_name} 
ifeq (${tool},DEFAULT)
run:
	${VSIM_CMD} -c top -do sim.do +UVM_TESTNAME=${test_name}
else
run:
	xrun -uvm -top worklib.top +UVM_TESTNAME=${test_name}
endif
run_override:
	${VSIM_CMD} -c top +UVM_TESTNAME=$(type_override_test)
	
ifeq (${tool},DEFAULT)
coverage:
	${VSIM_CMD} -c -sv_seed random -coverage ${VOPT_TOP} -do cov.do +UVM_TESTNAME=${test_name}
else
coverage:
	xrun -uvm -top worklib.top -coverage u +UVM_TESTNAME=${test_name}
endif	
wave:
	${VSIM_CMD} -voptargs="+acc" $(TOP} +UVM_TESTNAME=${test_name}

vis_run:
	${VSIM_CMD} -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} +NUM_WRITE=${cmd_args} -qwavedb=+signal+class

clean:
	rm -rf  *.wlf *.ucdb transcript work design.* xrun.* xcelium.d cov_work imc.* mdv.log

tar:
	rm -rf  *.wlf log transcript work
	tar cvf ../uvm_tb.tar ../*
	
