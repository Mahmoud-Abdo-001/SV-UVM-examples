package driver_pkg;

import uvm_pkg::*;
import configuration_pkg::*;
import seq_item_pkg::*;
`include "uvm_macros.svh"


class driver extends uvm_driver #(seq_item);
`uvm_component_utils(driver);

virtual ram_if vif;
configuration conf;
seq_item stim_item;

function new(string name= "driver" , uvm_component parent = null);
	super.new(name,parent);
endfunction

//build phase
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(~uvm_config_db #(configuration)::get(this ,"" , "CFG" , conf))
		`uvm_fatal("build_phase" , "driver unable to get configuration object");
endfunction

//connect phase
function void connect_phase(uvm_phase phase);
	vif = conf.vif;
endfunction

//run phase
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
	stim_item = seq_item :: type_id :: create("stim_item");
	seq_item_port.get_next_item(stim_item);
	vif.we = stim_item.we;
	vif.addr = stim_item.addr;
	vif.din = stim_item.din;
	vif.dout = stim_item.dout;
	
	@(negedge vif.clk);
	seq_item_port.item_done();
	end
	
endtask

endclass

endpackage
