build {
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

  // 'scripts' accepts a list of local paths; Packer uploads and executes them in order.
  provisioner "shell" {
    scripts = concat(var.user_scripts, ["configs/cleanup.sh"])
  }
}
