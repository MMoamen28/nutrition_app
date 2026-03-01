#!/usr/bin/env pwsh
# Setup virtual environment and install Python dependencies
param([switch]$Force)
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $root '..')

if(-not (Get-Command python -ErrorAction SilentlyContinue)){
    Write-Error "Python not found. Install Python from https://python.org and enable 'Add Python to PATH'."
    exit 1
}

$venvPath = Join-Path $PWD '.venv'
if(Test-Path $venvPath -and -not $Force){
    Write-Output "Virtual environment already exists at $venvPath. Use -Force to recreate."
} else {
    python -m venv .venv
}

$py = Join-Path $venvPath 'Scripts\python.exe'
& $py -m pip install --upgrade pip
& $py -m pip install fastapi uvicorn

Write-Output "Setup complete. Run '.\scripts\run.ps1' to start the server."
