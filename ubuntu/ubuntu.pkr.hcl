build {
  source "proxmox-iso.image" {
    name         = "ubuntu22"
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
    iso_url       = var.iso_url["ubuntu22"]
    iso_checksum  = var.iso_checksum["ubuntu22"]
    template_name = "ubuntu22"
    vm_id         = var.vm_id["ubuntu22"]
  }

  source "proxmox-iso.image" {
    name         = "ubuntu24"
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
    template_name = "ubuntu24"
    vm_id         = var.vm_id["ubuntu24"]
  }

  // 'scripts' accepts a list of local paths; Packer uploads and executes them in order.
  provisioner "shell" {
    scripts = concat(var.user_scripts, ["configs/cleanup.sh"])
  }
}
