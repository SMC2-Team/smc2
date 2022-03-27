# Docker
Table of Contents:
- [SMC<sup>2</sup> Docker](#smc2-docker)
- [Benchmark run script](#benchmark-run-script)
- [Speedup Calculation](#speedup-calculation)
- [Docker Reference](#docker-reference)
- [Troubleshooting](#troubleshooting)

## SMC<sup>2</sup> Docker
First, ensure Docker is allocated 8GB of Memory. 
You can confirm or modify this in Docker's preferences (Docker -> Preferences -> Resources).
This will allow you enough space to have both PICCO and SMC2 installed and properly run programs with both on the same Docker image. 

### Docker Creation
This takes a bit, but only has to be done once. It builds the Docker image and runs [`install.sh`](install.sh). 
This command should be run from the outer [smc2](https://github.com/SMC2-Team/smc2) directory.
```
docker build -t smc2 .
```
Once this is complete, you will have a Docker image with both SMC<sup>2</sup> and PICCO installed, and the benchmarking programs compiled. 

### Running Docker
Open a running, interactive container with the Docker created in the last step.
```
docker run -it --rm smc2
```

### Example Programs
We've stored our benchmarking programs within [`smc2/compute/example-programs`](../smc2/compute/example-programs). 
Each program has it's own directory, containing the program, example input, and corresponding expected output. 
The compiled program, utility file, input shares, and executable were added during the Docker creation when `install.sh` was run.

- SMC<sup>2</sup>:
```
cd smc2/compute/example-programs
```

- PICCO:
```
cd picco/compute/example-programs
```
As we have built our implementation from PICCO, compilation, running, and getting output uses the same commands and allows us to use the same scripts for both.


#### Compiling Examples
This step was already completed for our benchmarking programs during Docker creation, when [`install.sh`](install.sh) was ran.
We've provided a script to facilitate the process of compiling a program and obtaining input shares in [`compile.sh`](https://github.com/SMC2-Team/smc2/blob/main/smc2/compute/example-programs/compile.sh). The script contains comments to help you understand what is being done in various steps. 
```
bash compile.sh <program-name>
```


#### Running Examples
We've provided a script to facilitate the process of starting the multiparty computation for a single program in [`run.sh`](https://github.com/SMC2-Team/smc2/blob/main/smc2/compute/example-programs/run.sh). The script contains comments to help you understand what is being done in various steps. 
```
bash run.sh <program-name>
```
Please ensure you have increased the memory allotted to Docker to 8GB before running [`private-branching-reuse`](https://github.com/SMC2-Team/smc2/tree/main/smc2/compute/example-programs/private-branching-reuse) - in testing the Docker, with 8GB of memory, it takes around 12 minutes to complete for SMC<sup>2</sup> and 18 minutes to complete for PICCO. If you have not increased the memory, this program will hang for hours before getting running out of space and getting stuck. 

All other benchmarking programs should complete fairly quickly, with the fastest [`LR-parser`](https://github.com/SMC2-Team/smc2/tree/main/smc2/compute/example-programs/LR-parser)) completing in under a second and the second-slowest [`h_analysis`](https://github.com/SMC2-Team/smc2/tree/main/smc2/compute/example-programs/h_analysis) completing within one minute. You will know the program has finished running when it prints 3 times (one for each party) like so: 
```
Time: 0.005847
Time: 0.002881
Time: 0.007141
```

#### Obtaining Output
We've provided a script to facilitate the process of obtaining output from output shares in [`output.sh`](https://github.com/SMC2-Team/smc2/blob/main/smc2/compute/example-programs/output.sh). The script contains comments to help you understand what is being done in various steps. 
```
bash output.sh <program-name>
```
This script also checks the output against the expected output. If this command runs without anything printed to the terminal, then the expected and actual output files match. 


#### Adding Examples
If you'd like to add example programs, please follow the directory and naming scheme provided for the given examples.
Each program `new-program` should be in it's own directory `new-program/`, containing the program `new-program.c`, example input `input.txt`, and corresponding expected output `expected-output.out`.
This will enable the use of the given scripts, which facilitate compilation, running, and obtaining output. 

Each script gives details about the commands being run within the script. 
You can also find the [PICCO manual](https://github.com/PICCO-Team/picco/blob/master/picco-manual.pdf) in the main [PICCO repository](https://github.com/PICCO-Team/picco). The commands and information detailed here hold for our implementation as well.

## Benchmark Run Script
The script [runBenchmarks.sh](https://github.com/SMC2-Team/smc2/blob/main/Docker/runBenchmarks.sh) will run all of the benchmarking programs, first for SMC<sup>2</sup>, then for PICCO. It is initially set to run the programs each once, but can be set to any number of runs by editing line 2 `numRuns=1`. This script will collect the output of every run within a file, allowing easy computation of the percetage speedup using script `plot.py`.
It should be run in the background using the command: 
```
bash runBenchmarks.sh &
```
Please ensure to run this script in the background using the above command, otherwise the programs will likely not execute properly and fail to complete. If any given program fails within the script, you can run just that program again using the following (replacing `j` at the end with the run number, i.e. 2 for the second run):
```
bash run.sh <program_name> > <program_namej>
```
Once this is complete, use the following command to move the collected console output to the correct folder for use with the plotting script.
```
mv <program_namej> ../../runtimes/<program_namej>
```
It is fairly likely that at least one program will fail when using this script. This seems to be a side effect of using Docker and having the computations limited to the resources of the container.



## Speedup Calculation
Once you have run all benchmarks and have their timings placed in the runtime folders (i.e., from using the script runBenchmarks.sh or following the behavior of runBenchmarks.sh), you can use the script [`plot.py`](https://github.com/SMC2-Team/smc2/blob/main/Docker/plot.py) to grab the timings and compute the percent speedup between SMC<sup>2</sup> and PICCO. 
This script creates a CSV file `statsLocal.csv` to give all of the averages, standard deviation, and percentage speedup information that is computed, as well as a CSV for each program to display the runtimes obtained and the average for each run. If you have collected the timings for multiple runs, simply edit line 6 to reflect the number of runs.
```
numberRuns = 1
```
We do not plot the graphs (to our knowledge, Docker doesn't have a visual interface to view them), but include the function that would be used to do so.

To run this script, use the command:
```
python3 plot.py
```
To calculate the relative speedup:
- run average => take the average of the three times obtained for the run (one time for each party)
- program average => take the average of all run averages for a given program
- program standard deviation => get the standard deviation of the run averages for a given program
- program percent speedup => PICCO program average minus SMC<sup>2</sup> program average, divided by the PICCO program average times 100
- standard deviation => PICCO program average minus (SMC<sup>2</sup> program average minus SMC<sup>2</sup> program standard deviation), divided by PICCO program average times 100 minus percentSpeedup


## Docker Reference
- The Docker implementation for PICCO found [here](https://github.com/MPC-SoK/frameworks/tree/master/picco) was referred to when creating the Docker for SMC<sup>2</sup>, modifying their Dockerfile and install.sh.
- Citation:
> M. Hastings, B. Hemenway, D. Noble, and S. Zdancewic. SoK: General purpose compilers for secure multi-party computation. In IEEE Symposium on Security and Privacy (S&P), pages 1220–1237, 2019.


## Troubleshooting
#### The program I ran is taking longer than expected.
- Run `ps -u` to see if the parties are all still running and computing (using CPU). If not, or if they've been running for too long, kill them using their pid `kill <pid>`. Wait a few seconds, then restart the program.
- Try closing the container (`ctrl+d`) and restarting the container (`docker run -it --rm smc2`).
- Check how much memory you've allotted to Docker (Docker -> Preferences -> Resources). Increasing the memory to 8GB should speed up the runtimes vs. running with the default 2GB of memory. 

#### One of the computational parties failed.
Occassionally a connection will drop and you need to restart the program on all parties. 
Run `ps -u` to see which parties are still running, then kill them using their pid `kill <pid>`.
Now the resources will be freed up to restart the program. 


