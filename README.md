# OracleVmDeploy

# 🚀 OCI Free Tier VM Automation with Terraform + PowerShell

Automate the creation of Ubuntu or Oracle Linux virtual machines on Oracle Cloud Infrastructure (OCI) Free Tier using Terraform and PowerShell. This project is designed for developers, DevOps engineers, and cloud enthusiasts who want **reliable, unattended VM provisioning** with **robust retry logic**, **audible success alerts**, and **timestamped logging** — all from a local Windows system.

---

## 📌 Features

- ✅ **One-click VM deployment** using Terraform
- 🔁 **Unlimited retry loop** for failed provisioning attempts
- 🔔 **50-beep audible alert** on successful VM creation
- 📊 **Runtime stats**: attempt count, last run timestamp
- 📁 **Persistent logging** with timestamped error output
- 🧠 **Smart error filtering** (e.g., skips "out of host capacity" noise)
- 🖥️ **Windows-compatible PowerShell automation**
- ☁️ Supports **Ubuntu and Oracle Linux** images
- 🔐 Secure credential handling via environment variables or config files

---

## 📂 Project Structure

```plaintext
oci-vm-automation/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
├── scripts/
│   └── deploy.ps1
├── config/
│   └── oci-credentials.json
├── logs/
│   └── deployment.log
└── README.md
```

---

## ⚙️ Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)
- PowerShell 5.1+ (Windows)
- Oracle Cloud Free Tier account
- SSH key pair for VM access

---

## 🚀 Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/yourusername/oci-vm-automation.git
cd oci-vm-automation
```

### 2. Configure OCI credentials

Update `config/oci-credentials.json` or set environment variables:

```powershell
$env:TF_VAR_tenancy_ocid = "<your-tenancy-ocid>"
$env:TF_VAR_user_ocid = "<your-user-ocid>"
$env:TF_VAR_fingerprint = "<your-api-key-fingerprint>"
$env:TF_VAR_private_key_path = "<path-to-private-key.pem>"
$env:TF_VAR_region = "ap-hyderabad-1"
```

### 3. Customize Terraform variables

Edit `terraform/variables.tf` to set:

- VM shape (e.g., `VM.Standard.A1.Flex`)
- Image OCID (Ubuntu or Oracle Linux)
- SSH public key
- Subnet OCID

### 4. Run the PowerShell deployment script

```powershell
.\scripts\deploy.ps1
```

This script:
- Initializes Terraform
- Applies the configuration
- Retries on failure (except "out of host capacity")
- Logs each attempt with timestamp
- Beeps 50 times on success 🎉

---

## 🧠 Error Handling Logic

```powershell
if ($LASTEXITCODE -ne 0 -and -not ($normalizedError.Contains("out of host capacity"))) {
    # Log full error output
} else {
    # Log attempt only (skip noisy errors)
}
```

This ensures clean logs and avoids clutter from known capacity issues.

---

## 🔊 Audible Success Feedback

After successful provisioning:
- Script emits **50 beeps**
- Displays runtime stats
- Logs success timestamp

Perfect for **overnight automation** or **unattended runs**.

---

## 🛡️ Security Best Practices

- Use environment variables for sensitive credentials
- Avoid hardcoding secrets in scripts
- Rotate API keys periodically
- Restrict access to your private key file

---

## 🧪 Tested With

- Oracle Cloud Free Tier (ap-hyderabad-1, ap-mumbai-1)
- Terraform v1.6+
- PowerShell 5.1 and 7.x
- Ubuntu 22.04 and Oracle Linux 8

---

## 🧭 Troubleshooting

| Issue | Solution |
|------|----------|
| `out of host capacity` | Retry later or switch region |
| Terraform provider error | Check `provider.tf` and credentials |
| SSH timeout | Validate public key and security list |
| No audible alert | Ensure PowerShell beep is supported |



## 🤝 Contributing

Pull requests welcome! If you’ve optimized retry logic, added region fallback, or improved logging — share it with the community.


**Oracle Cloud Free Tier VM automation**, **Terraform OCI VM script**, **PowerShell OCI deployment**, **OCI VM retry logic**, **Terraform Oracle Linux Ubuntu**, **OCI Free Tier provisioning script**, **Windows Terraform automation**, **OCI VM creation with logging**, **OCI VM deployment with beeps**, **OCI VM error handling PowerShell**


