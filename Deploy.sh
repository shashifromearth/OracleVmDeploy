#!/bin/bash

echo "🔧 Setting up one-click Ubuntu VM on Oracle Cloud Free Tier..."

timeinSec=360  # 1 hour in seconds

while true; do
  terraform init
  terraform apply -auto-approve

  if [ $? -eq 0 ]; then
    echo "✅ Deployment complete. Check your public IP above to connect via SSH or RDP."
    break
  fi

  echo "⚠️ Capacity error. Retrying in $timeinSec seconds..."
  sleep $timeinSec
done