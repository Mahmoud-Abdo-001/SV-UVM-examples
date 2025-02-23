import shared_pkg::*;

module ram(ram_if ifc);
    
    logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
	/* 1<<ADDR_WIDTH = 2**ADDR_WIDTH */
	
    always_ff @(posedge ifc.clk) begin
        if (ifc.we) 
            mem[ifc.addr] <= ifc.din;  // Write operation
        else 
            ifc.dout <= mem[ifc.addr];  // Read operation
    end

endmodule
