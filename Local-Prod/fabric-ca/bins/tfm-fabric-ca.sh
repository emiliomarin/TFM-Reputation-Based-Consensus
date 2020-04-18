# Script to automate even more the launch of the network and speed everything up.

# Init and starts server, enroll registrar.
echo "****** Initializing and starting CA Server ******"
./init-fabric-ca.sh

./launch-caserver.sh 2> ../server.log &

# Wait a bit
sleep 3

# Setup Admin identities
echo "****** Setting up admin identities ******"
./gen-admin-identities.sh

# Setup Orgs MSP
echo "****** Setting up orgs MSP ******"
./create-org-msp.sh

# Setup Orderer identity
echo "****** Setting up orderer identity ******"
./gen-orderer-identity.sh

# Setup Orderer identity
echo "****** Setting up peers identity ******"
echo "===> tfm-peer1"
ORG="tfm"
PEERNAME="tfm-peer1"
source ./set-client-home.sh $ORG admin
./gen-peer-identity.sh $ORG $PEERNAME
echo "===> tfm-peer2"
PEERNAME="tfm-peer2"
./gen-peer-identity.sh $ORG $PEERNAME

echo "===> sup-peer1"
ORG="support"
PEERNAME="sup-peer1"
source ./set-client-home.sh $ORG admin
./gen-peer-identity.sh $ORG $PEERNAME
echo "===> sup-peer2"
PEERNAME="sup-peer2"
./gen-peer-identity.sh $ORG $PEERNAME