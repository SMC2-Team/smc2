# To run this script, use the following command (replacing <program-name> with the program you'd like to compile):
# bash compile.sh <program-name>

prog="$1"

# compile and create the utility file
echo compiling "$prog"
echo picco "$prog"/"$prog".c ../smc-config "$prog" "$prog"/utility
picco "$prog"/"$prog".c ../smc-config "$prog" "$prog"/utility

# create input shares
echo creating input shares with picco-utility
echo picco-utility -I 1 "$prog"/input.txt "$prog"/utility "$prog"/input
picco-utility -I 1 "$prog"/input.txt "$prog"/utility "$prog"/input

# move program to the outer directory to make the executable with the library files
mv "$prog".cpp ../"$prog".cpp

# overwrite programs.mk to set up for this program
cd ../
echo "PROGRAMS +=" "$prog" >| programs.mk

# make executable
make

# move the programs' files back into its proper directory to set up for runtime
mv "$prog".cpp example-programs/"$prog"/"$prog".cpp
mv "$prog".o example-programs/"$prog"/"$prog".o
mv "$prog" example-programs/"$prog"/"$prog"

