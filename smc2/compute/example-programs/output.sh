# To run this script, use the following command (replacing <program-name> with the program you'd like to obtain output for):
# bash output.sh <program-name>

prog="$1"

# Obtain the output form output shares
# picco-utility -O <output party ID> <shares filename> <utility config> <result filename>
# <output party ID>: ID of the output party obtaining output (we only have 1 for our examples) 
# <shares filename>: naming scheme for the output shares
# <utility config>: name of the utility configuration file 
# <result filename>: name to be given to the output file created
../bin/picco-utility -O 1 "$prog"/output "$prog"/utility "$prog"/actual-output.out

# Compare expected output vs. actual output
diff "$prog"/actual-output.out "$prog"/expected-output.out
# Note: if nothing is printed to console, then the output files are identical
