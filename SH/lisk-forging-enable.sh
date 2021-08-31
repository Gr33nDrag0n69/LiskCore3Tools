#!/bin/bash

# Gr33nDrag0n - v1.1 2021-08-30
# https://github.com/Gr33nDrag0n69/LiskCore3Tools

# Save your encryption passphrase here to allow automatic enabling.
# Leave it empty for normal behavior
EncryptionPassphrase=""

ForgingStatus=$( lisk-core forging:status )

for Delegate in $(echo "${ForgingStatus}" | jq -rc '.[]'); do

    BinaryAddress=$( echo $Delegate | jq -r '.address' )
    Forging=$( echo $Delegate | jq -r '.forging' )
    DelegateName=$( lisk-core account:get $BinaryAddress | jq -r '.dpos.delegate.username' )
    if [ "$Forging" = true ]
    then
        echo "$DelegateName is already forging."
    else
        echo "Enabling forging on $DelegateName."
        Height=$( echo $Delegate | jq -r '.height // 0' )
        MaxHeightPreviouslyForged=$( echo $Delegate | jq -r '.maxHeightPreviouslyForged // 0' )
        MaxHeightPrevoted=$( echo $Delegate | jq -r '.maxHeightPrevoted // 0' )

        if [ -z "$EncryptionPassphrase" ]
        then
            echo "lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted"
            lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted
        else
            echo "lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted --password ***************"
            lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted --password "$EncryptionPassphrase"
        fi
    fi

done
