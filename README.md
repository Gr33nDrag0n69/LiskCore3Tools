![##Images_README_Header##](./PNG/Header.png)

Misc. stuff related to lisk-core 3 network.

- [Disclaimer](#disclaimer)
- [General Links](#general-links)
  - [Documentation](#documentation)
- [TestNet Links](#testnet-links)
  - [My Guides](#my-guides)
  - [Explorer](#explorer)
  - [Snapshot](#snapshot)
  - [Public API Endpoints](#public-api-endpoints)
    - [HTTP PlugIn](#http-plugin)
    - [WS (WebSocket)](#ws-websocket)
    - [Lisk-Service](#lisk-service)
  - [Scripts](#scripts)
    - [Bash / Server](#bash--server)
    - [PowerShell / HTTPS API](#powershell--https-api)

# Disclaimer

Valid for Lisk-Core 3 ONLY!

**For most questions, take the time to read official Lisk-Core & Lisk-SDK documentation! [Links below](#documentation)**

# General Links

## Documentation

* [Lisk.io - Lisk-Core Documentation](https://lisk.io/documentation/lisk-core/v3/index.html)
  * [Lisk-Core CLI](https://lisk.io/documentation/lisk-core/v3/reference/cli.html)
  * [Lisk-Core API](https://lisk.io/documentation/lisk-core/v3/reference/api.html)
* [Lisk.io - Lisk-SDK Documentation](https://lisk.io/documentation/lisk-sdk/)

# TestNet Links

## My Guides

* [Rebuild Blockchain From Snapshot](https://github.com/Gr33nDrag0n69/LiskCore3Tools/blob/main/MD/RebuildBlockchainFromSnapshot.md)

## Explorer

* [moosty - LiskScan TestNet Explorer](https://testnet.liskscan.com/)

## Snapshot

* [gr33ndrag0n - testnet3-snapshot.lisknode.io](https://testnet3-snapshot.lisknode.io/)

## Public API Endpoints

### HTTP PlugIn

Copy the address to use it as a base URL for your queries.
Click the link to view the current node info.

* gr33ndrag0n - [https://testnet3-api.lisknode.io](https://testnet3-api.lisknode.io/api/node/info)
* lemii - [https://testnet-api.lisktools.eu](https://testnet-api.lisktools.eu/api/node/info)
* punkrock - [https://lisk-testnet-api.punkrock.me](https://lisk-testnet-api.punkrock.me/api/node/info)

### WS (WebSocket)

* lisk.io - wss://testnet-service.lisk.io/rpc-v2
* SOON gr33ndrag0n - wss://testnet3-api.lisknode.io/ws
* lemii - wss://testnet-api.lisktools.eu/ws
* punkrock - wss://lisk-testnet-api.punkrock.me/ws

### Lisk-Service

Copy the address to use it as a base URL for your queries.
Click the link to view their current status.

* lisk.io - [https://testnet-service.lisk.io/api](https://testnet-service.lisk.io/api/status)
* SOON gr33ndrag0n - [https://testnet3-service.lisknode.io](https://testnet3-service.lisknode.io/api/status)
* lemii - [https://testnet-service.lisktools.eu](https://testnet-service.lisktools.eu/api/status)
* punkrock - [https://lisk-testnet-service.punkrock.me](https://lisk-testnet-service.punkrock.me/api/status)
  
## Scripts

### Bash / Server

* [Enable Delegate Forging](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-enable-forging.sh)
* [Create Snapshot](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-create-snapshot.sh)
* [Rebuild From Snapshot](https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/SH/lisk-rebuild.sh)

### PowerShell / HTTPS API

* [Test Lisk-Core HTTP PlugIn API Endpoints](https://github.com/Gr33nDrag0n69/LiskCore3Tools/blob/main/PS1/Test-LiskCoreAPI.ps1)
* SOON [Test Lisk-Core WebSocket API Endpoints]()
* SOON [Test Lisk-Service API Endpoints]()
