# PowerShell Scripts

- [PowerShell Scripts](#powershell-scripts)
  - [Test-LiskCoreAPI.ps1](#test-liskcoreapips1)
    - [Windows](#windows)
    - [Linux](#linux)
  - [Test-LiskService.ps1](#test-liskserviceps1)

## Test-LiskCoreAPI.ps1

Lisk-Core 3 HTTP API Query Examples.

[Source](https://github.com/Gr33nDrag0n69/LiskCore3Tools/blob/main/PS1/Test-LiskCoreAPI.ps1)

### Windows

- Open PowerShell.
  
- Go to your work directory.
  
  ```powershell
  Set-Location  D:\Scripts\
  ```

- Save the script.

  ```powershell
  $URI = 'https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/PS1/Test-LiskCoreAPI.ps1'
  Invoke-WebRequest -Uri $URI -OutFile Test-LiskCoreAPI.ps1 -Verbose
  ```

- Open the script with a text editor & edit the configuration section at the top.

- Run the script.
  
  ```powershell
  .\Test-LiskCoreAPI.ps1
  ```

###  Linux

- Install PowerShell 7 for Linux

  ```bash
  sudo apt-get update
  sudo apt-get install -y powershell
  ```

- Go to your work directory.
  
  ```bash
  cd ~/
  ```

- Save the script.

  ```bash
  curl -s -O -L "https://raw.githubusercontent.com/Gr33nDrag0n69/LiskCore3Tools/main/PS1/Test-LiskCoreAPI.ps1"
  ```

- Open the script with a text editor & edit the configuration section at the top.

- Run the script.
  
  ```bash
  pwsh "~/Test-LiskCoreAPI.ps1"
  ```

## Test-LiskService.ps1

TODO
