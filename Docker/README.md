# Docker

## SMC<sup>2</sup> Docker

### Docker Creation
This takes a bit, but only has to be done once. It builds the Docker image and runs [`install.sh`](install.sh). 
```
$ docker build -t smc2 .
```
Once this is complete, you will have a Docker image with our implementation of PICCO installed, and the benchmarking programs compiled. 

### Running Docker
Open a running, interactive container with the Docker created in the last step.
```
$ docker run -it --rm smc2 .
```

### Example Programs
We've stored our benchmarking programs within [`smc2/compute/example-programs`](../smc2/compute/example-programs). 
Each program has it's own directory, containing the program, example input, and corresponding expected output. 
The compiled program, utility file, input shares, and executable were added during the Docker creation when `install.sh` was run.
```
$ cd smc2/compute/example-programs
```

#### Running Examples

```
$ bash run.sh <program-name>
```

#### Compiling Examples

```
$ bash compile.sh <program-name>
```

#### Obtaining Output

```
$ bash output.sh <program-name>
```


#### Adding Examples
If you'd like to add example programs, please follow the directory and naming scheme provided for the given examples.
Each program `new-program` should be in it's own directory `new-program/`, containing the program `new-program.c`, example input `input.txt`, and corresponding expected output `expected-output.out`.
This will enable the use of the given scripts, which facilitate compilation, running, and obtaining output. 



## PICCO Docker
- A docker for running PICCO can be found here: https://github.com/MPC-SoK/frameworks/tree/master/picco
- This docker uses a previous version of PICCO as compared to the version we tested against to obtain the results shown in our paper, so results may differ slightly but still be comparable to the `local` results.
- This Docker implementation was referred to when creating the Docker for SMC<sup>2</sup>, modifying their Dockerfile and install.sh.
- PICCO Docker Citation:
> M. Hastings, B. Hemenway, D. Noble, and S. Zdancewic. SoK: General purpose compilers for secure multi-party computation. In IEEE Symposium on Security and Privacy (S&P), pages 1220–1237, 2019.
