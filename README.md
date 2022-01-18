![##Images_README_Header##](./PNG/Header.png)

Misc. stuff related to lisk-core 3 network.

- [MainNet](#mainnet)
  - [Explorer](#explorer)
  - [Lisk-Service](#lisk-service)
  - [Snapshot](#snapshot)
  - [HTTP Legacy API](#http-legacy-api)
  - [WS (WebSocket) API](#ws-websocket-api)
  - [Scripts](#scripts)
    - [Bash](#bash)
- [TestNet](#testnet)
  - [Explorer](#explorer-1)
  - [Lisk-Service](#lisk-service-1)
  - [Snapshot](#snapshot-1)
  - [HTTP Legacy API](#http-legacy-api-1)
  - [WS (WebSocket) API](#ws-websocket-api-1)
  - [Scripts](#scripts-1)
    - [Bash](#bash-1)
    - [PowerShell](#powershell)
- [Other Link(s)](#other-links)

# MainNet

## Explorer

* moosty - [Lisk Scan](https://liskscan.com/)
* carbonara - [Lisk Observer](https://lisk.observer/)

## Lisk-Service

To use with [Lisk Desktop](https://github.com/LiskHQ/lisk-desktop/releases) software or as the **modern API** endpoint. Copy the address to use it as a base URL or click the link to view the current status of the endpoint.

**Documentation: [Lisk Service API](https://lisk.com/documentation/lisk-service/references/api.html)**

* lisk.io - [https://service.lisk.io](https://service.lisk.io/api/status)
* lemii - [https://mainnet-service.lisktools.eu](https://mainnet-service.lisktools.eu/api/status)
* punkrock - [https://lisk-mainnet-service.punkrock.me](https://lisk-mainnet-service.punkrock.me/api/status)
* corsaro - [https://lisk-mainnet-service.liskworld.info ](https://lisk-mainnet-service.liskworld.info/api/status)
* stellardynamic - [https://service.liskapi.io](https://service.liskapi.io/api/status)

## Snapshot

Rebuild a lisk-core database from a blockchain snapshot (hourly automated backup)

**Guide:** [Rebuild Blockchain From Snapshot](https://github.com/Gr33nDrag0n69/LiskCore3Tools/blob/main/MD/RebuildBlockchainFromSnapshot.md)

* gr33ndrag0n - [snapshot.lisknode.io](https://snapshot.lisknode.io/)
* corsaro - [snapshot.liskworld.info](https://snapshot.liskworld.info/)

**Alternate Guide & Server(s):** [sidechainsolutions.io](https://sidechainsolutions.io/snapshots)

## HTTP Legacy API

Copy the address to use it as a base URL or click the link to view the current node info.

**Documentation: [Lisk Core v3 API](https://lisk.io/documentation/lisk-core/v3/reference/api.html)**

* gr33ndrag0n - [https://api.lisknode.io](https://api.lisknode.io/api/node/info)
* lemii - [https://mainnet-api.lisktools.eu](https://mainnet-api.lisktools.eu/api/node/info)
* punkrock - [https://lisk-mainnet-api.punkrock.me](https://lisk-mainnet-api.punkrock.me/api/node/info)

## WS (WebSocket) API

Copy the address to use it as a base URL or use this helper tool I built to explore it: [Lisk WebSocket Explorer](https://wsexplorer.lisknode.io/)

**Documentation: [WebSocket JSON 2.0 RPC API](https://lisk.com/documentation/lisk-service/references/rpc-api.html)**

* gr33ndrag0n - wss://api.lisknode.io/ws
* lemii - wss://mainnet-api.lisktools.eu/ws
* punkrock - wss://lisk-mainnet-api.punkrock.me/ws

## Scripts

### Bash

* [Enable Delegate Forging](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-forging-enable.sh)
* [Disable Delegate Forging](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-forging-disable.sh)
* [Create Snapshot](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-create-snapshot.sh)
* [Rebuild From Snapshot](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-rebuild.main.sh)

# TestNet

## Explorer

* moosty - [LiskScan TestNet Explorer](https://testnet.liskscan.com/)

## Lisk-Service

* lisk.io - [https://testnet-service.lisk.io/api](https://testnet-service.lisk.io/api/status)
* lemii - [https://testnet-service.lisktools.eu](https://testnet-service.lisktools.eu/api/status)
* stellardynamic - [https://testnet.liskapi.io](https://testnet.liskapi.io/api/status)

## Snapshot

* gr33ndrag0n - [testnet3-snapshot.lisknode.io](https://testnet3-snapshot.lisknode.io/)

## HTTP Legacy API

* gr33ndrag0n - [https://testnet3-api.lisknode.io](https://testnet3-api.lisknode.io/api/node/info)
* lemii - [https://testnet-api.lisktools.eu](https://testnet-api.lisktools.eu/api/node/info)

## WS (WebSocket) API

[Lisk TestNet WebSocket Explorer](https://testnet3-wsexplorer.lisknode.io/)

* gr33ndrag0n - wss://testnet3-api.lisknode.io/ws
* lemii - wss://testnet-api.lisktools.eu/ws

## Scripts

### Bash

* [Enable Delegate Forging](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-forging-enable.sh)
* [Disable Delegate Forging](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-forging-disable.sh)
* [Create Snapshot](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-create-snapshot.sh)
* [Rebuild From Snapshot](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-rebuild.test.sh)

### PowerShell

* [Test HTTP API PlugIn](https://github.com/Gr33nDrag0n69/LiskCore3Tools/blob/main/PS1/Test-LiskCoreAPI.ps1)

# Other Link(s)

* stellardynamic - [sidechainsolutions.io](https://sidechainsolutions.io/)
