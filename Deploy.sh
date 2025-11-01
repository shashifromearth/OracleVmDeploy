#!/bin/bash
echo "🔧 Setting up one-click Ubuntu VM on Oracle Cloud Free Tier..."
while true; do
terraform init
terraform apply -auto-approve
echo "Retrying in 1 hour due to capacity error..."
  sleep 3600
done
echo "✅ Deployment complete. Check your public IP above to connect via SSH or RDP."