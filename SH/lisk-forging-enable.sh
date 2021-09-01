#!/bin/bash

# Gr33nDrag0n - v1.2 2021-09-01
# https://github.com/Gr33nDrag0n69/LiskCore3Tools

# Save your encryption password here to allow automatic enabling.
# Leave it empty for normal behavior
EncryptionPassword=""

#------------------------------------------------------------------------------

NodeSyncing=$( lisk-core node:info | jq -r '.syncing' )

if [ "$NodeSyncing" = false ]
then
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

            if [ -z "$EncryptionPassword" ]
            then
                echo "lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted"
                lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted
            else
                echo "lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted --password ***************"
                lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted --password "$EncryptionPassword"
            fi
        fi

    done
else
    echo "Warning: Node is currently syncing, retry when syncing is completed."
fi
