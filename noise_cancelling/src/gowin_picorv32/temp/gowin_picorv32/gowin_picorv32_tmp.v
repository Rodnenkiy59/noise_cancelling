//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.9.03 Education (64-bit)
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Wed Oct  2 20:57:49 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	Gowin_PicoRV32_Top your_instance_name(
		.ser_tx(ser_tx), //output ser_tx
		.ser_rx(ser_rx), //input ser_rx
		.gpio_io(gpio_io), //inout [0:0] gpio_io
		.jtag_TDI(jtag_TDI), //input jtag_TDI
		.jtag_TDO(jtag_TDO), //output jtag_TDO
		.jtag_TCK(jtag_TCK), //input jtag_TCK
		.jtag_TMS(jtag_TMS), //input jtag_TMS
		.clk_in(clk_in), //input clk_in
		.resetn_in(resetn_in) //input resetn_in
	);

//--------Copy end-------------------
