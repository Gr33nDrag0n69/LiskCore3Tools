#!/bin/bash

# Gr33nDrag0n - v1.2.0 2021/09/12
# https://github.com/Gr33nDrag0n69/LiskCore3Tools

LiskHQ_TopHeight=$( curl -s https://snapshots.lisk.io/main/ | sed -r 's/.*href="([^"]+).*/\1/g' | grep "blockchain-.*.db.tar.gz" | grep -v "SHA256"  | sed 's/[^0-9]*//g' | sort -nru | head -n1 )
Gr33nDrag0n_TopHeight=$( curl -s https://snapshot.lisknode.io/ | sed -r 's/.*href="([^"]+).*/\1/g' | grep "blockchain-.*.db.tar.gz" | grep -v "SHA256"  | sed 's/[^0-9]*//g' | sort -nru | head -n1 )
Corsaro_TopHeight=$( curl -s https://snapshot.liskworld.info/ | sed -r 's/.*href="([^"]+).*/\1/g' | grep "blockchain-.*.db.tar.gz" | grep -v "SHA256"  | sed 's/[^0-9]*//g' | sort -nru | head -n1 )

DomainList=("lisk.io by LiskHQ             [$LiskHQ_TopHeight]" "lisknode.io by Gr33nDrag0n    [$Gr33nDrag0n_TopHeight]" "liskworld.info by Corsaro     [$Corsaro_TopHeight]")
PS3="Select Download Server: "
COLUMNS=1

select Domain in "${DomainList[@]}"
do
    case $REPLY in
        "1")
            URL="https://snapshots.lisk.io/main/blockchain.db.tar.gz"
            break
            ;;

        "2")
            URL="https://snapshot.lisknode.io/blockchain.db.tar.gz"
            break
            ;;

        "3")
            URL="https://snapshot.liskworld.info/blockchain.db.tar.gz"
            break
            ;;
    esac
done

rm -f ~/blockchain.db.tar.gz
rm -f ~/blockchain.db.tar.gz.SHA256

lisk-core blockchain:download --url $URL --output ~/

if [ $? -eq 0 ]
then
    pm2 stop lisk-core --silent && sleep 3
    lisk-core blockchain:import ~/blockchain.db.tar.gz --force
    pm2 start ~/lisk-core.pm2.json --silent
fi

rm -f ~/blockchain.db.tar.gz
rm -f ~/blockchain.db.tar.gz.SHA256
