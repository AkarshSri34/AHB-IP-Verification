class ahb_env extends uvm_env;

  `uvm_component_utils(ahb_env)

  ahb_agent agent;

  extern function new(string name="ahb_env", uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass
    
    
function ahb_env::new(string name="ahb_env", uvm_component parent);
  super.new(name,parent);
endfunction

function void ahb_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  agent = ahb_agent::type_id::create("agent",this);
endfunction
