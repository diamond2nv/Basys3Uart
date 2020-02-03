module top(input clk, output RsTx, input btnC);
    reg [12:0] counter;
    reg uart_clk;
    reg [3:0] char_counter;
    reg frame_clk;
    reg [7:0] data;
    reg [1:0] btnC_s;
    reg trigger;
    reg [3:0] bit_counter;

    always @(posedge clk)
    begin
        if(counter == 13'd5208)
        begin
            uart_clk <= ~uart_clk;
            counter <= 0;
        end
        else
            counter <= counter + 1;
    end

    always @(posedge uart_clk)
    begin
        if(bit_counter == 4'd4)
        begin
            frame_clk <= ~frame_clk;
            bit_counter <= 0;
        end
        else
            bit_counter <= bit_counter + 1;

        trigger <= (char_counter != 0) & (frame_clk == 1'b1);
    end

    always @(posedge frame_clk)
    begin
        btnC_s <= {btnC_s[0], btnC};
        char_counter <= (char_counter == 4'd15 | (char_counter == 0 & !(btnC_s[0] & !btnC_s[1]))) ? 0 : char_counter + 1;

        case(char_counter)
            4'd1 : data <= 8'h48;
            4'd2 : data <= 8'h65;
            4'd3 : data <= 8'h6c;
            4'd4 : data <= 8'h6c;
            4'd5 : data <= 8'h6f;
            4'd6 : data <= 8'h2c;
            4'd7 : data <= 8'h20;
            4'd8 : data <= 8'h57;
            4'd9 : data <= 8'h6f;
            4'd10 : data <= 8'h72;
            4'd11 : data <= 8'h6c;
            4'd12 : data <= 8'h64;
            4'd13 : data <= 8'h21;
            4'd14 : data <= 8'h0d;
            4'd15 : data <= 8'h0a;
        endcase
    end

    transmitter tr_1(
        .clk (uart_clk),
        .trigger (trigger),
        .data(data),
        .RsTx (RsTx)
    );
endmodule
