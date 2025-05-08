# RISC-Pipelined-Microprocessor

This repository contains a VHDL implementation of a 6-stage pipelined RISC processor, designed as part of the EE309 course at IIT Bombay. The processor follows a custom instruction set architecture (ISA) and demonstrates key concepts in pipelined CPU design.

## 📁 Repository Structure

- `Toplevel_CPU.vhd`: Top-level entity integrating all modules.
- `REG_FILE.vhd`: Register file with 16 general-purpose registers.
- `alu_beh.vhd`: Behavioral description of the Arithmetic Logic Unit (ALU).
- `PC_reg.vhd`: Program Counter register module.
- `IR_ID_RR.vhd`: Instruction Register and Register Register pipeline stage.
- `CONT_REG_*`: Various control registers for different pipeline stages.
- `8x1_mux.vhd`: 8-to-1 multiplexer used in the datapath.
- `Memory.vhd`: Memory module for instruction and data storage.
- `EE309-Project-pipelined-RISC-IITB.pdf`: Project report detailing design and implementation.

## 🧠 Features

- 6-stage pipeline: IF, ID, EX, MA, WB, and Control Registers.
- Supports basic arithmetic and logical operations.
- Designed for educational purposes to understand pipelined processor architecture.

