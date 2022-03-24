# Compiler's Computation Hub

### smc-compute
- This directory contains the source code of the SMC library.

### example-programs
- This directory contains the example programs used in the paper and benchmarking programs used for comparison with PICCO. 

### Files:
- [`makefile`](makefile): used to compile example programs with the libraries
- [`programs.mk`](programs.mk): lists the programs to be compiled by the makefile (no need to edit the makefile itself)
- [`runtime-config`](runtime-config): runtime configuration file (used when running the program for each party and for picco-seed), set to run 3 parties locally. To run distributed, replace each _localhost_ with the IP address or domain name for each of the parties.
- [`smc-config`](smc-config): configuration file (used during program compilation), set for 1 input and 1 output party
