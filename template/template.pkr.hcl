build {
  // using local ISO and hard-coded config files
  source "proxmox-iso.image" {
    name           = "packer00"
    boot_command   = var.boot_cmd_ubuntu22
    boot_wait      = var.boot_wait
    http_directory = "configs"
    iso_file       = "local:iso/linux.iso"
    template_name  = "packer-image"
    vm_id          = var.vm_id["packer00"]
  }

  // serving a config template using 'http_content'
  source "proxmox-iso.image" {
    name         = "packer01"
    boot_command = var.boot_cmd_ubuntu22
    boot_wait    = var.boot_wait
    http_content = {
      "/meta-data" = file("configs/meta-data")
      "/user-data" = templatefile("configs/user-data",
        {
          var            = var,
          ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["ubuntu24"]
    iso_checksum  = var.iso_checksum["ubuntu24"]
    template_name = "packer-image"
    vm_id         = var.vm_id["packer01"]
  }

  provisioner "shell" {
    inline = [
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
