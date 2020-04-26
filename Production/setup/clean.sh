

# Deletes the folders from the project
# BUT does not Uninstall/remove binaries

SETUP_FOLDER=$PWD

#Clean the fabric-ca folders
cd $SETUP_FOLDER/../fabric-ca/bins
echo "===> Cleaning Fabric CA Server"
./clean.sh

#Clean the fabric-ca folders
cd $SETUP_FOLDER/../orderer/bins
echo "===> Cleaning Orderer"
./clean.sh


#Clean the peer folders
cd $SETUP_FOLDER/../peers/bins
echo "===> Cleaning Peers"
./clean.sh

#Clean the comoposer folders
rm $SETUP_FOLDER/../composer/cards/* 2> /dev/null
rm -rf  $SETUP_FOLDER/../composer/test/* 2> /dev/null

cd $SETUP_FOLDER/../cloud
echo "===> Cleaning Cloud folder"
./clean.sh

# cleanup bins,artefacts, misc/*
echo "===> Removing fabric components"
if [ "$1" = "all" ]; then
    # If it equals all then we need to cleanup other stuff as well :)
    rm $PWD/../bin/*  2>   /dev/null
    rm -rf $PWD/../misc/*   2>   /dev/null
    rm -rf $PWD/../gopath  2>   /dev/null
    rm -rf $PWD/../composer/util/node_modules
    rm -rf $PWD/../composer/util/package-lock.json
    # Binaries installed under /usr/local/bin NOT removed
fi

# Clean up the folder .vagrant
echo "==> Done."
echo "1. To Remove VM. Please run the command   'vagrant destroy' on host machine"
echo "2. To Re-install fabric use scripts under the setup folder."