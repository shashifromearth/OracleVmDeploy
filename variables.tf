variable "tenancy_ocid" {
  description = "Your Oracle Cloud Tenancy OCID"
  type        = string
}

variable "user_ocid" {
  description = "Your Oracle Cloud User OCID"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of your API key"
  type        = string
}

variable "private_key_path" {
  description = "Path to your private API key file"
  type        = string
}

variable "region" {
  description = "OCI region, e.g., ap-mumbai-1"
  type        = string
}

variable "compartment_ocid" {
  description = "OCID of the compartment to deploy resources in"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key file"
  type        = string
}

variable "availability_domain_index" {
  description = "Index of the availability domain to use (0, 1, or 2)"
  type        = number
  default     = 0
}
variable "fallback_to_e2" {
  description = "Set to true to fallback to VM.Standard.E2.1.Micro if A1.Flex fails"
  type        = bool
  default     = true
}
