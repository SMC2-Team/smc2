# number of times to run each program
numRuns=1
# list of programs to run
programs=(pay-gap LR-parser h_analysis private-branching private-branching-add private-branching-mult private-branching-reuse)
# timeout lengths that a program shouldn't run beyond
timeoutSMC2=(50 5 100 20 20 20 850)
timeoutPICCO=(50 5 100 20 30 30 1200)

mkdir smc2/runtimes
mkdir picco/runtimes

echo "cd smc2/compute/example-programs"
cd smc2/compute/example-programs

for i in ${!programs[@]}
do
    for j in $(seq $numRuns)
    do 
        echo bash runT.sh "${programs[$i]}" "${timeoutSMC2[$i]}"s
        echo sleep "${timeoutSMC2[$i]}"s
        bash runT.sh "${programs[$i]}" "${timeoutSMC2[$i]}"s > "${programs[$i]}$j"
        killall -q "${programs[$i]}"/"${programs[$i]}"
        cat "${programs[$i]}$j"
        mv "${programs[$i]}$j" ../../runtimes/"${programs[$i]}$j"
        echo bash output.sh "${programs[$i]}"
        bash output.sh "${programs[$i]}"
    done
done


cd 
echo "cd picco/compute/example-programs"
cd picco/compute/example-programs

for i in ${!programs[@]}
do
    for j in $(seq $numRuns)
    do 
        echo bash runT.sh "${programs[$i]}" "${timeoutPICCO[$i]}"s
        echo sleep "${timeoutPICCO[$i]}"s
        bash runT.sh "${programs[$i]}" "${timeoutPICCO[$i]}"s > "${programs[$i]}$j"
        killall -q "${programs[$i]}"
        cat "${programs[$i]}$j"
        mv "${programs[$i]}$j" ../../runtimes/"${programs[$i]}$j"
    done
done
