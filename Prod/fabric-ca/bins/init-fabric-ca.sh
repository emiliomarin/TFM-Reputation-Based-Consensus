
# Setup paths
export FABRIC_CA_SERVER_HOME=$PWD/../server
export FABRIC_CA_CLIENT_HOME=$PWD/../client

killall fabric-ca-server
rm -rf $FABRIC_CA_SERVER_HOME/msp 2> /dev/null
rm $FABRIC_CA_SERVER_HOME/* 2> /dev/null
rm -rf $FABRIC_CA_CLIENT_HOME/* 2> /dev/null

# Enroll the CA Registrar
function enroll {
    
    DEFAULT_CLIENT_CONFIG_YAML=../../config/fabric-ca-client-config.yaml

    # Set the client subfolder where crypto will be written for CA Registrar
    export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/caserver/admin

    # Copy the client config for CA Registrar if needed
    mkdir -p $FABRIC_CA_CLIENT_HOME
    echo "Copying the $DEFAULT_CLIENT_CONFIG_YAML to $FABRIC_CA_CLIENT_HOME!!!"
    cp $DEFAULT_CLIENT_CONFIG_YAML  "$FABRIC_CA_CLIENT_HOME/"

    # Execute the enroll
    fabric-ca-client enroll -u http://admin:adminpw@localhost:7054
}

#1 Initialize the server
fabric-ca-server init -b admin:adminpw -n ca.tfm.com 

#2 Start the CA Server
DEFAULT_SERVER_CONFIG_YAML=../../config/fabric-ca-server-config.yaml
cp $DEFAULT_SERVER_CONFIG_YAML $FABRIC_CA_SERVER_HOME
fabric-ca-server start -n ca.tfm.com &

#3 Give time to CA Server to Start
sleep 5

#4 Enroll the CA Registrar
enroll

#5 Kill the CA Server
killall fabric-ca-server

echo "CA Server Re-Initialized!"








