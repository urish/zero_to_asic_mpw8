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

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 * THIS FILE HAS BEEN GENERATED USING multi_tools_project CODEGEN
 * IF YOU NEED TO MAKE EDITS TO IT, EDIT codegen/caravel_iface_header.txt
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1,       // User area 1 3.3V supply
    inout vdda2,       // User area 2 3.3V supply
    inout vssa1,       // User area 1 analog ground
    inout vssa2,       // User area 2 analog ground
    inout vccd1,       // User area 1 1.8V supply
    inout vccd2,       // User area 2 1.8v supply
    inout vssd1,       // User area 1 digital ground
    inout vssd2,       // User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

    // generate active wires
    wire [31: 0] active;
    assign active = la_data_in[31:0];
    
    // when proving tristates are all good, assume only one project is active at a time
    `ifdef FORMAL
        always @* assume($onehot0(active));
    `endif

    // split remaining 96 logic analizer wires into 3 chunks
    wire [31: 0] la1_data_in, la1_data_out, la1_oenb;
    assign la1_data_in = la_data_in[63:32];
    assign la_data_out[63:32] = la1_data_out;
    assign la1_oenb = la_oenb[63:32];

    wire [31: 0] la2_data_in, la2_data_out, la2_oenb;
    assign la2_data_in = la_data_in[95:64];
    assign la_data_out[95:64] = la2_data_out;
    assign la2_oenb = la_oenb[95:64];

    wire [31: 0] la3_data_in, la3_data_out, la3_oenb;
    assign la3_data_in = la_data_in[127:96];
    assign la_data_out[127:96] = la3_data_out;
    assign la3_oenb = la_oenb[127:96];


    // start of user project module instantiation
    wrapped_rgb_mixer wrapped_rgb_mixer_3(
        `ifdef USE_POWER_PINS
        .vccd1 (vccd1),
        .vssd1 (vssd1),
        `endif
        .wb_clk_i (wb_clk_i),
        .active (active[3]),
        .la1_data_in (la1_data_in[31:0]),
        .la1_data_out (la1_data_out[31:0]),
        .la1_oenb (la1_oenb[31:0]),
        .io_in (io_in[37:0]),
        .io_out (io_out[37:0]),
        .io_oeb (io_oeb[37:0])
    );

    wrapped_frequency_counter wrapped_frequency_counter_2(
        `ifdef USE_POWER_PINS
        .vccd1 (vccd1),
        .vssd1 (vssd1),
        `endif
        .wb_clk_i (wb_clk_i),
        .active (active[2]),
        .la1_data_in (la1_data_in[31:0]),
        .la1_data_out (la1_data_out[31:0]),
        .la1_oenb (la1_oenb[31:0]),
        .io_in (io_in[37:0]),
        .io_out (io_out[37:0]),
        .io_oeb (io_oeb[37:0])
    );

    wrapped_channel wrapped_channel_1(
        `ifdef USE_POWER_PINS
        .vccd1 (vccd1),
        .vssd1 (vssd1),
        `endif
        .wb_clk_i (wb_clk_i),
        .active (active[1]),
        .la1_data_in (la1_data_in[31:0]),
        .la1_data_out (la1_data_out[31:0]),
        .la1_oenb (la1_oenb[31:0]),
        .io_in (io_in[37:0]),
        .io_out (io_out[37:0]),
        .io_oeb (io_oeb[37:0])
    );

    // end of module instantiation

endmodule	// user_project_wrapper
`default_nettype wire