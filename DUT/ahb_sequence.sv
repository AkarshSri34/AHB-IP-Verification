class base_sequence_ahb extends uvm_sequence #(ahb_xtn);

        `uvm_object_utils(base_sequence_ahb)
             
	        logic [31:0] haddr;
            logic hwrite;
            logic [2:0] hsize;
            logic [2:0] hburst;
	
        extern function new(string name = "base_sequence_ahb");
endclass

function base_sequence_ahb::new(string name = "base_sequence_ahb");
        super.new(name);
endfunction
            
          
class ahb_write_seq extends uvm_sequence #(ahb_xtn);

  `uvm_object_utils(ahb_write_seq)
  ahb_xtn req;
  
  extern function new(string name = "ahb_write_seq");
  extern task body();
  
endclass

function ahb_write_seq::new(string name="ahb_write_seq");
    super.new(name);
  endfunction
          
task ahb_write_seq::body();

    req = ahb_xtn::type_id::create("req");

    start_item(req);

  if(!req.randomize() with {
    HWRITE == 1;
    HSIZE  == 3'b010;
    HBURST == 3'b000;
    HTRANS == 2'b10;
    HWDATA.size() == 1;
}) //write ; seq and non-seq ; single transfer
      `uvm_fatal("WRITE_SEQ","Randomization Failed")

    finish_item(req);

    `uvm_info("WRITE_SEQ",$sformatf("WRITE ADDR=%0h DATA=%0h",req.HADDR, req.HWDATA[0]), UVM_LOW)
endtask
    
    
class ahb_read_seq extends uvm_sequence #(ahb_xtn);

  `uvm_object_utils(ahb_read_seq)

  ahb_xtn req;

  rand bit [31:0] read_addr;

  extern function new(string name="ahb_read_seq");
    extern task body();
endclass
    
function ahb_read_seq:: new(string name="ahb_read_seq");
  super.new(name);
endfunction

task ahb_read_seq:: body();

    req = ahb_xtn::type_id::create("req");

    start_item(req);

    if(!req.randomize() with {
    HWRITE == 0;
    HADDR  == read_addr;
    HSIZE  == 3'b010;      // force word transfer
    HBURST == 3'b000;      // single transfer
    HTRANS == 2'b10;       // NONSEQ
})
      `uvm_fatal("READ_SEQ","Randomization Failed")

    finish_item(req);
  #1;

    `uvm_info("READ_SEQ",$sformatf("READ ADDR=%0h DATA=%0h", req.HADDR, req.HRDATA),UVM_LOW)

endtask
