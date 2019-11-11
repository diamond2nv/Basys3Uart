module transmitter(input trigger, input clk, input [7:0] data, output RsTx);

    reg [8:0] memory;
    reg [1:0] trigger_s;

    always @(posedge clk)
    begin
        trigger_s[0] <= trigger;
        trigger_s[1] <= trigger_s[0];
        memory <= (trigger_s[0] & !trigger_s[1] & (memory == 0)) ? {1'b1, data} : memory >> 1;
    end

    assign RsTx = (memory == 0) ? (trigger_s[0] & !trigger_s[1] ? 0 : 1) : memory[0];

endmodule
