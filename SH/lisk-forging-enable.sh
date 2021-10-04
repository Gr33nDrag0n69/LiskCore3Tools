#!/bin/bash

###############################################################################
# Author  :   Gr33nDrag0n
# Version :   1.4.0
# GitHub  :   https://github.com/Gr33nDrag0n69/LiskCore3Tools
# History :   2021/10/04 - v1.4.0
#             2021/09/20 - v1.3.2
#             2021/09/19 - v1.3.1
#             2021/09/18 - v1.3.0
#             2021/09/01 - v1.2.0
#             2021/08/30 - v1.1.0
#             2021/07/28 - v1.0.0
###############################################################################

# Default Configuration

# Save your encryption password here to allow automatic enabling.
EncryptionPassword=""

LiskCoreBinaryFullPath="$HOME/lisk-core/bin/lisk-core"
WaitDelay=0
RetryDelay=180
MaxRetry=20
Debug=false

#------------------------------------------------------------------------------

if [ ! -f "$LiskCoreBinaryFullPath" ]
then
    echo "Error: lisk-core Binary NOT FOUND! Edit 'LiskCoreBinaryFullPath' value & retry. Aborting..." >&2
    exit 1
fi

if [ $WaitDelay -gt 0 ]
then
    echo "Waiting $WaitDelay second(s) before execution."
    sleep $WaitDelay
fi

NetworkIdentifier=$( "$LiskCoreBinaryFullPath" node:info 2>/dev/null | jq -r '.networkIdentifier' )

if [ -z "$NetworkIdentifier" ]
then
    echo "Error: 'lisk-core node:info' is empty. Validate the lisk-core process is currently running." >&2
    exit 1
fi

case $NetworkIdentifier in
    "4c09e6a781fc4c7bdb936ee815de8f94190f8a7519becd9de2081832be309a99")
        # MAINNET
        TopHeightUrl="https://api.lisknode.io/api/peers"
        MinHeight=16500000
        ;;

    "15f0dacc1060e91818224a94286b13aa04279c640bd5d6f193182031d133df7c")
        # TESTNET
        TopHeightUrl="https://testnet3-api.lisknode.io/api/peers"
        MinHeight=14600000
        ;;

    *)
        # Invalid Network
        echo "Error: 'lisk-core node:info' NetworkIdentifier is INVALID." >&2
        exit 1
        ;;
esac

### FUNCTIONS

parse_option() {

    while [[ $1 = -?* ]]
    do
        case "$1" in
            -p | --password) shift; EncryptionPassword="${1}" ;;
            -b | --binarypath) shift; LiskCoreBinaryFullPath="${1}" ;;
            -w | --wait) shift; WaitDelay="${1}" ;;
            -r | --retrydelay) shift; RetryDelay="${1}" ;;
            -m | --maxretry) shift; MaxRetry="${1}" ;;
            -a | --api) shift; TopHeightUrl="${1}" ;;
            -h | --help) usage; exit 1 ;;
            -d | --debug) Debug=true ;;
            --endopts) shift; break ;;
            *) echo "invalid option: '$1'."; exit 1 ;;
            esac
        shift
    done
}

usage() {
      cat <<EOF_USAGE
Usage: $0 [-p "EncryptionPassword"] [-b "LiskCoreBinaryFullPath"] [-w WaitDelay] [-r RetryDelay] [-m MaxRetry] [-a "TopHeightUrl"] [-d]

Available options:

-p, --password "EncryptionPassword"

    Encryption Password.
    Default value: '$EncryptionPassword'.

-b, --binarypath "LiskCoreBinaryFullPath"

    Full path of the lisk-core binary.
    Default value: '$LiskCoreBinaryFullPath'.

-w, --wait WaitDelay

    Automation: Wait X seconds. Allow the lisk-core process to start before execution of this script.
    If using this script with a cronjob, make sure to set this value to at least 3 seconds.
    Default value: '$WaitDelay'.

-r, --retrydelay RetryDelay

    Automation: If node is syncing, retry each X seconds.
    Default value: '$RetryDelay'.

-m, --maxretry MaxRetry

    Automation: Max number of retry.
    Default value: '$MaxRetry'.

-a, --api "TopHeightUrl"

    The script check for TopHeight using this API URL.
    Default value: '$TopHeightUrl'.

    Public nodes:

        # Main Net
        gr33ndrag0n : https://api.lisknode.io/api/peers
        lemii       : https://mainnet-api.lisktools.eu/api/peers
        punkrock    : https://lisk-mainnet-api.punkrock.me/api/peers

        # Test Net
        gr33ndrag0n : https://testnet3-api.lisknode.io/api/peers
        lemii       : https://testnet-api.lisktools.eu/api/peers
        punkrock    : https://lisk-testnet-api.punkrock.me/api/peers

-d, --debug

    Developer: Enable DEBUG mode. Skip 'lisk-core forging:enable' command execution.

EOF_USAGE

}

### MAIN CODE

parse_option "$@"

CurrentTry=1

until [ "$CurrentTry" -gt "$MaxRetry" ]
do
    NodeInfo=$( "$LiskCoreBinaryFullPath" node:info 2>/dev/null )

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
                ForgingStatus=$( "$LiskCoreBinaryFullPath" forging:status )

                for Delegate in $(echo "${ForgingStatus}" | jq -rc '.[]'); do

                    BinaryAddress=$( echo "$Delegate" | jq -r '.address' )
                    Forging=$( echo "$Delegate" | jq -r '.forging' )
                    DelegateName=$( "$LiskCoreBinaryFullPath" account:get "$BinaryAddress" | jq -r '.dpos.delegate.username' )
                    if [ "$Forging" = true ]
                    then
                        echo "$DelegateName is already forging."
                    else
                        echo "Enabling forging on $DelegateName."
                        Height=$( echo "$Delegate" | jq -r '.height // 0' )
                        MaxHeightPreviouslyForged=$( echo "$Delegate" | jq -r '.maxHeightPreviouslyForged // 0' )
                        MaxHeightPrevoted=$( echo "$Delegate" | jq -r '.maxHeightPrevoted // 0' )

                        if [ "$Height" -gt 0 ] && [ "$MaxHeightPreviouslyForged" -gt 0 ] && [ "$MaxHeightPrevoted" -gt 0 ]
                        then
                            if [ -z "$EncryptionPassword" ]
                            then
                                echo "lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted"
                                if [ "$Debug" = false ]
                                then
                                    "$LiskCoreBinaryFullPath" forging:enable "$BinaryAddress" "$Height" "$MaxHeightPreviouslyForged" "$MaxHeightPrevoted"
                                else
                                    echo "DEBUG MODE is ON! Skipping 'lisk-core forging:enable' command execution."
                                fi
                            else
                                echo "lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted --password ***************"
                                if [ "$Debug" = false ]
                                then
                                    "$LiskCoreBinaryFullPath" forging:enable "$BinaryAddress" "$Height" "$MaxHeightPreviouslyForged" "$MaxHeightPrevoted" --password "$EncryptionPassword"
                                else
                                    echo "DEBUG MODE is ON! Skipping 'lisk-core forging:enable' command execution."
                                fi
                            fi
                        else
                            echo "Warning: (POM Protection) The current values countain a 0 value at least for one parameter."
                            echo ''
                            echo "You should use '0 0 0' ONLY IF you enable forging for a delegate that never forged any block."
                            echo ''
                            echo "If it's the case, manually run:"
                            echo "lisk-core forging:enable $BinaryAddress 0 0 0"
                            echo ''
                            echo "If it's NOT the case, the local forger.db is empty and invalid."
                            echo "Import a backup of your delegate 'forger-info' before enabling forging on this server."
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
        sleep "$RetryDelay"
        CurrentTry=$((CurrentTry+1))

    fi
done

echo "Error: Node still syncing after $MaxRetry retry. Aborting..." >&2
exit 1
