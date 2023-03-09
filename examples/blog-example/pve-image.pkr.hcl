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
  insecure_skip_tls_verify = true

  // SSH
  ssh_username              = var.ssh_username
  ssh_keypair_name          = var.ssh_keypair_name
  ssh_private_key_file      = var.ssh_private_key_file
  ssh_clear_authorized_keys = true
  ssh_timeout               = "20m"

  // ISO
  iso_download_pve     = true # added in v1.1.2
  iso_storage_pool     = "local"
  unmount_iso          = true
  os                   = "l26"
  template_description = "Packer generated template image on ${timestamp()}"

  // System
  machine    = "q35"
  bios       = "seabios"
  qemu_agent = true

  // Disks
  scsi_controller = "virtio-scsi-pci"
  disks {
    type              = "scsi"
    storage_pool      = "local-lvm"
    // storage_pool_type = "lvm" # depreciated in v1.1.2
    disk_size         = "10G"
    cache_mode        = "writeback"
    format            = "raw"
    io_thread         = false
  }

  // Cloud-init
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  // CPU & Memory
  sockets  = 1
  cores    = 2
  cpu_type = "host"
  memory   = 2048

  // Network
  network_adapters {
    bridge   = "vmbr0"
    model    = "virtio"
    vlan_tag = "1"
    firewall = false
  }
}

build {
  source "proxmox-iso.image" {
    name          = "ubuntu22"
    template_name = "ubuntu22"
    vm_id         = 9000
    iso_url       = "https://releases.ubuntu.com/22.04/ubuntu-22.04.2-live-server-amd64.iso"
    iso_checksum  = "file:https://releases.ubuntu.com/22.04/SHA256SUMS"
    boot_wait     = "5s"
    boot_command = [
      "c",
      "linux /casper/vmlinuz --- autoinstall 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
      "<enter><wait>",
      "initrd /casper/initrd",
      "<enter><wait>",
      "boot<enter>"
    ]
    http_content = {
      "/meta-data" = file("configs/meta-data")
      "/user-data" = templatefile("configs/user-data",
        {
          var            = var,
          ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }
  }

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      // clean image identifiers
      "cloud-init clean --machine-id --seed",
      "rm /etc/hostname /etc/ssh/ssh_host_* /var/lib/systemd/random-seed",
      "truncate -s 0 /root/.ssh/authorized_keys",
      // disable SSH password authentication and root access
      "sed -i 's/^#PasswordAuthentication\\ yes/PasswordAuthentication\\ no/' /etc/ssh/sshd_config",
      "sed -i 's/^#PermitRootLogin\\ prohibit-password/PermitRootLogin\\ no/' /etc/ssh/sshd_config"
    ]
  }
}
