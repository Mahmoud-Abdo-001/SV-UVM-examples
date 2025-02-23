package environment_pkg;

import coverage_collector_pkg::*;
import scoreboard_pkg::*;
import agent_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class environment extends uvm_env;
`uvm_component_utils(environment);

agent agt;
scoreboard sb;
coverage_collector cov;

function new(string name = "environment" , uvm_component parent = null);
	super.new(name , parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	agt = agent :: type_id :: create ("agt",this);
	sb = scoreboard :: type_id :: create ("sb",this);
	cov = coverage_collector :: type_id :: create ("cov",this);
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	agt.agt_port.connect(sb.scoreboard_export);
	agt.agt_port.connect(cov.coverage_export);	
endfunction

endclass

endpackage