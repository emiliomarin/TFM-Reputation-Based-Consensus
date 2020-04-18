# This script is used to create the peer identity
# Paremeters: Organization Name and Peer Name

function usage {
    echo "./gen-peer-identity.sh ORG_NAME  PEER_NAME"
    echo "Sets up the Peer identity and MSP"
    echo "Script will fail if CA Server is not running!"
}


if [ -z $1 ];
then
    usage
    echo "Please provide the ORG_NAME!"
    exit 0
else
    ORG_NAME=$1
fi

if [ -z $2 ];
then
    usage
    echo  "Please specify PEER_NAME!"
    exit 0
else
    PEER_NAME=$2
fi

# Set the Identity to Org Admin
source set-client-home.sh $ORG_NAME  admin

# Register the identity
fabric-ca-client register --id.type peer --id.name $PEER_NAME --id.secret pw --id.affiliation $ORG_NAME 
echo "  => Completed: Registered peer (can be done only once)"

# Hold the admin MSP localtion in a variable
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

# Change the client context to Org identity
source set-client-home.sh $ORG_NAME  $PEER_NAME

# Org identity is enrolled
fabric-ca-client enroll -u http://$PEER_NAME:pw@localhost:7054

echo "  => Completed: Enrolled $PEER_NAME "

# Copy the admincerts to the appropriate folder
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $ADMIN_CLIENT_HOME/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

echo "  => Completed: MSP setup for the peer"

echo "  => Peer identity setup with Enrollment ID=$PEER_NAME"

