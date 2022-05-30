This project contains OpenRAM SRAM's and its test application. The used SRAM was precompiled using OpenRAM. It has 512 32-bit words, which means it has a 2 Kbyte of memory. It has 1 rw port and 1 r port. 4 of them were used in this work, in total 8 Kbyte memory, and they are controllable by Wishbone bus coming from Caravel harness. The layout of the user_project_wrapper can be seen below.

![alt text](https://github.com/SerdarUnal132/openram_openmpw/blob/main/docs/layout.png?raw=true)

The waveform of the operation is visible below. Example waveform shows read & write operations sent from software. Both RTL and gate level simulation was done to ensure correct operation.

![alt text](https://github.com/SerdarUnal132/openram_openmpw/blob/main/docs/waveform.png?raw=true)

SRAM's were implemented directly in the user_project_wrapper due to limitation about SRAM power connections. The control logic was also implemented in user_project_wrapper for simplicity. The operating frequency is max 50 MHz.
