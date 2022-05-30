#!/bin/bash

ip=$(wget -qO- eth0.me)

source $HOME/.bash_profile

JAIL=$(${PROJECT} q staking validator $( echo "${PWDDD}" | ${PROJECT} keys show ${WALLETNAME} --bech val -a) | grep jailed:);
if [[ ${JAIL} == *"false"* ]]; then
    echo -e "${JAIL} \n"
   
    else
    
    MSG="Warning! Server with $ip. Validator in JAIL!"
    MSG="Project $NODENAME $MSG"
    echo -e "${JAIL} \n"
    echo -e $( echo "${PWDDD}" | ${PROJECT} tx slashing unjail --chain-id ${CHAIN_ID} --from ${WALLETNAME} --gas=auto --fees=1000${DENOM} -y) \n;
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG"); exit 1
                  
fi
