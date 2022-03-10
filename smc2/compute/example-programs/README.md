# Example Programs

### Benchmarking Examples
- [pay-gap](pay-gap)
- [LR-parser](LR-parser)
- [h_analysis](h_analysis)
- [private-branching](private-branching) (pb)
- [private-branching-mult](private-branching-mult) (pb-mult)
- [private-branching-add](private-branching-add) (pb-add)
- [private-branching-reuse](private-branching-reuse) (pb-reuse)

The private-branching benchmarks are all designed to stress the differences in runtimes between PICCO and SMC<sup>2</sup>. They are listed from lowest runtime to highest, with `pb-reuse` taking around 3.5 minutes when all parties are run locally on a single machine (distributed: ~8 minutes). 

Please note: when running these programs on the Docker image, expect runtimes 2-3 times greater than those we listed for running programs distributed. `pb-reuse` may take 3+ hours to run within the Docker image.

Each example program is given an input file (`input.txt`) and, for each program that produces output, an expected output file (`expected-output.out`).


