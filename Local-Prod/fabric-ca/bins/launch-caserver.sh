# Launches the CA server
export FABRIC_CA_SERVER_HOME=$PWD/../server

fabric-ca-server -n ca.tfm.com start --cfg.identities.allowremove

