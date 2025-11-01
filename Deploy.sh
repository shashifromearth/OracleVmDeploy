#!/bin/bash

echo "🔧 Setting up one-click Ubuntu VM on Oracle Cloud Free Tier..."

timeinSec=360  # in seconds

while true; do
  last_run=$(date +"%Y-%m-%d %H:%M:%S")
  echo "🕒 Last attempt started at: $last_run"

  terraform init
  terraform apply -auto-approve

  if [ $? -eq 0 ]; then
    echo "✅ Deployment complete at $(date +"%Y-%m-%d %H:%M:%S"). Check your public IP above to connect via SSH or RDP."
    break
  fi

  echo "⚠️ Capacity error. Retrying in $timeinSec seconds ..."
  sleep $timeinSec
done