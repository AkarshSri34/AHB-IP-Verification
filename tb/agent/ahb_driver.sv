class ahb_driver extends uvm_driver #(ahb_xtn);

  `uvm_component_utils(ahb_driver)

  virtual ahb_if.AHB_DR_MP vif;
  ahb_xtn req;

  extern function new(string name="ahb_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive();

endclass


function ahb_driver::new(string name="ahb_driver", uvm_component parent);
  super.new(name,parent);
endfunction


function void ahb_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db #(virtual ahb_if.AHB_DR_MP)::get(this,"","vif",vif))
    `uvm_fatal("DRV","Unable to get virtual interface")
endfunction


function void ahb_driver::end_of_elaboration_phase(uvm_phase phase);
  `uvm_info("AHB_DRIVER",{get_full_name()," Created"},UVM_MEDIUM)
endfunction



task ahb_driver::run_phase(uvm_phase phase);

  forever begin
    seq_item_port.get_next_item(req);
    drive();
    seq_item_port.item_done();
  end

endtask



task ahb_driver::drive();

  bit [31:0] addr;
  addr = req.HADDR;

  //---------------------------------
  // Address Phase
  //---------------------------------
  vif.ahb_drv_cb.Hwrite   <= req.HWRITE;
  vif.ahb_drv_cb.Hburst   <= req.HBURST;
  vif.ahb_drv_cb.Hsize    <= req.HSIZE;
  vif.ahb_drv_cb.Htrans   <= req.HTRANS;
  vif.ahb_drv_cb.Hreadyin <= req.HREADY;
  vif.ahb_drv_cb.Haddr    <= addr;

  // Wait one cycle (AHB pipeline)
  @(vif.ahb_drv_cb);

  //---------------------------------
  // WRITE DATA PHASE
  //---------------------------------
  if(req.HWRITE) begin

    foreach(req.HWDATA[i]) begin

      vif.ahb_drv_cb.Hwdata <= req.HWDATA[i];

      wait(vif.ahb_drv_cb.Hreadyout);

      // Burst increment
      if((req.HBURST != 3'b000) && (req.HWDATA.size() > 1)) begin
        vif.ahb_drv_cb.Htrans <= 2'b11;
        addr = addr + (1 << req.HSIZE);
        vif.ahb_drv_cb.Haddr <= addr;
      end

      @(vif.ahb_drv_cb);

    end

  end

  //---------------------------------
  // READ DATA PHASE
  //---------------------------------
 //---------------------------------
// READ DATA PHASE
//---------------------------------
else begin

  wait(vif.ahb_drv_cb.Hreadyout);

  // Address accepted
  @(vif.ahb_drv_cb);

  // Data returned
  @(vif.ahb_drv_cb);

  req.HRDATA = vif.ahb_drv_cb.Hrdata;

end

  //---------------------------------
  // End Transfer
  //---------------------------------
  vif.ahb_drv_cb.Htrans <= 2'b00;

endtask
