#!/bin/bash

# Gr33nDrag0n - v1.1 2021/08/28
# https://github.com/Gr33nDrag0n69/LiskCore3Tools

select DOMAIN in lisk.io lisknode.io liskworld.info
do
    case $DOMAIN in
        "lisk.io")
            URL="https://snapshots.lisk.io/main/blockchain.db.tar.gz"
            break
            ;;

        "lisknode.io")
            URL="https://snapshot.lisknode.io/blockchain.db.tar.gz"
            break
            ;;

        "liskworld.info")
            URL="https://snapshot.liskworld.info/blockchain.db.tar.gz"
            break
            ;;
    esac
done

lisk-core blockchain:download --url $URL --output ~/
pm2 stop lisk-core --silent && sleep 3
lisk-core blockchain:import ~/blockchain.db.tar.gz --force
pm2 start ~/lisk-core.pm2.json --silent
rm -f ~/blockchain.db.tar.gz
rm -f ~/blockchain.db.tar.gz.SHA256
