// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

//`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */
`define MPRJ_IO_PADS 38

module 
openram_demo #(
    parameter BITS   = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input          wb_clk_i,
    input          wb_rst_i,
    input          wbs_stb_i,
    input          wbs_cyc_i,
    input          wbs_we_i,
    input [3:0]    wbs_sel_i,
    input [31:0]   wbs_dat_i,
    input [31:0]   wbs_adr_i,
    output         wbs_ack_o,
    output [31:0]  wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);

  localparam  NRegisters = 3;

  wire [31:0] rdata; 
  wire [31:0] wdata;
  wire        ready;
  wire        valid;
  wire [31:0] la_write;

  wire clk;
  wire rst;

  assign valid = wbs_cyc_i && wbs_stb_i; 
  assign wbs_dat_o = rdata;
  assign wdata = wbs_dat_i;

  assign io_out = 0;
  assign io_oeb = {(`MPRJ_IO_PADS-1){1'b1}};

  // IRQ
  assign irq = 3'b000;	// Unused

  // LA
  assign la_data_out = {{64{1'b0}}, wdata_q, rdata_q};
  // Assuming LA probes [65:64] are for controlling the count clk & reset  
  assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
  assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;
    
  assign wbs_ack_o = | ready;

  wire [31:0] sram0_dout0;
  wire [31:0] sram0_dout1;

  reg [9:0] counter_q;
  reg [3:0] w_addr_q;
  reg [3:0] r_addr_q;

  // sram_32_16_sky130 SRAM0 (
  sky130_sram_1kbyte_1rw1r_32x256_8 SRAM0 (
    `ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
    `endif
    .clk0   (clk),
    .csb0   (1'b0),
    .web0   (1'b0),
    .addr0  (w_addr_q),
    .din0   ({{22{1'b0}}, counter_q}),
    .dout0  (sram0_dout0),
    .clk1   (clk),
    .csb1   (1'b0),
    .addr1  (r_addr_q),
    .dout1  (sram0_dout1)
  );
  
  
  // Register interface
  reg  [31:0] rdata_q;
  reg  [31:0] wdata_q;
  reg         ready_q;
  
  assign rdata = rdata_q;
  assign ready = ready_q;

  // Register file
  reg   [31:0] register_file      [NRegisters-1:0];
  wire  [3:0]  addr_register_file;
  assign addr_register_file = wbs_adr_i[5:0] >> 2;

  integer k;
  
  always @(posedge clk) begin
    if (rst == 1) begin
      for (k = 0; k < NRegisters; k = k + 1) register_file[k] <= 0;  
      ready_q <= 0;
      rdata_q <= 0;
      wdata_q <= 0;
    end else begin
      ready_q <= 1'b0;
      register_file[0] <= 32'b0;
      register_file[1] <= sram0_dout0;
      register_file[2] <= sram0_dout1;
      if (valid && !ready_q) begin
        ready_q <= 1'b1;
        if (wbs_we_i) begin
          register_file[addr_register_file] <= wdata;
          wdata_q <= wdata;
          rdata_q = rdata_q;
        end else begin
          wdata_q <= 0;
          rdata_q <= register_file[addr_register_file];
        end
      end
      
    end
  end

  always @(posedge clk) begin
    if (rst == 1) begin
      counter_q <= 0;
      w_addr_q <= 0;
      r_addr_q <= 0;
    end else begin
      w_addr_q <= counter_q / 10;
      r_addr_q <= (counter_q / 10) ^ 4'hF;
      if (counter_q < 159) begin
        counter_q <=  counter_q + 1;
      end else begin
        counter_q <=  0;
      end
    end
  end

endmodule
