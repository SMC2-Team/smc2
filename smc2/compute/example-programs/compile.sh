# To run this script, use the following command:
# bash compile.sh

# list of programs to compile
# edit this list if you'd only like to compile specific programs
programs=(pay-gap LR-parser h_analysis private-branching private-branching-add private-branching-mult private-branching-reuse)

# compile and create input
for prog in ${programs[@]}
do
   echo compiling "$prog"
   echo picco "$prog"/"$prog".c ../smc-config "$prog" "$prog"/utility
   picco "$prog"/"$prog".c ../smc-config "$prog" "$prog"/utility
   echo creating input shares with picco-utility
   echo picco-utility -I 1 "$prog"/input.txt "$prog"/utility "$prog"/input
   picco-utility -I 1 "$prog"/input.txt "$prog"/utility "$prog"/input
   mv "$prog".cpp ../"$prog".cpp
done

cd ../
# make executables
make

# move things back into their proper directories
for prog in ${programs[@]}
do
   mv "$prog".cpp example-programs/"$prog"/"$prog".cpp
   mv "$prog".o example-programs/"$prog"/"$prog".o
   mv "$prog" example-programs/"$prog"/"$prog"
done
