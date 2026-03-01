#!/usr/bin/env pwsh
# Start the FastAPI server (uvicorn) using the project's virtualenv
param(
    [int]$Port = 8080,
    [switch]$Watchdog,
    [switch]$Bg
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $root '..')

$py = Join-Path $PWD '.venv\Scripts\python.exe'
if(-not (Test-Path $py)){
    Write-Error "Virtualenv python not found. Run .\scripts\setup.ps1 first."
    exit 1
}

$logDir = Join-Path $PWD 'logs'
if(-not (Test-Path $logDir)){ New-Item -ItemType Directory -Path $logDir | Out-Null }
$log = Join-Path $logDir ("uvicorn-$Port.log")

function Start-Foreground {
    Write-Output "Starting uvicorn in foreground on port $Port (logging -> $log)"
    & $py -m uvicorn nutrition_backend.main:app --host 127.0.0.1 --port $Port --log-level info 2>&1 | Tee-Object -FilePath $log -Append
}

function Start-Background {
    Write-Output "Starting uvicorn in background on port $Port (logging -> $log)"
    Start-Process -FilePath $py -ArgumentList '-m','uvicorn','nutrition_backend.main:app','--host','127.0.0.1','--port',$Port,'--log-level','info' -NoNewWindow -RedirectStandardOutput $log -RedirectStandardError $log
    Start-Sleep -Seconds 1
    Start-Process "http://127.0.0.1:$Port/ready-to-cook-dishes.html"
    Write-Output "Started uvicorn in background (logs -> $log)"
}

if($Watchdog){
    Write-Output "Starting uvicorn with watchdog (auto-restart) on port $Port. Logs appended to $log"
    while($true){
        & $py -m uvicorn nutrition_backend.main:app --host 127.0.0.1 --port $Port --log-level info 2>&1 | Tee-Object -FilePath $log -Append
        Write-Warning "uvicorn exited. Restarting in 2 seconds..."
        Start-Sleep -Seconds 2
    }
} elseif($Bg) {
    Start-Background
} else {
    Start-Foreground
}
