
`timescale 1 ns / 1 ns

module Gowin_PicoRV32_template (
  // ser_tx,
  // ser_rx,
  wbuart_tx,
  wbuart_rx,
  // wbspi_master_miso,
  // wbspi_master_mosi,
  // wbspi_master_ssn,
  // wbspi_master_sclk,
  // wbspi_slave_miso,
  // wbspi_slave_mosi,
  // wbspi_slave_ssn,
  // wbspi_slave_sclk,
  // wbi2c_sda,
  // wbi2c_scl,
  io_spi_clk,
  io_spi_csn,
  io_spi_mosi,
  io_spi_miso,
  irq_in,
  jtag_TDI,
  jtag_TDO,
  jtag_TCK,
  jtag_TMS,
  clk_in,
  resetn_in,
//  ahbreg_test,
  LED
);

// //Simple UART
// output ser_tx;
// input ser_rx;

//WB UART
output wbuart_tx;
input wbuart_rx;

//WB GPIO
// inout [31:0] gpio_io;

// //WB SPI Master
// input wbspi_master_miso;
// output wbspi_master_mosi;
// output wbspi_master_ssn;
// output wbspi_master_sclk;

// //WB SPI Slave
// output wbspi_slave_miso;
// input wbspi_slave_mosi;
// input wbspi_slave_ssn;
// input wbspi_slave_sclk;

// //WB I2C
// inout wbi2c_sda;
// inout wbi2c_scl;

//ADV SPI-Flash
inout io_spi_clk;
inout io_spi_csn;
inout io_spi_mosi;
inout io_spi_miso;

//External Interrupt
input [1:0] irq_in;//irq[21],irq[20]

//JTAG
input jtag_TDI;
output jtag_TDO;
input jtag_TCK;
input jtag_TMS;

//System clock
input clk_in;

//System reset
input resetn_in;

//Test Open AHB bus
//output [3:0] ahbreg_test;

//LED
output [3:0] LED;

//Open Wishbone
wire slv_ext_stb_o;
wire slv_ext_we_o;
wire slv_ext_cyc_o;
wire slv_ext_ack_i;
wire [31:0] slv_ext_adr_o;
wire [31:0] slv_ext_wdata_o;
wire [31:0] slv_ext_rdata_i;
wire [3:0] slv_ext_sel_o;

//Open AHB
wire [31:0] hrdata;
wire [1:0] hresp;
wire hready;
wire [31:0] haddr;
wire hwrite;
wire [2:0] hsize;
wire [2:0] hburst;
wire [31:0] hwdata;
wire hsel;
wire [1:0] htrans;

wire resetn;
wire resetn_auto;
reg [15:0] rstdly = 0;

always @(negedge clk_in)
begin
    if(!resetn_in)
        rstdly <= 0;
    else
        rstdly <= {rstdly[14:0],1'b1};
end

assign resetn_auto = rstdly[15];
assign resetn = resetn_in & resetn_auto;

//irq testing
wire irq_out[1:0];

button irq_20_button (
    .clk(clk_in), 
    .rstn(resetn), 
    .in(irq_in[0]), 
    .out(irq_out[0])
);

button irq_21_button (
    .clk(clk_in), 
    .rstn(resetn), 
    .in(irq_in[1]), 
    .out(irq_out[1])
);

//Gowin_PicoRV32 top module
Gowin_PicoRV32_Top Gowin_PicoRV32_Top_inst
(
  // .ser_tx(ser_tx),
  // .ser_rx(ser_rx),
  .wbuart_tx(wbuart_tx),
  .wbuart_rx(wbuart_rx),
  .gpio_io(LED),
  // .wbspi_master_miso(wbspi_master_miso),
  // .wbspi_master_mosi(wbspi_master_mosi),
  // .wbspi_master_ssn(wbspi_master_ssn),
  // .wbspi_master_sclk(wbspi_master_sclk),
  // .wbspi_slave_miso(wbspi_slave_miso),
  // .wbspi_slave_mosi(wbspi_slave_mosi),
  // .wbspi_slave_ssn(wbspi_slave_ssn),
  // .wbspi_slave_sclk(wbspi_slave_sclk),
  // .wbi2c_sda(wbi2c_sda),
  // .wbi2c_scl(wbi2c_scl),
  .slv_ext_stb_o(slv_ext_stb_o),
  .slv_ext_we_o(slv_ext_we_o),
  .slv_ext_cyc_o(slv_ext_cyc_o),
  .slv_ext_ack_i(slv_ext_ack_i),
  .slv_ext_adr_o(slv_ext_adr_o),
  .slv_ext_wdata_o(slv_ext_wdata_o),
  .slv_ext_rdata_i(slv_ext_rdata_i),
  .slv_ext_sel_o(slv_ext_sel_o),
  .io_spi_clk(io_spi_clk),
  .io_spi_csn(io_spi_csn),
  .io_spi_mosi(io_spi_mosi),
  .io_spi_miso(io_spi_miso),
  .hrdata(hrdata),
  .hresp(hresp),
  .hready(hready),
  .haddr(haddr),
  .hwrite(hwrite),
  .hsize(hsize),
  .hburst(hburst),
  .hwdata(hwdata),
  .hsel(hsel),
  .htrans(htrans),
  .irq_in({10'h0,irq_out[1],irq_out[0]}),
  .jtag_TDI(jtag_TDI),
  .jtag_TDO(jtag_TDO),
  .jtag_TCK(jtag_TCK),
  .jtag_TMS(jtag_TMS),
  .clk_in(clk_in),
  .resetn_in(resetn)
);

//Open Wishbone bus
wbreg_demo wbreg_demo_inst (
  .wb_clk_i (clk_in), 
  .wb_rst_i (~resetn), 
  .arst_i   (~resetn), 
  .wb_adr_i (slv_ext_adr_o[4:0]), 
  .wb_dat_i (slv_ext_wdata_o), 
  .wb_dat_o (slv_ext_rdata_i),
  .wb_we_i  (slv_ext_we_o), 
  .wb_stb_i (slv_ext_stb_o), 
  .wb_cyc_i (slv_ext_cyc_o), 
  .wb_ack_o (slv_ext_ack_i)
);

//Open AHB bus
ahbreg_demo ahbreg_demo_inst (
    .hclk      (clk_in),
    .hresetn   (resetn),
    .haddr     (haddr),
    .htrans    (htrans),
    .hwrite    (hwrite),
    .hsize     (hsize),
    .hburst    (hburst),
    .hwdata    (hwdata),
    .hsel      (hsel),
    .hready_in (hready),
    .hready    (hready),
    .hrdata    (hrdata),
    .hresp     (hresp),
    .ahbreg0   () //ahbreg_test
);

endmodule