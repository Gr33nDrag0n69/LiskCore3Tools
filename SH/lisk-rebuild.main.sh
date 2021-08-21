#!/bin/bash

# Gr33nDrag0n
# https://github.com/Gr33nDrag0n69/LiskCore3Tools

URL="https://snapshot.lisknode.io/blockchain.db.tar.gz"
lisk-core blockchain:download --url $URL --output ~/
pm2 stop lisk-core --silent && sleep 3
lisk-core blockchain:import ~/blockchain.db.tar.gz --force
pm2 start ~/lisk-core.pm2.json --silent
rm -f ~/blockchain.db.tar.gz
rm -f ~/blockchain.db.tar.gz.SHA256
