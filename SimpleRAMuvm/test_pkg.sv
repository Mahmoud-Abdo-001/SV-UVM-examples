package test_pkg;

import uvm_pkg::*;
import configuration_pkg::*;
import environment_pkg::*;
import main_seq_pkg::*;
`include "uvm_macros.svh"

class test extends uvm_test;
`uvm_component_utils(test);

configuration cfg;
environment env;
main_seq myseq;

function new(string name = "test" , uvm_component parent = null);
	super.new(name ,parent);
endfunction

//build phase
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = configuration::type_id::create("cfg",this);
    env = environment::type_id::create("env",this);
    myseq = main_seq::type_id::create("myseq",this);

    if (!uvm_config_db #(virtual ram_if)::get(this, "", "ram_if", cfg.vif))
        `uvm_fatal("build_phase", "test unable to get the vif from the db");

    uvm_config_db #(configuration)::set(this, "*", "CFG", cfg);

    // `uvm_info("test", $sformatf("cfg.vif = %0p", cfg.vif), UVM_LOW);  //debuging
endfunction

//run phase
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);
	
	/* my seq */
	`uvm_info("run_phase" , "main seq started " , UVM_MEDIUM);
	myseq.start(env.agt.sqr);
	`uvm_info("run_phase" , "main seq end" , UVM_MEDIUM);
	
	phase.drop_objection(this);
endtask

endclass

endpackage
