# This script is used to create the actual tfm channel
# Parameters: [ORDERER_ADDRESS default=localhost:7050] [CHANNEL_NAME default=tfmchannel] [CHANNEL_TX_FILE default=../../artefacts/tfm-channel.tx]"

function usage {
    echo "create-channel.sh   [ORDERER_ADDRESS default=localhost:7050] [CHANNEL_NAME default=tfmchannel] [CHANNEL_TX_FILE default=../../artefacts/tfm-channel.tx]"
    echo "Make sure to execute . set-env.sh before "
}

# Defaults for the channel name and tx file path
CHANNEL_NAME=tfmchannel
CHANNEL_TX_FILE=../../artefacts/tfm-channel.tx 

if [ -z $1 ];
then
    usage
    ORDERER_ADDRESS="localhost:7050"
else
    ORDERER_ADDRESS=$1
fi

if [ $2 ];
then 
    CHANNEL_NAME=$2
    if [ -z $3 ];
    then 
        echo "Please provide the path to 'create channel tx' !!!"
        exit 0
    else
        CHANNEL_TX_FILE=$3
    fi  
fi

echo "Using ORDERER_ADDRESS=$ORDERER_ADDRESS"

# Execute the peer channel create command
peer channel create -o $ORDERER_ADDRESS -c $CHANNEL_NAME -f $CHANNEL_TX_FILE --outputBlock ../$CHANNEL_NAME-genesis.block
