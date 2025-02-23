import uvm_pkg::*;
import shared_pkg::*;
import test_pkg::*;
`include "uvm_macros.svh"


module top();

logic  clk = 0 ;

always #(clkprd/2) clk = ~clk;

ram_if ifc(clk);
ram  DUT(ifc);


initial begin
	uvm_config_db #(virtual ram_if)::set(null , "*" ,"ram_if", ifc);
	run_test("test");
end

endmodule
