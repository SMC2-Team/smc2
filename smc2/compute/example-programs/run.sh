# To run this script, use the following command (replacing <program-name> with the program you'd like to run):
# bash run.sh <program-name>

prog="$1"
echo "$prog"

./"$prog"/"$prog" 3 ../runtime-config ../keys/privkey3.pem 1 1 "$prog"/input3 "$prog"/output &
sleep 2

./"$prog"/"$prog" 2 ../runtime-config ../keys/privkey2.pem 1 1 "$prog"/input2 "$prog"/output &
sleep 2

./"$prog"/"$prog" 1 ../runtime-config ../keys/privkey1.pem 1 1 "$prog"/input1 "$prog"/output &
sleep 2

picco-seed ../runtime-config "$prog"/utility