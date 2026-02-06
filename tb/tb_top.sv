module tb_top;
    reg ACLK = 0;
    reg ARESETn = 0;
    reg [31:0] AWADDR;
    reg AWVALID;
    wire AWREADY;
    reg [31:0] WDATA;
    reg [3:0] WSTRB;
    reg WVALID;
    wire WREADY;
    wire [1:0] BRESP;
    wire BVALID;
    reg BREADY;
    reg [31:0] ARADDR;
    reg ARVALID;
    wire ARREADY;
    wire [31:0] RDATA;
    wire [1:0] RRESP;
    wire RVALID;
    reg RREADY;
    axi4_lite_slave dut  ( * );
    always #5 ACLK = ~ACLK;

    initial begin
        #20 ARESETn = 1;
        // WRITE
        AWADDR = 32'h04;
        WDATA  = 32'h12345678;
        AWVALID = 1;
        WVALID  = 1;
        BREADY  = 1;
        #10 AWVALID = 0;
        WVALID = 0;
        // READ
        #20 ARADDR = 32'h04;
        ARVALID = 1;
        RREADY = 1;
        #10 ARVALID = 0;
        #50 $finish;
    end
endmodule
