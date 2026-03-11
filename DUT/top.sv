
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "ahb_interface.sv"
`include "ahb_transaction.sv"
`include "ahb_sequence.sv"
`include "ahb_sequencer.sv"
`include "ahb_driver.sv"
`include "ahb_agent.sv"
`include "ahb_env.sv"
`include "ahb_test.sv"


module top;

  bit HCLK;
  always #5 HCLK = ~HCLK;

  ahb_if ahb_if_inst(HCLK);

  logic [31:0] mem [0:1023];

  logic        Hwrite_d;
  logic [31:0] Haddr_d;
  logic [31:0] Hwdata_d;
  logic [1:0]  Htrans_d;

  always @(posedge HCLK) begin

    int index;
    Hwrite_d <= ahb_if_inst.Hwrite;
    Haddr_d  <= ahb_if_inst.Haddr;
    Hwdata_d <= ahb_if_inst.Hwdata;
    Htrans_d <= ahb_if_inst.Htrans;

    // Word-aligned address for memory indexing
    index = Haddr_d[11:2];

    if(Htrans_d inside {2'b10,2'b11}) begin

      // WRITE
      if(Hwrite_d)
        mem[index] <= Hwdata_d;

      // READ
      else
        ahb_if_inst.Hrdata <= mem[index];

    end

  end
  
  initial begin
    ahb_if_inst.Hresetn = 0;
    repeat(5) @(posedge HCLK);  // hold reset for few cycles
    ahb_if_inst.Hresetn = 1;
  end

  
  initial begin
    foreach(mem[i])
      mem[i] = '0;
  end

  initial begin
    ahb_if_inst.Hreadyout = 1;
  end

  initial begin
  $dumpfile("dump.vcd"); 
  $dumpvars;
  #3000 $finish;
end
  
  initial begin

    uvm_config_db #(virtual ahb_if.AHB_DR_MP)::set(
      null,
      "*",
      "vif",
      ahb_if_inst.AHB_DR_MP
    );

    run_test("ahb_test");

  end

endmodule
