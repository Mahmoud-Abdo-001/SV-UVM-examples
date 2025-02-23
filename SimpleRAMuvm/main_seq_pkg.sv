
package main_seq_pkg;


import uvm_pkg::*;
import seq_item_pkg::*;
`include "uvm_macros.svh"

class main_seq extends uvm_sequence #(seq_item);
`uvm_object_utils(main_seq);

seq_item item;

function new(string name = "main_seq");
	super.new(name);
endfunction

task body;
repeat(100000)begin
item = seq_item :: type_id ::create("item");

start_item(item);
assert(item.randomize());
finish_item(item);
end
endtask

endclass

endpackage
