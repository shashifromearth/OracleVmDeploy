#!/bin/bash

echo "🔧 Starting Oracle Cloud VM deployment in single AD..."
timeinSec=60  # Retry every 1 hour

while true; do
  timestamp=$(TZ='Asia/Kolkata' date +"%Y-%m-%d %H:%M:%S")
  echo "🕒 Attempting deployment at $timestamp IST in AD index 0"

  terraform apply -var="ad_index=0" -auto-approve

  if [ $? -eq 0 ]; then
    success_time=$(TZ='Asia/Kolkata' date +"%Y-%m-%d %H:%M:%S")
    echo "✅ VM deployed successfully at $success_time IST"
    terraform output ssh_command
    terraform output public_ip
    break
  fi

  echo "⚠️ Deployment failed. Retrying in $timeinSec seconds (~1 hour)..."
  sleep $timeinSec
done