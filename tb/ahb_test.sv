class ahb_test extends uvm_test;

  `uvm_component_utils(ahb_test)

  ahb_env env;

  extern function new(string name="ahb_test", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass
    
function ahb_test::new(string name="ahb_test", uvm_component parent);
  super.new(name,parent);
endfunction
    
function void ahb_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  env = ahb_env::type_id::create("env",this);
endfunction
    
task ahb_test::run_phase(uvm_phase phase);

  ahb_write_seq wseq;
  ahb_read_seq  rseq;

  phase.raise_objection(this);

  wseq = ahb_write_seq::type_id::create("wseq");
  rseq = ahb_read_seq::type_id::create("rseq");

  // start write
  wseq.start(env.agent.seqr);
  // start read
  rseq.read_addr = wseq.req.HADDR;
  
  rseq.start(env.agent.seqr);
  #100;
  phase.drop_objection(this);

endtask
