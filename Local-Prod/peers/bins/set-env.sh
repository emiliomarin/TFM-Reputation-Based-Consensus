#!/bin/bash

# Sets the Identity & Peer context

function usage {
    echo ". set-env.sh   ORG_NAME  [PORT_NUMBER_BASE default=7050]   [IDENTITY default=admin]"
    echo " Sets the environment variables for the peer"
}

# logging level
export CORE_LOGGING_LEVEL=info  #debug  #info #warning

if [ -z $1 ];
then
    usage
    echo " Please provide the ORG Name!"
    return
else
    ORG_NAME=$1
fi

PORT_NUMBER_BASE=7050
if [ -z $2 ]
then
    echo "Setting PORT_NUMBER_BASE=7050"   
else
    PORT_NUMBER_BASE=$2
    echo "Setting PORT_NUMBER_BASE=$2"
fi

if [ -z $3 ];
then
    IDENTITY=admin
else
    IDENTITY=$3
fi

echo -e "  => Switching IDENTITY Context to Org = $ORG_NAME  $IDENTITY"


# Create the path to the crypto config folder
CRYPTO_CONFIG_ROOT_FOLDER="$PWD/../../fabric-ca/client"

# Set the MSPCONFIGPATH = for peer command identity context
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp

# Sets the MSP ID
# Capitalize the first letter of Org name 
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"


# Set the Peer Listener ports
VAR=$((PORT_NUMBER_BASE+1))
export CORE_PEER_LISTENADDRESS=0.0.0.0:$VAR
export CORE_PEER_ADDRESS=0.0.0.0:$VAR
VAR=$((PORT_NUMBER_BASE+2))
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:$VAR
VAR=$((PORT_NUMBER_BASE+3))
export CORE_PEER_EVENTS_ADDRESS=0.0.0.0:$VAR

# core.yaml file is in peers folder
export FABRIC_CFG_PATH="$PWD/.."

# Set variables for chaincode
export GOPATH="$PWD/../../gopath"
export NODECHAINCODE="$PWD/../../nodechaincode"
export CURRENT_ORG_NAME=$ORG_NAME
export CURRENT_IDENTITY=$IDENTITY

# All Peers will connect to this peer as bootstrap peer
# Otherwise
#export CORE_PEER_GOSSIP_BOOTSTRAP=localhost:7051

