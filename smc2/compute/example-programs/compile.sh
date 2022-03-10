# To run this script, use the following command (replacing <program-name> with the program you'd like to compile):
# bash compile.sh <program-name>

prog="$1"

# Compile and create the utility file
# picco <program-name> <smc-config> <compiled-program> <utility-config-file>
# <program-name>: the program you are compiling
# <smc-config>: the SMC configuration file
# <compiled-program>: the name to give the compiled program
# <utility-config-file>: the name to give the utility file
echo compiling "$prog"
echo picco "$prog"/"$prog".c ../smc-config "$prog" "$prog"/utility
picco "$prog"/"$prog".c ../smc-config "$prog" "$prog"/utility

# Create input shares
# picco-utility -I <input-party-ID> <input-filename> <utility-config-file> <input-shares-name>
# <input-party-ID>: input party ID providing the input (there can be multiple input parties, our benchmarks only use 1)
# <input-filename>: name of the input file
# <utility-config-file>: name of the utility file
# <input-shares-name>: naming scheme for the input shares being created
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

