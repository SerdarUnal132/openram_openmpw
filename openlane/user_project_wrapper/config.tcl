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

proc listFromFile {filename} {
    set f [open $filename r]
    set data [split [string trim [read $f]]]
    close $f
    return $data
}

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
set ::env(CLOCK_NET) "clk"

set ::env(CLOCK_PERIOD) "20"

### Macro Placement
# makroları management area'dan uzak koyunca max slew & setup violation çıkıyor
# aralarını açmak da iyi oldu, üstünden geçemeyince setup violation çıkıyordu
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	/home/serdar/pdks/sky130A/libs.ref/sky130_sram_macros/verilog/sky130_sram_2kbyte_1rw1r_32x512_8.v"
# SRAM is 
set ::env(EXTRA_LEFS) " \
	/home/serdar/pdks/sky130A/libs.ref/sky130_sram_macros/lef/sky130_sram_2kbyte_1rw1r_32x512_8.lef"

set ::env(EXTRA_GDS_FILES) "\
	/home/serdar/pdks/sky130A/libs.ref/sky130_sram_macros/gds/sky130_sram_2kbyte_1rw1r_32x512_8.gds"

# set ::env(GLB_RT_MAXLAYER) 5
# met5 ile route edince DRC çıktı
set ::env(DRT_MAX_LAYER) {met4}
set ::env(RT_MAX_LAYER) {met4}

# disable pdn check nodes becuase it hangs with multiple power domains.
# any issue with pdn connections will be flagged with LVS so it is not a critical check.

# set ::env(VDD_NETS) "vccd1 vccd2 vdda1 vdda2"
# set ::env(GND_NETS) "vssd1 vssd2 vssa1 vssa2"

set ::env(VDD_PIN) "VPWR VPB vccd1"                                                                                                                                                                                                                                                                                                                                                                
set ::env(GND_PIN) "VGND VNB vssd1"  

##################################################################
# Flow Control
##################################################################
set ::env(RUN_ROUTING_DETAILED) 1
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 0
set ::env(RUN_LVS) 1
set ::env(TAP_DECAP_INSERTION) 1
set ::env(LEC_ENABLE) 0
set ::env(FILL_INSERTION) 1
set ::env(RUN_KLAYOUT_DRC) 0
set ::env(RUN_MAGIC_DRC) 0
set ::env(KLAYOUT_DRC_KLAYOUT_GDS) 0
set ::env(TAKE_LAYOUT_SCROT) 0

##################################################################
# Synthesis
##################################################################
set ::env(SYNTH_STRATEGY) {AREA 1}
set ::env(SYNTH_MAX_FANOUT) 5
set ::env(SYNTH_MIN_BUF_PORT) {sky130_fd_sc_hd__buf_4 A X}
# set ::env(SYNTH_TOP_LEVEL) 1

##################################################################
# Floorplan
##################################################################
set ::env(FP_CORE_UTIL) 18
set ::env(DESIGN_IS_CORE) 1
set ::env(FP_PDN_ENABLE_RAILS) 1
set ::env(FP_PDN_ENABLE_MACROS_GRID) 1
set ::env(FP_PDN_CHECK_NODES) 1
# shift in ring gives xor violation
set ::env(FP_PDN_CORE_RING_VOFFSET) 12.45
set ::env(FP_PDN_CORE_RING_HOFFSET) $::env(FP_PDN_CORE_RING_VOFFSET)
# set ::env(FP_PDN_VPITCH) 100
# decrease li density, increase li clear area density, by using ef decap cell
set ::env(DECAP_CELL) "\
	sky130_fd_sc_hd__decap_3 \
	sky130_fd_sc_hd__decap_4 \
	sky130_fd_sc_hd__decap_6 \
	sky130_fd_sc_hd__decap_8 \
	sky130_fd_sc_hd__decap_12"
## Internal Macros
### Macro PDN Connections
# Harness area 2.92mm x 3.52mm
set ::env(FP_PDN_MACRO_HOOKS) "SRAM0 vccd1 vssd1, \
							   SRAM1 vccd1 vssd1, \
							   SRAM2 vccd1 vssd1, \ 
							   SRAM3 vccd1 vssd1"

##################################################################
# Placement
##################################################################
set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) 0.18
set ::env(PL_RANDOM_GLB_PLACEMENT) 0
set ::env(PL_TIME_DRIVEN) 1
set ::env(PL_ROUTABILITY_DRIVEN) 1
set ::env(PL_MAX_DISPLACEMENT_X) 800
set ::env(PL_MAX_DISPLACEMENT_Y) 600
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 1
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 1
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 1
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 1
# antenna violations come from these buffers
set ::env(DONT_USE_CELLS) "sky130_fd_sc_hd__buf_1 \
                           sky130_fd_sc_hd__buf_2 \
                           sky130_fd_sc_hd__buf_12 \
						   sky130_fd_sc_hd__clkbuf_1 \
						   sky130_fd_sc_hd__clkbuf_2 \
						   [listFromFile $::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/drc_exclude.cells]"
set ::env(CELL_PAD) 6
set ::env(PL_RESIZER_SETUP_MAX_BUFFER_PERCENT) 30
set ::env(PL_RESIZER_HOLD_MAX_BUFFER_PERCENT) 70
set ::env(PL_RESIZER_ALLOW_SETUP_VIOS) 1
set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) 0.1
set ::env(PL_RESIZER_MAX_SLEW_MARGIN) 35
set ::env(PL_RESIZER_MAX_WIRE_LENGTH) 200

##################################################################
# CTS
##################################################################
set ::env(CTS_TARGET_SKEW) 150
set ::env(CTS_TOLERANCE) 25
set ::env(CTS_CLK_BUFFER_LIST) {sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8}
set ::env(CTS_SINK_CLUSTERING_SIZE) 8
set ::env(CLOCK_BUFFER_FANOUT) 5
set ::env(CTS_CLK_MAX_WIRE_LENGTH) 300

##################################################################
# Global Routing
##################################################################
set ::env(GLB_RT_ANT_ITERS) 20
set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 20
set ::env(GLOBAL_ROUTER) fastroute
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 1
set ::env(GLB_RESIZER_ALLOW_SETUP_VIOS) 0
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) 0.8
set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) 70
# set ::env(GLB_RT_OBS)  " 
#        met1 210 110 670 488,
# 	   met1 910 110 1370 488,
# 	   met1 210 625 670 1008,
# 	   met1 910 625 1370 1008,
# 	   met2 210 110 670 488,
# 	   met2 910 110 1370 488,
# 	   met2 210 625 670 1008,
# 	   met2 910 625 1370 1008,
# 	   met3 210 110 670 488,
# 	   met3 910 110 1370 488,
# 	   met3 210 625 670 1008,
# 	   met3 910 625 1370 1008,
# 	   met4 210 110 670 488,
# 	   met4 910 110 1370 488,
# 	   met4 210 625 670 1008,
# 	   met4 910 625 1370 1008"

##################################################################
# Antenna Diodes Insertion
##################################################################
set ::env(DIODE_PADDING) 2
set ::env(DIODE_INSERTION_STRATEGY) 3

##################################################################
# Detailed Routing
##################################################################
set ::env(DRT_OPT_ITERS) 45
set ::env(ROUTING_CORES) 8
set ::env(DETAILED_ROUTER) tritonroute

##################################################################
# Physical Verification
##################################################################
set ::env(MAGIC_DRC_USE_GDS) 1
set ::env(MAGIC_EXT_USE_GDS) 1
set ::env(LVS_CONNECT_BY_LABEL) 0

##################################################################
# Checkers
##################################################################
set ::env(QUIT_ON_LVS_ERROR) 0
set ::env(QUIT_ON_MAGIC_DRC) 0
set ::env(QUIT_ON_TR_DRC) 0