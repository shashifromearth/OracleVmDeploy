Set-Location "C:\cloudshell\OracleVmDeploy"
Write-Host "🚀 Starting Oracle Cloud VM deployment in single AD..."

$retryInterval = 60       # Retry every 5 minutes (in seconds)
$attemptCount  = 0        # Initialize attempt counter
$lastRunTime   = ""       # Track last run timestamp
$logFile       = "C:\cloudshell\OracleVmDeploy\Log\terraform_error_log.txt"

while ($true) {
    $attemptCount++
    $lastRunTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Write-Host "`n🕒 Attempt #$attemptCount at $lastRunTime IST in AD index 0"

    # Capture stderr output
    $errorOutput = & terraform apply -var "ad_index=0" -auto-approve 2>&1

    if ($LASTEXITCODE -eq 0) {
        $successTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Write-Host "`n✅ VM deployed successfully at $successTime IST"

        terraform output ssh_command
        terraform output public_ip

        Write-Host "`n🔔 Waking you up with 50 beeps..."
        for ($i = 0; $i -lt 50; $i++) {
            [console]::beep(1000, 300)
        }

        break
    }

 
# Normalize error output to a single-line lowercase string
$normalizedError = ($errorOutput -join "`n").ToLower()

# Check if it contains "out of host capacity"
if ($LASTEXITCODE -ne 0 -and -not ($normalizedError.Contains("out of host capacity")))
{
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Add-Content -Path $logFile -Value "`n[$timestamp] Attempt #${attemptCount}:`n$errorOutput`n"
}else 
{
	$timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Add-Content -Path $logFile -Value "`n[$timestamp] Attempt #${attemptCount}"
}


    Write-Host "❌ Deployment failed. Retrying in $retryInterval seconds (~5 minutes)...Attempt Count: $attemptCount Last Run Time : $lastRunTime"
    Start-Sleep -Seconds $retryInterval
}

# Final stats
Write-Host "`n📊 Deployment Summary:"
Write-Host "🔁 Total Attempts: $attemptCount"
Write-Host "🕒 Last Attempt Time: $lastRunTime IST"