# Script to automate even more the launch of the network and speed everything up.
function launchPeer {
    source ./set-env.sh $ORG $PORT admin
    ./launch-peer.sh $ORG $PORT $PEER_NAME
}

function joinChannel {
    source ./set-env.sh $ORG $PORT admin
    ./join-channel.sh $ORDERER $CHANNEL_NAME
}

# Create Channel

echo "****** Creating Channel ******"
source ./set-env.sh tfm 7050 admin

ORDERER="localhost:7050"
CHANNEL_NAME="tfmchannel"
TX_FILE="../../artefacts/tfm-channel.tx"
./create-channel.sh $ORDERER $CHANNEL_NAME $TX_FILE

echo "****** Launching Peers ******"
echo "===> tfm-peer1"
export CORE_PEER_GOSSIP_BOOTSTRAP="localhost:7051"
ORG="tfm"
PORT="7050"
PEER_NAME="tfm-peer1"
launchPeer
joinChannel

echo "===> tfm-peer2"
PORT="8050"
PEER_NAME="tfm-peer2"
launchPeer
joinChannel

echo "===> sup-peer1"
export CORE_PEER_GOSSIP_BOOTSTRAP="localhost:9051"
ORG="support"
PORT="9050"
PEER_NAME="sup-peer1"
launchPeer
joinChannel

echo "===> sup-peer2"
PORT="10050"
PEER_NAME="sup-peer2"
launchPeer
joinChannel



