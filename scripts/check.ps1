#!/usr/bin/env pwsh
# Quick health checks for API and dishes page
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $root '..')

function Check-Url($url){
    try{
        $res = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
        Write-Output "$url -> $($res.StatusCode) (Length: $($res.Content.Length))"
    } catch {
        Write-Error "$url -> FAILED: $($_.Exception.Message)"
    }
}

Check-Url http://127.0.0.1:8000/dishes
Check-Url http://127.0.0.1:8000/ready-to-cook-dishes.html
