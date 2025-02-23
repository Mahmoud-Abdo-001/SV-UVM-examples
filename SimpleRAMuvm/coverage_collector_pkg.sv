package coverage_collector_pkg;

import uvm_pkg::*;
import seq_item_pkg::*;  // Fix typo
import shared_pkg::*;
`include "uvm_macros.svh"

class coverage_collector extends uvm_component;
    `uvm_component_utils(coverage_collector)

    uvm_analysis_export#(seq_item) coverage_export;
    uvm_tlm_analysis_fifo#(seq_item) coverage_fifo;
    seq_item item_cov;

    // Coverage group definition
    covergroup RAM_CG;
        option.per_instance = 1;

        // Cover write transactions
        WR_EN: coverpoint item_cov.we {
            bins write = {1};
            bins read = {0};
        }

        // Cover address range
        ADDR_CG: coverpoint item_cov.addr {
            bins lower_range[] = {[0 : (1<<ADDR_WIDTH)/4 - 1]};
            bins mid_range[]   = {[(1<<ADDR_WIDTH)/4 : (1<<ADDR_WIDTH)/2 - 1]};
            bins upper_range[] = {[(1<<ADDR_WIDTH)/2 : (1<<ADDR_WIDTH) - 1]};
        }

        // Cover different data values written
        DATA_CG: coverpoint item_cov.din 
		//{
            // bins min_val = {0};
            // bins max_val = {(1<<DATA_WIDTH)-1};
            // bins mid_val = {(1<<DATA_WIDTH)/2};
            // bins random_vals[] = {[10:20], [50:60], [100:200]};
        // }

        // Cross coverage: Address + Write Enable
        ADDR_WE_CROSS: cross WR_EN, ADDR_CG;
    endgroup

    // Constructor
    function new(string name = "coverage_collector", uvm_component parent = null);
        super.new(name, parent);
        RAM_CG = new();
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        coverage_export = new("coverage_export", this);
        coverage_fifo = new("coverage_fifo", this);
    endfunction

    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        coverage_export.connect(coverage_fifo.analysis_export);
    endfunction

    // Run phase (loops to collect coverage data continuously)
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            coverage_fifo.get(item_cov); // Get transactions
            RAM_CG.sample();  // Sample coverage
            `uvm_info("coverage_collector", $sformatf("Sampled: WE=%0d ADDR=0x%0h DIN=0x%0h", 
                        item_cov.we, item_cov.addr, item_cov.din), UVM_HIGH)
        end
    endtask

endclass

endpackage
