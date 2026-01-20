build {
  source "proxmox-iso.image" {
    name         = "fedora42"
    boot_command = var.boot_cmd_fedora
    boot_wait    = var.boot_wait
    http_content = { "/anaconda-ks.cfg" = templatefile("configs/anaconda-ks.cfg",
      {
        var            = var,
        ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["fedora42"]
    iso_checksum  = var.iso_checksum["fedora42"]
    template_name = "fedora42"
    vm_id         = var.vm_id["fedora42"]
  }

    source "proxmox-iso.image" {
    name         = "fedora43"
    boot_command = var.boot_cmd_fedora
    boot_wait    = var.boot_wait
    http_content = { "/anaconda-ks.cfg" = templatefile("configs/anaconda-ks.cfg",
      {
        var            = var,
        ssh_public_key = chomp(file(var.ssh_public_key_file))
      })
    }
    iso_url       = var.iso_url["fedora43"]
    iso_checksum  = var.iso_checksum["fedora43"]
    template_name = "fedora43"
    vm_id         = var.vm_id["fedora43"]
  }

  // 'scripts' accepts a list of local paths; Packer uploads and executes them in order.
  provisioner "shell" {
    scripts = concat(var.user_scripts, ["configs/cleanup.sh"])
  }
}
