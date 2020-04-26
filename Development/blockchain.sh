# Follow pre-requisites for your system:
# https://hyperledger.github.io/composer/latest/installing/installing-prereqs.html


installTools(){
 echo "==> Installing Composer tools"
    npm install -g composer-cli@0.20
    npm install -g composer-rest-server@0.20
    npm install -g generator-hyperledger-composer@0.20
    npm install -g yo
    npm install -g composer-playground@0.20
    npm install -g yarn

    # Install Hyperledger Fabric

    if [ ! -d "fabric-dev-servers" ]; then
        echo "==> Clonning Hyperledger Fabric"
        mkdir ./fabric-dev-servers && cd ./fabric-dev-servers
        curl -O https://raw.githubusercontent.com/hyperledger/composer-tools/master/packages/fabric-dev-servers/fabric-dev-servers.tar.gz
        tar -xvf fabric-dev-servers.tar.gz

    else  
        echo "==> Hyperledger Fabric already installed"
        cd ./fabric-dev-servers
    fi

    echo "==> Downloading Hyperledger Fabric images"
    export FABRIC_VERSION=hlfv12
    ./downloadFabric.sh
    cd ..
}

createNetwork(){
    cd ./fabric-dev-servers
    echo "==> Starting Network"
    ./startFabric.sh
    echo "==> Creating Peer Admin Card"
    ./createPeerAdminCard.sh



    echo "==> Deploying and starting BNA"
    cd ..
    rm -r dist/
    yarn prepublish
    yarn deployBNA
    yarn startBNA

    # Import admin card
    echo "==> Importing Admin Card (Ignore error of Card not found)"
    composer card delete -c admin@tfm
    composer card import -f adminNetwork.card

    echo "==> Starting Rest Server"
    composer-rest-server -c admin@tfm

    echo "==> You are ready to test!!"
}


clean(){
    cd ./fabric-dev-servers
    ./stopFabric.sh
    cd ..
    #rm -r fabric-dev-servers
    rm -r xfer-bna
}

upgradeBNA(){
    rm -r dist/
    yarn prepublish
    yarn deployBNA
    composer network upgrade --networkName tfm --networkVersion $1 --card PeerAdmin@hlfv1
}




if [ $1 = "--fullInstall" ]; then
   installTools
   createNetwork

elif [ $1 = "--createNetwork" ]; then
    createNetwork    
elif [ $1 = "--start" ]; then
    echo "==> Starting Network"

    cd ./fabric-dev-servers
    ./startFabric.sh

elif [ $1 = "--stop" ]; then
    echo "==> Stopping Network"

    cd ./fabric-dev-servers
    ./stopFabric.sh

elif [ $1 = "--clean" ]; then
    clean

elif [ $1 = "--upgrade" ]; then
    upgradeBNA $2
elif [ $1 = "--help" ]; then
    echo "==> --fullInstall : Install all the tools and creates the network -> Starts nodes, create admin peer card, clones bna repo, prepublishes latest BNA, deploys it and start it. Lastly imports the cards and starts the rest server"
    echo
    echo "==> --createNetwork : Creates the network-> Starts nodes, create admin peer card, clones bna repo, prepublishes latest BNA, deploys it and start it. Lastly imports the cards and starts the rest server"
    echo
    echo "==> --clean : removes fabric and bna folders"
    echo
    echo "==> --upgradeBNA 0.2.16 (example) : Installs and upgrades BNA -> IMPORTANT!! REMEMBER TO INCREASE VERSION NUMBER ON PACKAGE.JSON"

fi



