cd smc2

# install 
cd compiler
mkdir bin
bash compile.sh
cp bin/* /usr/bin

# generate keys
cd /root/smc2/compute
mkdir keys
cd keys
for ID in {1..3}
do
  openssl genrsa -out privkey$ID.pem
  openssl rsa -in privkey$ID.pem -outform PEM -pubout -out pubkey$ID.pem
done

cd ../
# list of programs to compile
programs=(pay-gap LR-parser h_analysis private-branching private-branching-add private-branching-mult private-branching-reuse)


cd example-programs

# compile, then create input shares
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

