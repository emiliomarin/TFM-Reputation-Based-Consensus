# This script is used for generation of he genesis block and the  channel tx file

export FABRIC_CFG_PATH=../../config

# Genesis block generation
configtxgen -profile TFMOrdererGenesis -outputBlock ../../artefacts/tfm-genesis.block -channelID ordererchannel

# Channel creation
configtxgen -profile TFMChannel -outputCreateChannelTx ../../artefacts/tfm-channel.tx -channelID tfmchannel
