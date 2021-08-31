#!/bin/bash

# Gr33nDrag0n - v1.1 2021-08-30
# https://github.com/Gr33nDrag0n69/LiskCore3Tools

ForgingStatus=$( lisk-core forging:status )

for Delegate in $(echo "${ForgingStatus}" | jq -rc '.[]'); do

    BinaryAddress=$( echo $Delegate | jq -r '.address' )
    Forging=$( echo $Delegate | jq -r '.forging' )
    DelegateName=$( lisk-core account:get $BinaryAddress | jq -r '.dpos.delegate.username' )
    if [ "$Forging" = true ]
    then
        echo "lisk-core forging:disable $BinaryAddress"
        lisk-core forging:disable $BinaryAddress
    else
        echo "$DelegateName is already NOT forging."
    fi

done
