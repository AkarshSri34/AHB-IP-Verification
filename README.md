# AMBA AHB Verification using UVM

UVM testbench for the **AMBA AHB** protocol. An active master agent drives randomized single and burst transfers into a memory-backed AHB slave model.

**Tech:** SystemVerilog · UVM

> 🚧 **Work in progress.** A monitor, scoreboard and functional coverage are next.

---

## Testbench architecture

```
ahb_test
└── ahb_env
    └── ahb_agent
        ├── ahb_sequencer  ← ahb_sequence (randomized ahb_xtn)
        └── ahb_driver     → ahb_if → memory slave model (top.sv)
```

## Key features

- **AHB transaction (`ahb_xtn`)** with randomized `HTRANS`, `HSIZE`, `HBURST`, `HWRITE`, `HADDR` and burst write data
- **Interface** with all AHB burst types (SINGLE, INCR, WRAP4/8/16, INCR4/8/16) and transfer types (IDLE, BUSY, NONSEQ, SEQ), plus a driver modport
- **Slave model in `top.sv`:** a 1K-word memory that captures the address phase and services the write/read data phase one cycle later, as the AHB pipeline requires

## Repository layout

```
tb/
├── ahb_interface.sv
├── ahb_transaction.sv
├── ahb_sequence.sv
├── agent/          # ahb_sequencer, ahb_driver, ahb_agent
├── ahb_env.sv
├── ahb_test.sv
└── top.sv          # top module + AHB memory slave model
```

## Running

Compile `tb/top.sv` with any UVM-1.2 simulator (QuestaSim, VCS, Xcelium or EDA Playground). The test is `ahb_test`.

## Author

**Akarsh Srivastava** · Design Verification Engineer
[LinkedIn](https://www.linkedin.com/in/akarsh-srivastava-a034a7196) · [GitHub](https://github.com/AkarshSri34)
