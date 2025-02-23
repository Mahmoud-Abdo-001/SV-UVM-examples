package agent_pkg;

import uvm_pkg::*;
import seq_item_pkg::*;
import configuration_pkg::*;
import driver_pkg::*;
import monitor_pkg::*;
import sequencer_pkg::*;
`include "uvm_macros.svh"


class agent extends uvm_agent;
`uvm_component_utils(agent);

monitor mon;
driver drv;
sequencer sqr;
configuration conf_obj;
uvm_analysis_port #(seq_item) agt_port;


function new(string name = "agent" , uvm_component parent = null);
	super.new(name ,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(configuration)::get(this, "", "CFG", conf_obj))
        `uvm_fatal("build_phase", "agent unable to get configuration object");

    mon = monitor::type_id::create("mon", this);
    drv = driver::type_id::create("drv", this);
    sqr = sequencer::type_id::create("sqr", this);
    agt_port = new("agt_port", this);

    // `uvm_info("agent", $sformatf("conf.vif = %0p", conf_obj.vif), UVM_LOW);
endfunction


function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	drv.vif = conf_obj.vif;
	mon.mon_vif = conf_obj.vif;
	
	mon.mon_port.connect(agt_port);
	drv.seq_item_port.connect(sqr.seq_item_export);
endfunction
	
endclass

endpackage