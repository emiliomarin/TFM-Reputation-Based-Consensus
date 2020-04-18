# This script is used to create/Enroll the Orderer's identity + Sets up MSP for orderer

# Identity of the orderer will be created by the admin from the support org
source set-client-home.sh support admin

# Register the orderer identity
fabric-ca-client register --id.type orderer --id.name orderer --id.secret pw --id.affiliation support 
echo "  => Completed: Registered orderer (can be done only once)"

# Hold the admin MSP localtion in a variable
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

# Change the client context to orderer identity
source set-client-home.sh support orderer

# Orderer identity is enrolled

fabric-ca-client enroll -u http://orderer:pw@localhost:7054
echo "  => Completed: Enrolled orderer "

# 6. Copy the admincerts to the appropriate folder
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $ADMIN_CLIENT_HOME/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

echo "  => Completed: MSP setup for the orderer"





