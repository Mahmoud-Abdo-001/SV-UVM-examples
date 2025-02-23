package scoreboard_pkg;

import uvm_pkg::*;
import seq_item_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"

class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard);

uvm_analysis_export #(seq_item) scoreboard_export;
uvm_tlm_analysis_fifo #(seq_item) scoreboard_fifo;
seq_item scoreboard_item;    /* sequence item */

/* Tracking Result */
int Match; 
int Mismatch;

/******************** DUT signals ******************/
logic we_ref;
logic [ADDR_WIDTH-1:0]   addr_ref;
logic [DATA_WIDTH-1:0]   din_ref;
logic [DATA_WIDTH-1:0]   dout_ref;
logic [DATA_WIDTH-1:0] mem_ref [0:(1<<ADDR_WIDTH)-1];
/***************************************************/

function new(string name = "scoreboard" , uvm_component parent = null);
	super.new(name,parent);
endfunction

//build phase
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	scoreboard_export = new("scoreboard_export",this);
	scoreboard_fifo = new("scoreboard_fifo",this);
endfunction

//connect phase
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	scoreboard_export.connect(scoreboard_fifo.analysis_export);
endfunction


//run phase
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
	scoreboard_fifo.get(scoreboard_item); /* get fifo content on my scoreboard_item */
	REFERNEC_MODEL(scoreboard_item);
	if(scoreboard_item.dout != dout_ref )begin
		`uvm_error("run_phase" , "Mismatch Found")
		$display("Mismatch : dout ref = %d , but got dout  = %d " , dout_ref , scoreboard_item.dout);
	Mismatch++;
	end else Match++;
	end
endtask

function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("Final Report", $sformatf("Total Matches: %0d, Total Mismatches: %0d", Match, Mismatch), UVM_LOW);
endfunction

/****************************************************************************************/
/**************************** R E F E R E N C E   M O D E L *****************************/
/****************************************************************************************/
task REFERNEC_MODEL(seq_item check_item);
if(scoreboard_item.we)begin
//write operation
if(check_item.we)begin
mem_ref[check_item.addr] = check_item.din;
end else
// read operation
begin
dout_ref = mem_ref[check_item.addr]; 
end
end
endtask
/****************************************************************************************/
/****************************************************************************************/
endclass


endpackage