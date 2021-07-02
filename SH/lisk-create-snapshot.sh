#!/bin/bash -e

# Gr33nDrag0n
# https://github.com/Gr33nDrag0n69/LiskCore3Tools

OUTPUT_DIRECTORY="/opt/nginx/testnet3-snapshot.lisknode.io"
OUTPUT_GZIP_FILENAME="blockchain.db.tar.gz"
OUTPUT_GZIP_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_FILENAME}"
OUTPUT_HASH_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_FILENAME}.SHA256"

DAYS_TO_KEEP="3" # Use 0 to disable the feature
#PM2_CONFIG="~/lisk-core.pm2.json"

### Function(s) #######################################################################################################

now() {
    date +'%Y-%m-%d %H:%M:%S'
}

### MAIN ##############################################################################################################

# Required for lisk-core command availability in crontab job.
export PATH="$PATH:$HOME/lisk-core/bin"

echo -e "$(now) Get Blockchain Height"

NODEINFO_JSON=$( lisk-core node:info )

if [ -z "${NODEINFO_JSON}" ]; then
    echo  -e "$(now) ERROR: Node Info is invalid. Aborting..."
    exit 1
fi

HEIGHT=$( echo $NODEINFO_JSON | jq '.height' )
echo -e "$(now) Blockchain Height: ${HEIGHT}"

#echo -e "$(now) Stop Lisk-Core & Wait 3 seconds"
#pm2 stop lisk-core --silent && sleep 3

echo -e "$(now) Create ${OUTPUT_GZIP_FILENAME}"
lisk-core blockchain:export --output "${OUTPUT_DIRECTORY}"

#echo -e "$(now) Start Lisk-Core"
#pm2 start ~/lisk-core.pm2.json --silent

echo -e "$(now) Create ${OUTPUT_GZIP_FILENAME}.SHA256"
cd "${OUTPUT_DIRECTORY}" && sha256sum "${OUTPUT_GZIP_FILENAME}" > "$OUTPUT_HASH_FILEPATH"

OUTPUT_GZIP_COPY_FILENAME="blockchain-${HEIGHT}.db.tar.gz"
OUTPUT_GZIP_COPY_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_COPY_FILENAME}"
OUTPUT_HASH_COPY_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_COPY_FILENAME}.SHA256"

echo -e "$(now) Create ${OUTPUT_GZIP_COPY_FILENAME}"
cp "${OUTPUT_GZIP_FILEPATH}" "${OUTPUT_GZIP_COPY_FILEPATH}"

echo -e "$(now) Create ${OUTPUT_GZIP_COPY_FILENAME}.SHA256"
cd "${OUTPUT_DIRECTORY}" && sha256sum "${OUTPUT_GZIP_COPY_FILENAME}" > "$OUTPUT_HASH_COPY_FILEPATH"

echo -e "$(now) Update new files permissions"
chmod 644 "$OUTPUT_GZIP_FILEPATH"
chmod 644 "$OUTPUT_HASH_FILEPATH"
chmod 644 "$OUTPUT_GZIP_COPY_FILEPATH"
chmod 644 "$OUTPUT_HASH_COPY_FILEPATH"

if [ "$DAYS_TO_KEEP" -gt 0 ]; then
    echo -e "$(now) Deleting snapshots older then $DAYS_TO_KEEP day(s)"
    mkdir -p "$OUTPUT_DIRECTORY" &> /dev/null
    find "$OUTPUT_DIRECTORY" -name "blockchain-*.db.tar.gz*" -mtime +"$(( DAYS_TO_KEEP - 1 ))" -exec rm {} \;
fi

exit 0
