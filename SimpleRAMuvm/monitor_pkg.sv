package monitor_pkg;

import uvm_pkg::*;
import seq_item_pkg::*;
`include "uvm_macros.svh"



class monitor extends uvm_monitor;
`uvm_component_utils(monitor);

virtual ram_if mon_vif;
seq_item resp_item;
uvm_analysis_port #(seq_item) mon_port;

function new (string name = "monitor" , uvm_component parent = null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	mon_port = new("mon_port",this);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
	
    // `uvm_info("monitor", $sformatf("vif = %0p", mon_vif), UVM_LOW);

    forever begin
        resp_item = seq_item::type_id::create("resp_item");
        @(negedge mon_vif.clk);
        resp_item.we = mon_vif.we;
        resp_item.addr = mon_vif.addr;
        resp_item.din = mon_vif.din;
        resp_item.dout = mon_vif.dout;

        mon_port.write(resp_item);
	    // `uvm_info("run_phase" , rsp_seq_item.convert2string() , UVM_HIGH);
    end
endtask

endclass

endpackage 
