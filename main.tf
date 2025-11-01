terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.0.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "ubuntu_arm" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_virtual_network" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "free-tier-vcn"
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "free-tier-igw"
}

resource "oci_core_route_table" "rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "free-tier-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_security_list" "sec_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "free-tier-sec-list"

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 3389
      max = 3389
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "subnet" {
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.vcn.id
  cidr_block          = "10.0.1.0/24"
  display_name        = "free-tier-subnet"
  route_table_id      = oci_core_route_table.rt.id
  security_list_ids   = [oci_core_security_list.sec_list.id]
  prohibit_public_ip_on_vnic = false
}

locals {
  ad_names = [for ad in data.oci_identity_availability_domains.ads.availability_domains : ad.name]
  selected_ad = local.ad_names[var.availability_domain_index]
  selected_shape = var.fallback_to_e2 ? "VM.Standard.E2.1.Micro" : "VM.Standard.A1.Flex"
}

resource "oci_core_instance" "ubuntu_vm" {
  availability_domain = local.selected_ad
  compartment_id      = var.compartment_ocid
  shape               = local.selected_shape

  dynamic "shape_config" {
    for_each = local.selected_shape == "VM.Standard.A1.Flex" ? [1] : []
    content {
      ocpus         = 4
      memory_in_gbs = 24
    }
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_arm.images[0].id
    boot_volume_size_in_gbs = 190
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }

  display_name = "ubuntu-free-tier-vm"

  timeouts {
    create = "30m"
  }
}
  display_name = "ubuntu-free-tier-arm"

  source_details {
    source_type               = "image"
    source_id                 = data.oci_core_images.ubuntu_arm.images[0].id
    boot_volume_size_in_gbs   = 190
    boot_volume_vpus_per_gb   = 10
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }
}

output "public_ip" {
  value = oci_core_instance.ubuntu_vm.public_ip
}

output "ssh_command" {
  value = "ssh -i <your-private-key> ubuntu@${oci_core_instance.ubuntu_vm.public_ip}"
}