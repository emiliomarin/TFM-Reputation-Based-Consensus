#!/bin/bash

# Installation of fabric binaries

export PATH=$PATH:$GOROOT/bin

echo "GOPATH=$GOPATH"
echo "GOROOT=$GOROOT"

# Execute in the setup folder
echo "=== Must execute in the setup folder ===="

cd ..

rm -rf misc

echo "====== Starting to Download Fabric ========"
#curl -sSL http://bit.ly/2ysbOFE | bash -s 1.2.0 1.2.0 0.4.10
curl -sSL http://bit.ly/2ysbOFE -o bootstrap.sh
chmod 755 *.sh
#./bootstrap.sh  1.3.0 1.3.0 0.4.10 -d
./bootstrap.sh  1.4.0 1.4.0 0.4.10 -d

#./bootstrap.sh  1.2.0 1.2.0 0.4.10 -d 


echo "======= Copying the binaries to /usr/local/bin===="
rm -rf ./bin 2> /dev/null
mv fabric-samples/bin       .
cp bin/*    /usr/local/bin


mkdir -p misc
mv fabric-samples ./misc

rm bootstrap.sh

# Change mode for all shell scripts
chmod 755 orderer/bins/*.sh
chmod 755 peers/bins/*.sh
chmod 755 fabric-ca/bins/*.sh
chmod 755 cloud/*.sh
chmod 755 cloud/bins/fabric-ca/*.sh
chmod 755 cloud/bins/orderer/*.sh
chmod 755 cloud/bins/peer/*.sh
