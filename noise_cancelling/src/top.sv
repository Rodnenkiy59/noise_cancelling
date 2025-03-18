module top (
    input   logic       CLK,
    input   logic       USER_RESET,
    input   logic       SW1,
    output  logic [3:0] LED,

    output  logic       RGB_LED,

    // UART
    output  logic       ser_tx,
    input   logic       ser_rx
);
//////////////////// RESET & CLK50 ////////////////////////
    logic   [4:0]   resetCnt;
    logic           reset;
    logic           CLK50;
    logic           CLK27;

    always_ff @( posedge CLK50 ) begin : RESET
        if (resetCnt < 30) begin
            resetCnt <= resetCnt + 1'b1;
        end else begin
            resetCnt <= resetCnt;
        end
    end

    assign reset = (resetCnt >= 30) ? '1 : '0;

///////////////// END RESET & CLK50 //////////////////////

    logic   [23:0]  ledCnt;

    always_ff @( posedge CLK50 or negedge reset ) begin : BLINKY_CNT
        if (!reset) begin
            ledCnt <= '0;
        end else begin
            ledCnt <= ledCnt + 1'b1;
        end
    end

    always_ff @( posedge CLK50 ) begin : BLINK
        if (ledCnt == '0) begin
            LED[2:0] <= ~LED[2:0];
        end
    end

//     assign ser_tx = ser_rx;

    Gowin_rPLL your_instance_name(
        .clkout(CLK50), //output clkout
        .clkoutd(CLK27), //output clkoutd
        .clkin(CLK) //input clkin
    );

/////////////////////////// UART /////////////////////////////////
    parameter c_CLKS_PER_BIT    = 234;
    logic   [7:0]   uartTx;
    logic           uartEn;

    logic       txActive;
    logic       txEn;
    logic [7:0] txByte;
    logic       txDone;

    logic [7:0] w_Rx_Byte;
    logic       rxEn;

    logic [7:0] gpio;

    uart_tx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_INST
        (.i_Clock       (CLK27),
        .i_Tx_DV        (txEn),
        .i_Tx_Byte      (txByte),
        .o_Tx_Active    (txActive),
        .o_Tx_Serial    (ser_tx),
        .o_Tx_Done      (txDone)
        );

    uart_rx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST
        (.i_Clock       (CLK27),
        .i_Rx_Serial    (ser_rx),
        .o_Rx_DV        (rxEn),
        .o_Rx_Byte      (w_Rx_Byte)
        );

    hello hello_inst (
        .CLK27      (CLK27),
        .reset      (reset),
        .rxEN       (rxEn),
        .rxData     (w_Rx_Byte),
        .txActive   (txActive),
        .txEn       (txEn),
        .txData     (txByte),
        .txDone     (txDone),
        .gpioOut    (gpio)
    );

    always_ff @( posedge CLK27 or negedge reset ) begin : LED3
        if (!reset) begin
            LED[3] <= '0;
        end else begin
            if (gpio[0]) begin
                LED[3] <= ~LED[3];
            end
        end
    end

///////////////////////////END UART /////////////////////////////////

endmodule