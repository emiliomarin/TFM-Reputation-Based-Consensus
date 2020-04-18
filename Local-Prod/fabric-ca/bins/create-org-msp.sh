# This script will create the MSP information for the organization
# The MSP for the organizations are embedded in the genesis block
# It will consist on the CA  cert and org admin certificate

export FABRIC_CA_CLIENT_HOME=$PWD/../client
export FABRIC_CA_SERVER_HOME=$PWD/../server

function    setup_msp() {
    # Set the destination as ORG folder
    source set-client-home.sh $ORG_NAME  admin

    # Path to the CA certificate
    ROOT_CA_CERTIFICATE=$FABRIC_CA_SERVER_HOME/ca-cert.pem

    # Parent folder for the MSP folder
    DESTINATION_CLIENT_HOME="$FABRIC_CA_CLIENT_HOME/.."

    # Create the required MSP subfolders
    mkdir -p $DESTINATION_CLIENT_HOME/msp/admincerts 
    mkdir -p $DESTINATION_CLIENT_HOME/msp/cacerts 
    mkdir -p $DESTINATION_CLIENT_HOME/msp/keystore

    #1. Copy the Root CA Cert
    cp $ROOT_CA_CERTIFICATE $DESTINATION_CLIENT_HOME/msp/cacerts

    #2. Copy the admin certs - ORG admin is the admin for the specified Org
    cp $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts         
}

# Setup the MSP for Support organization
export ORG_NAME=support
setup_msp

# Setup the MSP for tfm organization
export ORG_NAME=tfm
setup_msp

echo "Created MSP for all Organizations!"
