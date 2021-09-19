#!/bin/bash

###############################################################################
# Author  :   Gr33nDrag0n
# Version :   1.3.0
# GitHub  :   https://github.com/Gr33nDrag0n69/LiskCore3Tools
# History :   2021/09/18 - v1.3.0
#             2021/09/01 - v1.2.0
#             2021/08/30 - v1.1.0
#             2021/07/28 - v1.0.0
###############################################################################

# Save your encryption password here to allow automatic enabling.
# Leave it empty for normal behavior
EncryptionPassword=""

# Automation: Wait X seconds. Allow the lisk-core process to start before execution of this script.
# If using this script with a cronjob, make sure to set this value to at least 3 seconds.
WaitDelay=0

# Automation: If node is syncing, retry each X seconds.
RetryDelay=180

# Automation: Max number of retry, assuming 180 sec, default value is 1 hour long.
MaxRetry=20

# When lisk-core is syncing, topheight is calculated using this API URL.

# gr33ndrag0n : https://api.lisknode.io/api/peers
# lemii       : https://mainnet-api.lisktools.eu/api/peers
# punkrock    : https://lisk-mainnet-api.punkrock.me/api/peers

TopHeightUrl="https://api.lisknode.io/api/peers"

# Developer: When set to true, skip 'lisk-core forging:enable' command execution.
# For troubleshooting only.
Debug=false

# Patch: Hard coded minimum block height to start considering Syncing value only.
MinHeight=16500000

#------------------------------------------------------------------------------

if [ $WaitDelay -gt 0 ]
then
    echo "Waiting $WaitDelay second(s) before execution."
    sleep $WaitDelay
fi

CurrentTry=1

until [ $CurrentTry -gt $MaxRetry ]
do
    NodeInfo=$( lisk-core node:info 2>/dev/null )

    if [ -z "$NodeInfo" ]
    then
        echo "Error: 'lisk-core node:info' is empty. Validate the lisk-core process is currently running." >&2
        exit 1
    else
        NodeSyncing=$( echo "$NodeInfo" | jq -r '.syncing' )
        TopHeight=$( curl -s "$TopHeightUrl" | jq '.data[].options.height' | sort -nru | head -n1 )

        if [ "$NodeSyncing" = false ]
        then
            NodeHeight=$( echo "$NodeInfo" | jq -r '.height' )

            if [ "$NodeHeight" -gt "$MinHeight" ]
            then
                ForgingStatus=$( lisk-core forging:status )

                for Delegate in $(echo "${ForgingStatus}" | jq -rc '.[]'); do

                    BinaryAddress=$( echo "$Delegate" | jq -r '.address' )
                    Forging=$( echo "$Delegate" | jq -r '.forging' )
                    DelegateName=$( lisk-core account:get "$BinaryAddress" | jq -r '.dpos.delegate.username' )
                    if [ "$Forging" = true ]
                    then
                        echo "$DelegateName is already forging."
                    else
                        echo "Enabling forging on $DelegateName."
                        Height=$( echo "$Delegate" | jq -r '.height // 0' )
                        MaxHeightPreviouslyForged=$( echo "$Delegate" | jq -r '.maxHeightPreviouslyForged // 0' )
                        MaxHeightPrevoted=$( echo "$Delegate" | jq -r '.maxHeightPrevoted // 0' )

                        if [ -z "$EncryptionPassword" ]
                        then
                            echo "lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted"
                            if [ "$Debug" = false ]
                            then
                                lisk-core forging:enable "$BinaryAddress" "$Height" "$MaxHeightPreviouslyForged" "$MaxHeightPrevoted"
                            else
                                echo "DEBUG MODE is ON! Skipping 'lisk-core forging:enable' command execution."
                            fi
                        else
                            echo "lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted --password ***************"
                            if [ "$Debug" = false ]
                            then
                                lisk-core forging:enable "$BinaryAddress" "$Height" "$MaxHeightPreviouslyForged" "$MaxHeightPrevoted" --password "$EncryptionPassword"
                            else
                                echo "DEBUG MODE is ON! Skipping 'lisk-core forging:enable' command execution."
                            fi
                        fi
                    fi

                done
                exit 0
            else
                echo "Warning : Node is currently in pre-syncing. Retrying in $RetryDelay second(s)..."
            fi
        else
            echo "Warning : Node is currently syncing. Retrying in $RetryDelay second(s)..."
        fi

        echo "          CurrentTry: $CurrentTry | MaxRetry: $MaxRetry | Current Height: $NodeHeight | Top Height: $TopHeight"
        sleep $RetryDelay
        CurrentTry=$((CurrentTry+1))

    fi
done

echo "Error: Node still syncing after $MaxRetry retry. Aborting..." >&2
exit 1
