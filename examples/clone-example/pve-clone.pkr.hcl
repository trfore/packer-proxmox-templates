// minimal Packer configuration for creating template clones
packer {
  required_plugins {
    proxmox = {
      version = ">=1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "clone_vm_id" {
  type    = number
  default = 9000
}

variable "cloud_init_ipv4" {
  type    = string
  default = "dhcp"
}

variable "cloud_init_ipv6" {
  type    = string
  default = "dhcp"
}

variable "template_name" {
  type    = string
  default = null
}

variable "vm_id" {
  type    = number
  default = null
}

source "proxmox-clone" "image" {
  // PVE login
  proxmox_url              = var.pve_api_url
  username                 = var.pve_username
  token                    = var.pve_token
  node                     = var.pve_node
  insecure_skip_tls_verify = var.skip_tls_check

  // SSH
  ssh_username         = var.ssh_username
  ssh_timeout          = var.ssh_timeout
  ssh_keypair_name     = var.ssh_keypair_name
  ssh_private_key_file = var.ssh_private_key_file

  // Template
  vm_id                = var.vm_id
  clone_vm_id          = var.clone_vm_id
  template_name        = var.template_name
  template_description = "Packer generated template clone on ${timestamp()}"

  // Disks
  scsi_controller = var.scsi_controller

  // Cloud-init
  cloud_init              = var.cloud_init
  cloud_init_storage_pool = var.cloud_init_storage_pool
  ipconfig {
    ip  = var.cloud_init_ipv4
    ip6 = var.cloud_init_ipv6
  }

  // CPU & Memory
  sockets  = var.sockets
  cores    = var.vcpu
  cpu_type = var.cpu_type
  memory   = var.memory

  // Network
  network_adapters {
    bridge   = var.net_bridge
    model    = var.net_model
    vlan_tag = var.net_vlan_tag
    firewall = var.net_firewall
  }
}

build {
  sources = ["source.proxmox-clone.image"]
}
