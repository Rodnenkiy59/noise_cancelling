module top (
    input   logic       CLK,
    input   logic       RESET,
    output  logic [3:0] LED,

    output  logic       RGB_LED,

    // JTAG
    input   logic       jtag_TCK,
    input   logic       jtag_TMS,
    input   logic       jtag_TDI,
    output  logic       jtag_TDO,

    // UART
    output  logic       ser_tx,
    input   logic       ser_rx
);
    
    logic   [23:0] ledCnt;

    always_ff @( posedge CLK ) begin : BLINKY_CNT
        ledCnt <= ledCnt + 1'b1;
    end

    always_ff @( posedge CLK ) begin : BLINK
        if (ledCnt == '0) begin
            LED[2:0] <= ~LED[2:0];
        end
    end

    assign RGB_LED = '1;

    assign LED[3] = gpio_io;

    Gowin_PicoRV32_Top your_instance_name(
    .ser_tx(ser_tx), //output ser_tx
    .ser_rx(ser_rx), //input ser_rx
    .gpio_io(gpio_io), //inout [0:0] gpio_io
    .jtag_TDI(jtag_TDI), //input jtag_TDI
    .jtag_TDO(jtag_TDO), //output jtag_TDO
    .jtag_TCK(jtag_TCK), //input jtag_TCK
    .jtag_TMS(jtag_TMS), //input jtag_TMS
    .clk_in(CLK), //input clk_in
    .resetn_in(RESET) //input resetn_in
	);

endmodule