# Cleans up the orderer process
killall orderer 2> /dev/null

# Remove the ledger data from the local filesystem
rm -rf $HOME/orderer  2> /dev/null
# Remove the orderer log
rm ../orderer.log  2> /dev/null
# Remove the genesis & channel files
rm ../../artefacts/*  2> /dev/null

echo "Done."
