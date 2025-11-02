#!/bin/bash

echo "🔧 Starting Oracle Cloud VM deployment with AD rotation..."
timeinSec=360 # Retry every 1 hour
max_ad=3        # Number of ADs to try (usually 3 per region)

for (( i=0; i<$max_ad; i++ )); do
  timestamp=$(TZ='Asia/Kolkata' date +"%Y-%m-%d %H:%M:%S")
  echo "🕒 Attempting deployment in AD index $i at $timestamp IST"

  terraform apply -var="ad_index=$i" -auto-approve

  if [ $? -eq 0 ]; then
    success_time=$(TZ='Asia/Kolkata' date +"%Y-%m-%d %H:%M:%S")
    echo "✅ VM deployed successfully in AD-$((i+1)) at $success_time IST"
    terraform output ssh_command
    terraform output public_ip
    break
  fi

  echo "⚠️ AD-$((i+1)) failed. Retrying in $timeinSec seconds (~1 hour)..."
  sleep $timeinSec
done