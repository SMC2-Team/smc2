# To run this script, use the following command (replacing <program-name> with the program you'd like to run):
# bash run.sh <program-name>

prog="$1"
echo "$prog"

# Command structure to start the execution of the program for each party: 
# X <ID> <runtime-config> <priv-key-file> M K <share-file 1> ... <share-file M> <output-file 1> ... <output-file K>
# X: the executable program file (same for all parties)
# <ID>: this party's ID 
# <runtime-config>: the runtime configuration file (same for all parties)
# <priv-key-file>: the private key belonging to this party
# M: number of input parties
# K: number of output parties
# <input-file 1> ... <input-file M>: file names for this party's input shares (one from each input party)
# <output-file 1> ... <output-file K>: file names to give this party's output shares (one for each output party)

# start the 3rd party
./"$prog"/"$prog" 3 ../runtime-config ../keys/privkey3.pem 1 1 "$prog"/input3 "$prog"/output &
sleep 2

# start the 2nd party
./"$prog"/"$prog" 2 ../runtime-config ../keys/privkey2.pem 1 1 "$prog"/input2 "$prog"/output &
sleep 2

# start the 1st party
./"$prog"/"$prog" 1 ../runtime-config ../keys/privkey1.pem 1 1 "$prog"/input1 "$prog"/output &
sleep 2

# start picco-seed, which provides the secure seed to run the computation
# picco-seed <runtime-config> <utility-config>
# <runtime-config>: the runtime configuration file (same as above)
# <utility-config>: the program's utility configuration file
../bin/picco-seed ../runtime-config "$prog"/utility
