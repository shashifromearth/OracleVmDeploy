#!/bin/bash

echo "🔧 Setting up one-click Ubuntu VM on Oracle Cloud Free Tier..."

timeinSec=3600  # 1 hour in seconds

while true; do
  last_run=$(TZ='Asia/Kolkata' date +"%Y-%m-%d %H:%M:%S")
  echo "🕒 Last attempt started at: $last_run IST"

  terraform init
  terraform apply -auto-approve

  if [ $? -eq 0 ]; then
    success_time=$(TZ='Asia/Kolkata' date +"%Y-%m-%d %H:%M:%S")
    echo "✅ Deployment complete at $success_time IST. Check your public IP above to connect via SSH or RDP."
    break
  fi

  echo "⚠️ Capacity error. Retrying in $timeinSec seconds...🕒 Last attempt started at: $last_run IST"
  sleep $timeinSec
done