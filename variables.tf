variable "tenancy_ocid" {
  type        = string
  description = "Your tenancy OCID"
}

variable "user_ocid" {
  type        = string
  description = "Your user OCID"
}

variable "fingerprint" {
  type        = string
  description = "Your API key fingerprint"
}

variable "private_key_path" {
  type        = string
  description = "Path to your private API key"
}

variable "region" {
  type        = string
  description = "OCI region, e.g., ap-mumbai-1"
}

variable "compartment_ocid" {
  type        = string
  description = "Target compartment OCID"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to your SSH public key"
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to your SSH private key"
}

variable "ocpus" {
  type        = number
  default     = 1
  description = "Number of OCPUs"
}

variable "memory_in_gbs" {
  type        = number
  default     = 6
  description = "Memory in GBs"
}

variable "boot_volume_size_in_gbs" {
  type        = number
  default     = 50
  description = "Boot volume size in GBs"
}
variable "ssh_private_key_path" {
  description = "Path to your SSH private key"
  type        = string
}