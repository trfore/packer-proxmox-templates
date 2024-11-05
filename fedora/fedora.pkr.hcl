build {
  source "proxmox-iso.image" {
    name         = "fedora38"
    boot_command = var.boot_cmd_fedora
    boot_wait    = var.boot_wait
    http_content = { "/anaconda-ks.cfg" = templatefile("configs/anaconda-ks.cfg",
      {
        var            = var,
        ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["fedora38"]
    iso_checksum  = var.iso_checksum["fedora38"]
    template_name = "fedora38"
    vm_id         = var.vm_id["fedora38"]
  }

  source "proxmox-iso.image" {
    name         = "fedora39"
    boot_command = var.boot_cmd_fedora
    boot_wait    = var.boot_wait
    http_content = { "/anaconda-ks.cfg" = templatefile("configs/anaconda-ks.cfg",
      {
        var            = var,
        ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["fedora39"]
    iso_checksum  = var.iso_checksum["fedora39"]
    template_name = "fedora39"
    vm_id         = var.vm_id["fedora39"]
  }

  source "proxmox-iso.image" {
    name         = "fedora40"
    boot_command = var.boot_cmd_fedora
    boot_wait    = var.boot_wait
    http_content = { "/anaconda-ks.cfg" = templatefile("configs/anaconda-ks.cfg",
      {
        var            = var,
        ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["fedora40"]
    iso_checksum  = var.iso_checksum["fedora40"]
    template_name = "fedora40"
    vm_id         = var.vm_id["fedora40"]
  }

  source "proxmox-iso.image" {
    name         = "fedora41"
    boot_command = var.boot_cmd_fedora
    boot_wait    = var.boot_wait
    http_content = { "/anaconda-ks.cfg" = templatefile("configs/anaconda-ks.cfg",
      {
        var            = var,
        ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["fedora41"]
    iso_checksum  = var.iso_checksum["fedora41"]
    template_name = "fedora41"
    vm_id         = var.vm_id["fedora41"]
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
