# This script is used to fetch the gen block for the channel and join it
# Parameters: Orderer address, channel name

function usage {
    echo "join-channel.sh   [ORDERER_ADDRESS default=localhost:7050] [CHANNEL_NAME default=tfmchannel]"
    echo "Make sure to execute . set-env.sh before"
}

if [ -z $1 ];
then
    usage
    ORDERER_ADDRESS="localhost:7050"
else
    ORDERER_ADDRESS=$1
fi

if [ -z $2 ];
then
    CHANNEL_NAME=tfmchannel
else
    CHANNEL_NAME=$2
fi


GENESIS_BLOCK=eb-channel.block

echo "Using ORDERER_ADDRESS=$ORDERER_ADDRESS"

#1. Fetch the genesis for the channel
peer channel fetch config $GENESIS_BLOCK -o $ORDERER_ADDRESS -c $CHANNEL_NAME

#2. Join the channel
peer channel join -o $ORDERER_ADDRESS -b $GENESIS_BLOCK

rm $GENESIS_BLOCK 2> /dev/null