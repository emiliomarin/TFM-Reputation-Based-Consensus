# Script to automate even more the launch of the network and speed everything up.

# Create Genesis block and Channel TX
echo "****** Creating Genesis Block and Channel TX ******"

./gen-config.sh

# Launch orderer
echo "****** Launching Orderer ******"
./launch-orderer.sh &
