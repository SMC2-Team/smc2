# clone the picco repository
git clone https://github.com/PICCO-Team/picco.git


# add our benchmarking programs and scripts to the PICCO directories
cp -r smc2/compute/example-programs picco/compute/
cp smc2/compute/makefile picco/compute/makefile
cp smc2/compute/programs.mk picco/compute/programs.mk
cp smc2/compute/smc-config picco/compute/smc-config
cp smc2/compute/runtime-config picco/compute/runtime-config


# install PICCO
cd picco/compiler
mkdir bin
bash compile.sh

cd ../compute
mkdir bin
cp ../compiler/bin/* bin/

# generate keys
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
   bash compile.sh "$prog"
done

cd ../../../



# install SMC2
cd smc2/compiler
mkdir bin
bash compile.sh

cd /root/smc2/compute
mkdir bin
cp ../compiler/bin/* bin/

# generate keys
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
   bash compile.sh "$prog"
done


