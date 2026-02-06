module axi4_lite_slave (
    input  wire        ACLK,
    input  wire        ARESETn,

    // Write Address Channel
    input  wire [31:0] AWADDR,
    input  wire        AWVALID,
    output reg         AWREADY,

    // Write Data Channel
    input  wire [31:0] WDATA,
    input  wire [3:0]  WSTRB,
    input  wire        WVALID,
    output reg         WREADY,

    // Write Response Channel
    output reg  [1:0]  BRESP,
    output reg         BVALID,
    input  wire        BREADY,

    // Read Address Channel
    input  wire [31:0] ARADDR,
    input  wire        ARVALID,
    output reg         ARREADY,

    // Read Data Channel
    output reg [31:0]  RDATA,
    output reg [1:0]   RRESP,
    output reg         RVALID,
    input  wire        RREADY
);

    reg [31:0] regfile [0:3];
    wire [1:0] addr_index;
    assign addr_index = AWADDR[3:2];

    integer i;

    always @(posedge ACLK) begin
        if (!ARESETn) begin
            AWREADY <= 0;
            WREADY  <= 0;
            BVALID  <= 0;
            ARREADY <= 0;
            RVALID  <= 0;
            RDATA   <= 32'h0;
            for (i = 0; i < 4; i = i + 1)
                regfile[i] <= 32'h0;
        end else begin
            AWREADY <= AWVALID;
            WREADY  <= WVALID;

            if (AWVALID && WVALID) begin
                regfile[addr_index] <= WDATA;
                BVALID <= 1'b1;
            end

            if (BVALID && BREADY)
                BVALID <= 1'b0;

            ARREADY <= ARVALID;

            if (ARVALID) begin
                RDATA  <= regfile[ARADDR[3:2]];
                RVALID <= 1'b1;
            end

            if (RVALID && RREADY)
                RVALID <= 1'b0;
        end
    end
endmodule
