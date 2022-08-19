#!/bin/bash

while true
do

# Logo
source ~/.bash_profile

echo "============================================================"
curl -s https://raw.githubusercontent.com/AlekseyMoskalev1/script/main/Noders.sh | bash
echo "============================================================"


PS3='Select an action: '
options=(
"Prepare the server for installation" 
"Install STRIDE Node" 
"Create wallet"
"Recover wallet"
"Log Node" 
"Check node status" 
"Request for tokens in Discord" 
"Parametrs and balance" 
"Create validator" 
"Check validator"
"Exit")
select opt in "${options[@]}"
               do
                   case $opt in
                   
"Prepare the server for installation")
echo "============================================================"
echo "Preparation has begun"
echo "============================================================"

#INSTALL DEPEND
echo "============================================================"
echo "Update and install APT"
echo "============================================================"
sleep 3
sudo apt update && sudo apt upgrade -y && \
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

#INSTALL GO
echo "============================================================"
echo "Install GO 1.18.3"
echo "============================================================"
sleep 3
wget https://golang.org/dl/go1.18.3.linux-amd64.tar.gz; \
rm -rv /usr/local/go; \
tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz && \
rm -v go1.18.3.linux-amd64.tar.gz && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile && \
source ~/.bash_profile && \
go version > /dev/null

echo "============================================================"
echo "The server is ready!"
echo "============================================================"
break
;;
            
"Install STRIDE Node")
echo "============================================================"
echo "Set parameters"
echo "============================================================"
echo "Enter NodName:"
echo "============================================================"
                
read STRIDENODE
STRIDENODE=$STRIDENODE
echo 'export STRIDENODE='${STRIDENODE} >> $HOME/.bash_profile

echo "============================================================"
echo "Enter WalletName:"
echo "============================================================"
               
read STRIDEWALLET
STRIDEWALLET=$STRIDEWALLET
echo 'export STRIDEWALLET='${STRIDEWALLET} >> $HOME/.bash_profile
STRIDECHAIN=""STRIDE-TESTNET-4""
echo 'export STRIDECHAIN='${STRIDECHAIN} >> $HOME/.bash_profile
source $HOME/.bash_profile

echo "============================================================"
echo "Installation started"
echo "============================================================"
git clone https://github.com/Stride-Labs/stride.git && cd stride
git checkout cf4e7f2d4ffe2002997428dbb1c530614b85df1b
make build
mkdir -p $HOME/go/bin
sudo mv build/strided /root/go/bin/
strided version

strided init $STRIDENODE --chain-id $STRIDECHAIN

strided tendermint unsafe-reset-all --home $HOME/.stride
rm $HOME/.stride/config/genesis.json
wget -O $HOME/.stride/config/genesis.json "https://raw.githubusercontent.com/Stride-Labs/testnet/main/poolparty/genesis.json"

SEEDS=""
PEERS="54a11c47658ebd5dcbd70eb3c62197b439482d3f@116.202.236.115:21016"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.stride/config/config.toml

# config pruning
indexer="null"
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.stride/config/config.toml
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.stride/config/app.toml



tee $HOME/strided.service > /dev/null <<EOF
[Unit]
Description=stride
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which strided) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/strided.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable strided
sudo systemctl restart strided

echo "============================================================"
echo "Installation complete!"
echo "============================================================"
break
;;

"Recover wallet")

strided keys add $STRIDEWALLET --recover
STRIDEADDRWALL=$(strided keys show $STRIDEWALLET -a)
STRIDEVAL=$(strided keys show $STRIDEWALLET --bech val -a)
echo 'export STRIDEVAL='${STRIDEVAL} >> $HOME/.bash_profile
echo 'export STRIDEADDRWALL='${STRIDEADDRWALL} >> $HOME/.bash_profile
source $HOME/.bash_profile

echo "============================================================"
echo "Wallet addres: $STRIDEADDRWALL"
echo "Valoper addres: $STRIDEVAL"
echo "============================================================"

break
;;

"Create wallet")
echo "============================================================"
echo "Save mnemonic!"
echo "============================================================"
               
strided keys add $STRIDEWALLET
STRIDEADDRWALL=$(strided keys show $STRIDEWALLET -a)
STRIDEVAL=$(strided keys show $STRIDEWALLET --bech val -a)
echo 'export STRIDEVAL='${STRIDEVAL} >> $HOME/.bash_profile
echo 'export STRIDEADDRWALL='${STRIDEADDRWALL} >> $HOME/.bash_profile
source $HOME/.bash_profile

echo "============================================================"
echo "Wallet addres: $STRIDEADDRWALL"
echo "Valoper addres: $STRIDEVAL"
echo "============================================================"
               
break
;;

"Check node status")
echo "============================================================"
echo "Synchronization status must be false to continue!"
echo "============================================================"
echo "Synchronization status = $(curl -s localhost:26657/status)"
echo "Block height = $(strided status 2>&1 | jq ."SyncInfo"."latest_block_height")"
echo "Skipped Blocks and Validator Creation Block $(strided q slashing signing-info $(strided tendermint show-validator))"
echo "============================================================"
break
;;

"Create validator")
echo "============================================================"
echo "Synchronization status must be false to continue!"
echo "Synchronization status = $(curl -s localhost:26657/status)"
echo "============================================================"
               
strided tx staking create-validator \
  --amount 1000000ustrd \
  --from $STRIDEWALLET \
  --commission-max-change-rate "0.05" \
  --commission-max-rate "0.20" \
  --commission-rate "0.05" \
  --min-self-delegation "1" \
  --pubkey $(strided tendermint show-validator) \
  --moniker $STRIDENODE \
  --chain-id $STRIDECHAIN \
  --gas 300000 \
  -y
break
;;

"Parametrs and balance")
echo "============================================================"
echo "Your parameters"
echo "============================================================"
echo "Name Node: $STRIDENODE"
echo "Address: $STRIDEADDRWALL" 
echo "Your balance: $(strided query bank balances $STRIDEADDRWALL)"
echo "============================================================"
break
;;

"Check validator") 
echo "============================================================"
echo "Account request: $(strided q auth account $(strided keys show $STRIDEADDRWALL -a) -o text)"
echo "Validator info: $(strided q staking validator $STRIDEVAL)"
echo "============================================================"
break
;;

"Request for tokens in Discord")
request=$request
echo "============================================================"
echo "To request tokens, you need to go to the Discord server in the
fauccet channel and request tokens.
Server in Discord - https://discord.gg/ebR5Rc7q"
echo "============================================================"
echo -e "Copy and paste this \033[32m \$faucet-stride:$STRIDEADDRWALL \033[37m"
echo "============================================================"
break
;;

"Log Node")
journalctl -u strided -f -o cat
break
;;

"Delete node")
systemctl stop strided
systemctl disable strided
rm /etc/systemd/system/strided.service
rm -rf .stride strided
break
;;

"Exit")
exit
;;

*) echo "invalid option $REPLY";;
esac
done
done
