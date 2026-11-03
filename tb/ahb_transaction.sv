class ahb_xtn extends uvm_sequence_item;

  bit HRESETn;
  bit HREADY = 1'b1;

  rand bit [1:0] HTRANS;
  rand bit [2:0] HSIZE;
  rand bit [2:0] HBURST;
  rand bit       HWRITE;

  rand bit [31:0] HADDR;

  // Write data (for burst writes)
  rand bit [31:0] HWDATA[];

  // Read data (returned by slave)
  bit [31:0] HRDATA;

  // AHB response signals
  bit HRESP;
  bit HREADYout;


  // -------------------------
  // Constraints
  // -------------------------

  // BUSY transfer not allowed
  constraint trans_type {
    HTRANS != 2'b01;
  }

  // Only BYTE / HALFWORD / WORD
  constraint size_limit {
    HSIZE inside {3'b000,3'b001,3'b010};
  }

  // Address alignment
  constraint addr_align {

    if(HSIZE == 3'b001)
      HADDR[0] == 1'b0;     // halfword aligned

    if(HSIZE == 3'b010)
      HADDR[1:0] == 2'b00;  // word aligned
  }


  // Burst length constraints
  constraint data_length {

    // SINGLE
    if(HBURST == 3'b000)
      HWDATA.size() == 1;

    // INCR burst
    if(HBURST == 3'b001)
      HWDATA.size() inside {[1 : (1024 >> HSIZE)]};

    // WRAP4 / INCR4
    if(HBURST inside {3'b010,3'b011})
      HWDATA.size() == 4;

    // WRAP8 / INCR8
    if(HBURST inside {3'b100,3'b101})
      HWDATA.size() == 8;

    // WRAP16 / INCR16
    if(HBURST inside {3'b110,3'b111})
      HWDATA.size() == 16;
  }


  // -------------------------
  // UVM Field Macros
  // -------------------------

  `uvm_object_utils_begin(ahb_xtn)

    `uvm_field_int(HRESETn , UVM_ALL_ON)
    `uvm_field_int(HREADY  , UVM_ALL_ON)

    `uvm_field_int(HTRANS  , UVM_ALL_ON)
    `uvm_field_int(HBURST  , UVM_ALL_ON)
    `uvm_field_int(HSIZE   , UVM_ALL_ON)
    `uvm_field_int(HWRITE  , UVM_ALL_ON)

    `uvm_field_int(HADDR   , UVM_ALL_ON)

    `uvm_field_array_int(HWDATA , UVM_ALL_ON)

    `uvm_field_int(HRDATA , UVM_ALL_ON)

    `uvm_field_int(HRESP   , UVM_ALL_ON)
    `uvm_field_int(HREADYout , UVM_ALL_ON)

  `uvm_object_utils_end

  function new(string name = "ahb_xtn");
    super.new(name);
  endfunction

endclass
