
# Init. #######################################################################

$Global:ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Clear-Host

# Configuration ###############################################################

$Config = @{
    API = 'https://testnet3-api.lisknode.io/'
    Account = @(
        'da0fe279669a8395d58e47a7fcda5bfbdb37f82b',
        'dea5007ff22309f3687da052b5bd8b7ae29e1ab6',
        '62dbc020b55bbb629b11f6cdb585c4f97028666e',
        '6d3152dad65958ec721914ebe1a0eabc62b44993',
        '55e5c36d4a831b6656499bd59f0b498c4aa60b89',
        '9a80e251eac81347545c2646464ecf0f272a89b6',
        '03307c00c4e2144ee3760b9ac2f30ea99e8d0d13',
        'ce0dac5fcc3daf96bf07f0d550a26ec91a310623',
        '21119a9d117eaf3de4fe44c8470dc7ddd3b6747e',
        'aaedd508db9c33581ec406018b56b9e9dd6866ee',
        'eec12d128b880ffd3deb18b62dc023a31d396c5a'
        )
    Delegate = @(
        'da0fe279669a8395d58e47a7fcda5bfbdb37f82b',
        'dea5007ff22309f3687da052b5bd8b7ae29e1ab6',
        '62dbc020b55bbb629b11f6cdb585c4f97028666e',
        '6d3152dad65958ec721914ebe1a0eabc62b44993',
        '55e5c36d4a831b6656499bd59f0b498c4aa60b89',
        '9a80e251eac81347545c2646464ecf0f272a89b6',
        '03307c00c4e2144ee3760b9ac2f30ea99e8d0d13',
        'ce0dac5fcc3daf96bf07f0d550a26ec91a310623',
        '21119a9d117eaf3de4fe44c8470dc7ddd3b6747e',
        'aaedd508db9c33581ec406018b56b9e9dd6866ee'
        )
    PublicNode = @(
        'https://testnet3-api.lisknode.io/'
    )
}

# Function(s) #################################################################

Function Invoke-LiskApiCall {

    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $True)]
        [System.String] $URI,

        [parameter(Mandatory = $True)]
        [ValidateSet('Get','Post','Put')]
        [System.String] $Method,

        [parameter(Mandatory = $False)]
        [System.Collections.Hashtable] $Body = @{}
        )

    Write-Verbose "Invoke-LiskApiCall [$Method] => $URI"

    if( $Method -eq 'Get' ) {
        $Private:WebRequest = Invoke-WebRequest -UseBasicParsing -Uri $URI -Method $Method
    } elseif( ( $Method -eq 'Post' ) -or ( $Method -eq 'Put' ) ) {
        $Private:WebRequest = Invoke-WebRequest -UseBasicParsing -Uri $URI -Method $Method -Body $Body
    }

    if( ( $WebRequest.StatusCode -eq 200 ) -and ( $WebRequest.StatusDescription -eq 'OK' ) ) {
        $WebRequest.Content | ConvertFrom-Json | Select-Object -ExpandProperty Data
    } else {
        Write-Warning "Invoke-LiskApiCall | WebRequest returned Status '$($WebRequest.StatusCode) $($WebRequest.StatusDescription)'."
    }
}

# Main ########################################################################

## Account

$AccountList = @()

ForEach( $AccountBinaryAddress in $Config.Account ) {

    $Account = Invoke-LiskApiCall -Method Get -URI $( $Config.API + 'api/accounts/'+$AccountBinaryAddress )
    
    $AvailableBalance = $Account.Token.Balance / 100000000
    $VotingBalance = $( $Account.dpos.sentVotes.amount | Measure-Object -Sum | Select-Object -ExpandProperty Sum ) / 100000000

    $AccountList += [PSCustomObject]@{
        Address = $AccountBinaryAddress
        AvailableBalance = $AvailableBalance
        VotingBalance = $VotingBalance
        TotalBalance = $AvailableBalance + $VotingBalance
    }
}

Write-Host '# Account' -ForegroundColor Cyan
$AccountList | Format-Table

## Delegate

$DelegateList = @()

ForEach( $AccountBinaryAddress in $Config.Delegate ) {

    $Account = Invoke-LiskApiCall -Method Get -URI $( $Config.API + 'api/accounts/'+$AccountBinaryAddress )

    $DelegateList += [PSCustomObject]@{
        Name = $Account.dpos.delegate.username
        TotalVote = $Account.dpos.delegate.totalVotesReceived / 100000000
        ConsecutiveMissedBlocks = $Account.dpos.delegate.consecutiveMissedBlocks
        LastForgedHeight = $Account.dpos.delegate.lastForgedHeight
    
    }
}

Write-Host '# Delegate' -ForegroundColor Cyan
$DelegateList | Format-Table

## Public Node

Write-Host "# Public Node`r`n" -ForegroundColor Cyan

$NodeList = @()

ForEach( $NodeUrl in $Config.PublicNode ) {

    $Node = Invoke-LiskApiCall -Method Get -URI $( $NodeUrl + 'api/node/info' )

    $NodeList += $Node | Select-Object -Property @{Name = 'URL'; Expression = {$NodeUrl}}, Version, NetworkVersion, Height, FinalizedHeight, Syncing, UnconfirmedTransactions
}

$NodeList | Format-Table

## Peers

Write-Host "# Peers`r`n" -ForegroundColor Cyan

$PeerList = Invoke-LiskApiCall -Method Get -URI $( $Config.API + 'api/peers' ) | `
                Select-Object -Property `
                    @{Name = 'IP'; Expression = {$_.IpAddress}}, `
                    Port, `
                    @{Name = 'Height'; Expression = {$_.options.height}}, `
                    Nonce, `
                    AdvertiseAddress

$TopHeight = $PeerList.Height | Sort-Object -Unique -Descending | Select-Object -First 1
Write-Host "TopHeight : $TopHeight`r`n" -ForegroundColor White

$PeerList | FT
