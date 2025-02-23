package seq_item_pkg;

import uvm_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"


class seq_item extends uvm_sequence_item;
`uvm_object_utils(seq_item);

    rand bit                    we;
    rand bit [ADDR_WIDTH-1:0]   addr;
    rand bit [DATA_WIDTH-1:0]   din;
    logic 	 [DATA_WIDTH-1:0]   dout;

function new(string name = "seq_item");
	super.new(name);
endfunction

//constrain

endclass

endpackage