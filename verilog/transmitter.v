module transmitter(input trigger, input clk, input [7:0] data, output reg RsTx);

reg [9:0] memory;
reg [1:0] trigger_s;

always @(posedge clk)
    begin
        trigger_s[0] <= trigger;
        trigger_s[1] <= trigger_s[0];
        if(trigger_s[0] & !trigger_s[1] & (memory == 0))
            begin
                memory <= {2'b11, data};
                RsTx <= 0;
            end
        else
            begin
                if(memory == 0)
                    RsTx <= 1;
                else
                    begin
                        RsTx <= memory[0];
                        memory <= memory >> 1;
                    end
            end
    end

endmodule
