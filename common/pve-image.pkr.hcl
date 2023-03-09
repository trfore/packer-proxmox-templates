packer {
  required_plugins {
    proxmox = {
      version = ">=1.1.1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "image" {
  // PVE login
  proxmox_url              = var.pve_api_url
  username                 = var.pve_username
  token                    = var.pve_token
  node                     = var.pve_node
  insecure_skip_tls_verify = var.skip_tls_check

  // SSH
  ssh_username              = var.ssh_username
  ssh_timeout               = var.ssh_timeout
  ssh_keypair_name          = var.ssh_keypair_name
  ssh_private_key_file      = var.ssh_private_key_file
  ssh_clear_authorized_keys = var.ssh_clear_authorized_keys

  // ISO
  iso_download_pve     = var.iso_download_pve
  iso_storage_pool     = var.iso_storage_pool
  unmount_iso          = var.unmount_iso
  os                   = var.os
  template_description = "Packer generated template image on ${timestamp()}"

  // System
  machine    = var.machine
  bios       = var.bios
  qemu_agent = var.qemu_agent

  // Disks
  scsi_controller = var.scsi_controller
  disks {
    type              = var.disk_type
    storage_pool      = var.disk_storage_pool
    storage_pool_type = var.disk_storage_pool_type
    disk_size         = var.disk_size
    cache_mode        = var.disk_cache_mode
    format            = var.disk_format
    io_thread         = var.disk_io_thread
  }

  // Cloud-init
  cloud_init              = var.cloud_init
  cloud_init_storage_pool = var.cloud_init_storage_pool

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
