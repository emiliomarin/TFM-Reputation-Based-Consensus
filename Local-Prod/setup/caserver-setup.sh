# setup go & use it for setting up the Fabric CA Binaries
# Copyright 2018 @ http://ACloudFan.com 
# Part of a online course. Please check it out at http://www.acloudfan.com

if [ -z $SUDO_USER ]
then
    echo "===== Script need to be executed with sudo ===="
    echo "Change directory to 'setup'"
    echo "Usage: sudo ./caserver.sh"
    exit 0
fi

echo "=======Set up go======"
sudo apt-get update
sudo apt-get -y install golang-1.10-go

# Setup the Gopath & Path
mkdir -p $PWD/../misc/gopath
export GOPATH=$PWD/../misc/gopath
export PATH=$PATH:/usr/lib/go-1.10/bin

# Get the Fabric CA binaries
echo "++++Fetching Fabric CA Binaries"
go get -u github.com/hyperledger/fabric-ca/cmd/...

# Move the binaries
echo "+++Moving Fabric CA Binaries"
sudo rm /usr/local/fabric-ca-*  2> /dev/null
sudo cp $GOPATH/bin/* $PWD/../bin
sudo mv $GOPATH/bin/*    /usr/local/bin

echo "Done."
echo "Validate by running>>   fabric-ca-server   version"


