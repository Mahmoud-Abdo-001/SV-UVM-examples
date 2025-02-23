package sequencer_pkg;

import uvm_pkg::*;
import seq_item_pkg::*;
`include "uvm_macros.svh"
 
class sequencer extends uvm_sequencer #(seq_item);
`uvm_component_utils(sequencer);

function new(string name = "sequencer",uvm_component parent = null);
	super.new(name);
endfunction

endclass

endpackage
