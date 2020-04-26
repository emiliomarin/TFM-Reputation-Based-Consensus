# Sets the FABRIC_CA_CLIENT_HOME based on (a) org (b) enrollment ID
function usage {
    echo    "Usage:. ./setclient.sh   ORG-Name   Enrollment-ID"

    echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
}

if [ -z $1 ];
then
    usage
    echo   "Please provide ORG-Name & enrollment ID"
    exit 0
fi

if [ -z $2 ];
then
    usage
    echo   "Please provide enrollment ID"
    exit 0
fi

# Sett the client home to specified folder
export FABRIC_CA_CLIENT_HOME=$PWD/../client/$1/$2
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
