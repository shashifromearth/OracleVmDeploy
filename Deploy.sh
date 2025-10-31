#!/bin/bash
echo "🔧 Setting up one-click Ubuntu VM on Oracle Cloud Free Tier..."

cp terraform.tfvars.template terraform.tfvars

terraform init
terraform apply -auto-approve

echo "✅ Deployment complete. Check your public IP above to connect via SSH or RDP."