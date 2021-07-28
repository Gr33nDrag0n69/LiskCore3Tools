#!/bin/bash

# Gr33nDrag0n
# https://github.com/Gr33nDrag0n69/LiskCore3Tools

ForgingStatus=$( lisk-core forging:status )

for Delegate in $(echo "${ForgingStatus}" | jq -rc '.[]'); do

    BinaryAddress=$( echo $Delegate | jq -r '.address' )
    Forging=$( echo $Delegate | jq -r '.forging' )
    DelegateName=$( lisk-core account:get $BinaryAddress | jq -r '.dpos.delegate.username' )
    if [ "$Forging" = true ]
    then
        while true; do
            read -p "Disable Forging on $DelegateName?" yn 
            case $yn in

                [Yy]* )
                    echo "lisk-core forging:disable $BinaryAddress"
                    lisk-core forging:disable $BinaryAddress
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
    else
        echo "$DelegateName is already NOT forging."
    fi

done
