build {
  source "proxmox-iso.image" {
    name         = "debian10"
    boot_command = var.boot_cmd_debian
    boot_wait    = var.boot_wait
    http_content = {
      "/preseed.cfg" = templatefile("configs/preseed.cfg",
        {
          var                    = var,
          ssh_password_encrypted = "",
          ssh_public_key         = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["debian10"]
    iso_checksum  = var.iso_checksum["debian10"]
    template_name = "debian10"
    vm_id         = var.vm_id["debian10"]
  }

  source "proxmox-iso.image" {
    name         = "debian11"
    boot_command = var.boot_cmd_debian
    boot_wait    = var.boot_wait
    http_content = {
      "/preseed.cfg" = templatefile("configs/preseed.cfg",
        {
          var                    = var,
          ssh_password_encrypted = bcrypt(var.ssh_password),
          ssh_public_key         = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["debian11"]
    iso_checksum  = var.iso_checksum["debian11"]
    template_name = "debian11"
    vm_id         = var.vm_id["debian11"]
  }

  provisioner "shell" {
    inline = [
      // clean image identifiers
      "cloud-init clean --seed",
      "truncate -s 0 /etc/machine-id && ln -sf /etc/machine-id /var/lib/dbus/machine-id",
      "rm /etc/hostname /etc/ssh/ssh_host_* /var/lib/systemd/random-seed",
      "truncate -s 0 /root/.ssh/authorized_keys",
      "sed -i 's/^#PasswordAuthentication\\ yes/PasswordAuthentication\\ no/' /etc/ssh/sshd_config",
      "sed -i 's/^#PermitRootLogin\\ prohibit-password/PermitRootLogin\\ no/' /etc/ssh/sshd_config"
    ]
  }
}
