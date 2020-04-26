# This script is used to launch the specific peer
# PArameters: ORG_NAME , PORT_NUMBER_BASE, PEER_NAME

function usage {
    echo "./launch-peer.sh   ORG_NAME  [PORT_NUMBER_BASE default=7050]   [PEER_NAME default=eb-peer1]"
    echo "Sets the environment variables for the peer & then launches it"
}

if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
fi

if [ -z $2 ]
then
    PORT_NUMBER_BASE=7050  
else
    PORT_NUMBER_BASE=$2
fi

if [ -z $3 ];
then
    PEER_NAME=eb-peer1
    echo "Using the default PEER_NAME=$PEER_NAME"
else 
    PEER_NAME=$3
fi


# Set up the environment variables for the peer
source set-env.sh   $ORG_NAME  $PORT_NUMBER_BASE   $PEER_NAME

# Set the Peer File System Path for writing the ledger
export CORE_PEER_FILESYSTEMPATH="$HOME/peers/$PEER_NAME/ledger" 

# Create the ledger folders
mkdir -p $CORE_PEER_FILESYSTEMPATH


# Core peer
export CORE_PEER_ID=$PEER_NAME

# Start the peer
PEER_LOGS="../$PEER_NAME.log"
peer node start 2> $PEER_LOGS &

echo "  => Check Peer Log under  $PEER_LOGS"
