
# Script to generate the certificates for the admins of each organization
# tfm-admin and orderer-admin

# Registers the admins
function registerAdmins {
    # Set the CA Server Admin as FABRIC_CA_CLIENT_HOME
    #    This the Registrar identity
    source set-client-home.sh   caserver   admin

    # 2. Register orderer-admin
    echo "Registering: support-admin"
    ATTRIBUTES='"hf.Registrar.Roles=peer,orderer,user,client"'
    fabric-ca-client register --id.type client --id.name support-admin --id.secret pw --id.affiliation support --id.attrs $ATTRIBUTES
    
    # 3. Register tfm-admin
    echo "Registering: tfm-admin"
    ATTRIBUTES='"hf.Registrar.Roles=peer,orderer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
    fabric-ca-client register --id.type client --id.name tfm-admin --id.secret pw --id.affiliation tfm --id.attrs $ATTRIBUTES
}

# Setup MSP
function setupMSP {
    mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts

    echo "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"
    cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
}

# Enroll admin
function enrollAdmins {

    # 1. support-admin
    echo "Enrolling: support-admin"

    export ORG_NAME="support"
    source set-client-home.sh   $ORG_NAME   admin
    # Enroll the admin identity
    fabric-ca-client enroll -u http://support-admin:pw@localhost:7054
    # Setup the MSP for the support
    setupMSP


    # 2. tfm-admin
    echo "Enrolling: tfm-admin"

    export ORG_NAME="tfm"
    source set-client-home.sh   $ORG_NAME   admin
    # Enroll the admin identity
    fabric-ca-client enroll -u http://tfm-admin:pw@localhost:7054
    # Setup the MSP for tfm
    setupMSP

}

echo "------ Registering ------"
#1. CA Registrar will register the Org Admins
registerAdmins

echo "------ Enrolling ------"
#2. Each Org Admin will then enroll & get the certs
enrollAdmins
