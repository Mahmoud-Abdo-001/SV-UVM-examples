import shared_pkg::*;

interface ram_if (clk);
    input  logic             clk;
    logic                    we;
    logic [ADDR_WIDTH-1:0]   addr;
    logic [DATA_WIDTH-1:0]   din;
    logic [DATA_WIDTH-1:0]   dout;
endinterface
