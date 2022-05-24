# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# Base Configurations. Don't Touch
# section begin

set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

# YOU ARE NOT ALLOWED TO CHANGE ANY VARIABLES DEFINED IN THE FIXED WRAPPER CFGS 
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper/fixed_wrapper_cfgs.tcl

# YOU CAN CHANGE ANY VARIABLES DEFINED IN THE DEFAULT WRAPPER CFGS BY OVERRIDING THEM IN THIS CONFIG.TCL
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper/default_wrapper_cfgs.tcl

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_project_wrapper
#section end
set ::env(BASE_SDC_FILE) /home/serdar/Desktop/openram_demo/openram_openmpw/openlane/user_project_wrapper/base.sdc

# User Configurations

## Source Verilog Files
set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

## Clock configurations
set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_NET) "mprj.wb_clk_i"

set ::env(CLOCK_PERIOD) "16"

### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/gl/openram_demo.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/openram_demo.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/openram_demo.gds"

# set ::env(GLB_RT_MAXLAYER) 5
# met5 ile route edince DRC çıktı
set ::env(RT_MAX_LAYER) {met4}

# disable pdn check nodes becuase it hangs with multiple power domains.
# any issue with pdn connections will be flagged with LVS so it is not a critical check.

set ::env(VDD_NETS) "vccd1 vccd2 vdda1 vdda2"
set ::env(GND_NETS) "vssd1 vssd2 vssa1 vssa2"

##################################################################
# Flow Control
##################################################################
set ::env(RUN_ROUTING_DETAILED) 1
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1
set ::env(TAP_DECAP_INSERTION) 1
set ::env(LEC_ENABLE) 0
set ::env(FILL_INSERTION) 1
set ::env(RUN_KLAYOUT_DRC) 0
set ::env(RUN_MAGIC_DRC) 0
set ::env(KLAYOUT_DRC_KLAYOUT_GDS) 0

##################################################################
# Synthesis
##################################################################
set ::env(SYNTH_STRATEGY) {AREA 1}
set ::env(SYNTH_MAX_FANOUT) 5
set ::env(SYNTH_TOP_LEVEL) 1

##################################################################
# Floorplan
##################################################################
set ::env(FP_PDN_ENABLE_RAILS) 1
set ::env(FP_PDN_ENABLE_MACROS_GRID) 1
set ::env(FP_PDN_CHECK_NODES) 1
## Internal Macros
### Macro PDN Connections
# Harness area 2.92mm x 3.52mm
set ::env(FP_PDN_MACRO_HOOKS) "\
	mprj vccd1 vssd1"

##################################################################
# Placement
##################################################################
set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_RANDOM_GLB_PLACEMENT) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 1
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 1
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 1
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0

##################################################################
# CTS
##################################################################
set ::env(CLOCK_TREE_SYNTH) 1
set ::env(CLOCK_BUFFER_FANOUT) 5
set ::env(CTS_SINK_CLUSTERING_SIZE) 8

##################################################################
# Global Routing
##################################################################
set ::env(GLB_RT_ANT_ITERS) 20
set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 20
set ::env(GLOBAL_ROUTER) fastroute

##################################################################
# Antenna Diodes Insertion
##################################################################
set ::env(DIODE_PADDING) 2
set ::env(DIODE_INSERTION_STRATEGY) 3

##################################################################
# Detailed Routing
##################################################################
set ::env(DRT_OPT_ITERS) 10
set ::env(ROUTING_CORES) 8
set ::env(DETAILED_ROUTER) tritonroute

##################################################################
# Physical Verification
##################################################################
set ::env(MAGIC_DRC_USE_GDS) 1

##################################################################
# Checkers
##################################################################
set ::env(QUIT_ON_LVS_ERROR) 0
set ::env(QUIT_ON_MAGIC_DRC) 0
set ::env(QUIT_ON_TR_DRC) 0