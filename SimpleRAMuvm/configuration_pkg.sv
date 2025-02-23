package configuration_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"


class configuration extends uvm_object;
`uvm_object_utils(configuration);

virtual ram_if vif;

function new(string name= "configuration");
	super.new(name);
endfunction

endclass

endpackage
