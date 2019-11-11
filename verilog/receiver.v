module receiver(input RsRx, input clk, output reg [7:0] data);

    reg [7:0] data_s;
    reg [2:0] clk_counter;
    reg [1:0] state;
    reg [3:0] counter;
    initial data = 8'bxxxxxxxx;

    parameter waiting = 0, receiving = 1, detecting = 2, writing = 3;

    always @(posedge clk)
    begin
        casez({state, clk_counter, RsRx})
            {waiting, 3'b?, 0} : clk_counter <= 0;
            {detecting, 7, 1'b?} :
            begin
                clk_counter <= 0;
                data_s[0] <= RsRx;
                counter <= counter + 1;
            end

            {receiving, 5, 1'b?} :
            begin
                clk_counter <= 0;
                data_s <= {(data_s << 1)[7:1], RsRx};
                counter <= counter + 1;
            end

            default : clk_counter <= clk_counter + 1;
        endcase

        casez({state, clk_counter, RsRx, counter})
            {waiting, 3'b?, 0, 3'b?} : state <= detecting;
            {detecting, 7, 1'b?, 3'b?} : state <= receiving;
            {receiving, 4,1'b?, 8} : state <= writing;
            {writing, 3'b?, 1'b?, 3'b?} : state <= waiting;
        endcase

        if (state == writing)
            data <= data_s;
    end



endmodule
    // set counter to 0
    //speed 5x
    //detect 7 after
