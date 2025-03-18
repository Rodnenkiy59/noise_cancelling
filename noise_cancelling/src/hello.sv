module hello (
    input logic         CLK27,
    input logic         reset,

    input logic         rxEN,
    input logic [7:0]   rxData,

    input  logic        txDone,
    input  logic        txActive,
    output logic        txEn,
    output logic [7:0]  txData,

    output logic [7:0]  gpioOut
);

    logic       txDoneDelay;
    logic [7:0] cnt;

    logic [7:0] gpio;
    logic [7:0] gpioDelay;

    always_ff @( posedge CLK27 or negedge reset ) begin : GPIO
        if (!reset) begin
            gpio <= '0;
        end else begin
            case (rxData)
                8'h31 : begin
                    if (rxEN) begin
                        gpio[0] <= '1;
                    end
                end
                default: gpio <= 8'h0;
            endcase
        end
    end

    always @( posedge CLK27 ) begin : GPIO_DELAY
        gpioDelay <= gpio;
    end
        
    always_ff @( posedge CLK27 or negedge reset) begin : GPIO_OUT
        if (!reset) begin
            gpioOut <= '0;
        end else begin
            if ((gpio != '0) && (gpioDelay == '0)) begin
                gpioOut <= gpio;
            end else begin
                gpioOut <= '0;
            end
        end
    end

    always @(posedge CLK27 ) begin
        txDoneDelay <= txDone;
    end

    always_ff @( posedge CLK27 or negedge reset ) begin : CNT_TX_UART
        if (!reset) begin
            cnt <= '0;
        end else begin
            if (txDone && !txDoneDelay && cnt <= 7 && !txActive)
                cnt <= cnt + 1'b1;
        end
    end

    always_ff @( posedge CLK27 ) begin : HELLO_WRLD
        case (cnt)
        0 : begin  
            txEn <= 0; txData <= 8'h0; // Q
        end

        1 : begin  
            txEn <= 1; txData <= 8'h51; // Q
        end

        2 : begin  
            txEn <= 1; txData <= 8'h51; // Q
        end

        3 : begin 
            txEn <= 1; txData <= 8'h20; // space
        end

        4 : begin  
            txEn <= 1; txData <= 8'h45; // E
        end

        5 : begin 
            txEn <= 1; txData <= 8'h50; // P
        end

        6 : begin  
            txEn <= 1; txData <= 8'h54; // T
        end

        7 : begin  
            txEn <= 1; txData <= 8'h41; // A
        end

        default: begin txEn <= rxEN; txData <= rxData; end
        endcase
    end
    
endmodule