#!/bin/bash

# Gr33nDrag0n - v1.0
# https://github.com/Gr33nDrag0n69/LiskCore3Tools

ForgingStatus=$( lisk-core forging:status )

for Delegate in $(echo "${ForgingStatus}" | jq -rc '.[]'); do

    BinaryAddress=$( echo $Delegate | jq -r '.address' )
    Forging=$( echo $Delegate | jq -r '.forging' )
    DelegateName=$( lisk-core account:get $BinaryAddress | jq -r '.dpos.delegate.username' )
    if [ "$Forging" = true ]
    then
        echo "$DelegateName is already forging."
    else
        while true; do
            read -p "Enable Forging on $DelegateName?" yn 
            case $yn in

                [Yy]* )
                    Height=$( echo $Delegate | jq -r '.height // 0' )
                    MaxHeightPreviouslyForged=$( echo $Delegate | jq -r '.maxHeightPreviouslyForged // 0' )
                    MaxHeightPrevoted=$( echo $Delegate | jq -r '.maxHeightPrevoted // 0' )
                    echo "lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted"
                    lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted
                    break
                ;;

                [Nn]* )
                    break
                    ;;

                * )
                    echo "Please answer yes or no."
                    ;;
            esac
        done
    fi

done
