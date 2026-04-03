`timescale 1ns/1ps

module tb_sync_fifo;

    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [7:0] din;

    wire [7:0] dout;
    wire full;
    wire empty;

    sync_fifo uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    reg [7:0] expected [0:9];
    integer i;

    initial begin
        // VCD
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_sync_fifo);

        clk = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        #10 rst_n = 1;

        $display("Writing data...");

        expected[0] = 10;
        expected[1] = 20;
        expected[2] = 30;

        wr_en = 1;

        din = expected[0]; #10;
        din = expected[1]; #10;
        din = expected[2]; #10;

        wr_en = 0;

        $display("Reading and checking...");

        rd_en = 1;

        for (i = 0; i < 3; i = i + 1) begin
            #10; // wait for dout

            if (dout == expected[i])
                $display("PASS: Expected=%0d Got=%0d", expected[i], dout);
            else
                $display("FAIL: Expected=%0d Got=%0d", expected[i], dout);
        end

        rd_en = 0;

        #20;
        $display("Simulation Done ");
        $finish;
    end

endmodule