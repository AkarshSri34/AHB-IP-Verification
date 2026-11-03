interface ahb_if(input bit clock);

  logic Hresetn, Hwrite; //clk,reset,transfer direction - master
  logic [2:0] Hsize;
  logic [1:0] Htrans;
  logic Hreadyin;
  logic Hreadyout;
  logic [31:0] Haddr;
  logic [2:0] Hburst;
  logic [1:0] Hresp;
  logic [31:0] Hwdata;
  logic [31:0] Hrdata;
				
parameter SINGLE = 3'b000, INCR4 = 3'b011, WRAP4 = 3'b010, INCR8 = 3'b101, WRAP8 = 3'b100, INCR16 = 3'b111, WRAP16 = 3'b110;
parameter IDLE = 2'b00, BUSY = 2'b01, NON_SEQ = 2'b10, SEQ = 2'b11;



        //AHB DRIVER clocking block:
        clocking ahb_drv_cb@(posedge clock);
                default input #1 output #1;
                                output Hwrite;
                                output Hreadyin;
								output Hwdata;
                                output Haddr;
                                output Htrans;
                                output Hburst;
                                output Hresetn;
                                output Hsize;
								input Hrdata;
                                input Hreadyout;
        endclocking

        //AHB MONITOR clocking block:
                clocking ahb_mon_cb@(posedge clock);
                default input #1 output #1;
                                input Hwrite;
                                input Hreadyin;
                                input Hwdata;
                                input Haddr;
                                input Htrans;
                                input Hburst;
                                input Hresetn;
                                input Hsize;
                                input Hreadyout;
				                input Hrdata;
        endclocking

        //DRIVER and monitor modport:
        modport AHB_DR_MP (clocking ahb_drv_cb);
        modport AHB_MON_MP (clocking ahb_mon_cb);


endinterface : ahb_if
