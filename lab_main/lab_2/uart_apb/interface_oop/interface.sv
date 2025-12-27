interface bus_if (input logic clk, input logic rst);
    logic [7:0]  addr;
    logic        as;
    logic        rw;
    logic        ds;
    logic        da;
    logic [15:0] data;

    modport busread (
        input  clk, rst, da, data,
        output addr, as, rw, ds
    );

    modport busmgr (
        input  clk, rst, addr, as, rw, ds,
        output da, data
    );
endinterface

module busread (
    bus_if.busread b_io
);
    always_ff @(posedge b_io.clk or posedge b_io.rst) begin
        if (b_io.rst) begin
            // reset logic here
        end else begin
            // logic control bus
        end
    end
endmodule

module busmgr (
    bus_if.busmgr b_io
);
    always_ff @(posedge b_io.clk or posedge b_io.rst) begin
        if (b_io.rst) begin
            // reset logic here
        end else begin
            // logic control bus
        end
    end
endmodule

module testbench;
    logic clk = 0;
    logic rst;

    always #5 clk = ~clk;

    bus_if my_bus_if (.clk(clk), .rst(rst));

    busread U1 (
        .b_io(my_bus_if.busread)
    );

    busmgr U2 (
        .b_io(my_bus_if.busmgr)
    );

    initial begin
        rst = 1;
        #20 rst = 0;
        #100 $finish;
    end
endmodule