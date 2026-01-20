build {
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

  source "proxmox-iso.image" {
    name         = "debian12"
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
    iso_url       = var.iso_url["debian12"]
    iso_checksum  = var.iso_checksum["debian12"]
    template_name = "debian12"
    vm_id         = var.vm_id["debian12"]
  }

  source "proxmox-iso.image" {
    name         = "debian13"
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
    iso_url       = var.iso_url["debian13"]
    iso_checksum  = var.iso_checksum["debian13"]
    template_name = "debian13"
    vm_id         = var.vm_id["debian13"]
  }

  // 'scripts' accepts a list of local paths; Packer uploads and executes them in order.
  provisioner "shell" {
    scripts = concat(var.user_scripts, ["configs/cleanup.sh"])
  }
}
