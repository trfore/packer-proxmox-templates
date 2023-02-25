build {
  source "proxmox-iso.image" {
    name         = "centos8"
    boot_command = var.boot_cmd_centos
    boot_wait    = var.boot_wait
    http_content = { "/anaconda-ks.cfg" = templatefile("configs/anaconda-ks.cfg",
      {
        centos_url       = var.centos_install_url["centos8"],
        mirror_baseos    = var.centos_mirror_baseos["centos8"],
        mirror_appstream = var.centos_mirror_appstream["centos8"],
        mirror_extras    = var.centos_mirror_extras["centos8"],
        var              = var,
        ssh_public_key   = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["centos8"]
    iso_checksum  = var.iso_checksum["centos8"]
    template_name = "centos8"
    vm_id         = var.vm_id["centos8"]
  }

  source "proxmox-iso.image" {
    name         = "centos9"
    boot_command = var.boot_cmd_centos
    boot_wait    = var.boot_wait
    http_content = { "/anaconda-ks.cfg" = templatefile("configs/anaconda-ks.cfg",
      {
        centos_url       = var.centos_install_url["centos9"],
        mirror_baseos    = var.centos_mirror_baseos["centos9"],
        mirror_appstream = var.centos_mirror_appstream["centos9"],
        mirror_extras    = var.centos_mirror_extras["centos9"],
        var              = var,
        ssh_public_key   = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["centos9"]
    iso_checksum  = var.iso_checksum["centos9"]
    template_name = "centos9"
    vm_id         = var.vm_id["centos9"]
  }

  provisioner "shell" {
    inline = [
      // clean image identifiers
      "cloud-init clean --machine-id --seed",
      "rm /etc/hostname /etc/ssh/ssh_host_* /var/lib/systemd/random-seed",
      "truncate -s 0 /root/.ssh/authorized_keys",
      "sed -i 's/^#PasswordAuthentication\\ yes/PasswordAuthentication\\ no/' /etc/ssh/sshd_config",
      "sed -i 's/^#PermitRootLogin\\ prohibit-password/PermitRootLogin\\ no/' /etc/ssh/sshd_config"
    ]
  }
}
