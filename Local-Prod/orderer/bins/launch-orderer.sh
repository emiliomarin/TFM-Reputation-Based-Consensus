# This script is used to start the orderer process

# Location of the orderer.yaml file
export FABRIC_CFG_PATH=$PWD/..

#### You may override other runtime parameters defined in orderer.yaml ###

orderer  2> ../orderer.log

