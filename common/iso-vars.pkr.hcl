// ISO Variables //
variable "iso_download_pve" {
  description = "Download the ISO directly on the Proxmox node."
  type        = bool
  default     = true
}

variable "iso_storage_pool" {
  type    = string
  default = "local"
}

variable "apt_proxy_http" {
  description = <<EOT
  APT proxy URL for Ubuntu, format: 'http://[[user][:pass]@]host[:port]/'. Default 'null' skips setting proxy.
  EOT
  type        = string
  default     = ""
}

variable "apt_proxy_https" {
  description = <<EOT
  APT proxy URL for Ubuntu, format: 'https://[[user][:pass]@]host[:port]/'. Default 'null' skips setting proxy.
  EOT
  type        = string
  default     = ""
}

variable "centos_install_url" {
  description = "Installation tree URL - single source, not a mirror list."
  type        = map(string)
  default = {
    "centos8" = ""
    "centos9" = ""
  }
}

variable "centos_mirror_appstream" {
  description = "Appstream mirror list, if set packages will be updated on install."
  type        = map(string)
  default = {
    "centos8" = ""
    "centos9" = ""
  }
}

variable "centos_mirror_baseos" {
  description = "Baseos mirror list, if set packages will be updated on install."
  type        = map(string)
  default = {
    "centos8" = ""
    "centos9" = ""
  }
}

variable "centos_mirror_extras" {
  description = "Extras mirror list, if set packages will be updated on install."
  type        = map(string)
  default = {
    "centos8" = ""
    "centos9" = ""
  }
}

variable "iso_url" {
  type = map(string)
  default = {
    "centos8"  = ""
    "centos9"  = ""
    "debian11" = "https://get.debian.org/images/archive/11.11.0/amd64/iso-cd/debian-11.11.0-amd64-netinst.iso"
    "debian12" = "https://get.debian.org/images/archive/12.11.0/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
    "debian13" = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.3.0-amd64-netinst.iso"
    "fedora42" = "https://download.fedoraproject.org/pub/fedora/linux/releases/42/Server/x86_64/iso/Fedora-Server-netinst-x86_64-42-1.1.iso"
    "fedora43" = "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Server/x86_64/iso/Fedora-Server-netinst-x86_64-43-1.6.iso"
    "ubuntu20" = "https://releases.ubuntu.com/20.04/ubuntu-20.04.6-live-server-amd64.iso"
    "ubuntu22" = "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
    "ubuntu24" = "https://releases.ubuntu.com/24.04/ubuntu-24.04.3-live-server-amd64.iso"
  }
}

variable "iso_checksum" {
  type = map(string)
  default = {
    "centos8"  = "file:"
    "centos9"  = "file:"
    "debian11" = "file:https://get.debian.org/images/archive/11.11.0/amd64/iso-cd/SHA256SUMS"
    "debian12" = "file:https://get.debian.org/images/archive/12.11.0/amd64/iso-cd/SHA256SUMS"
    "debian13" = "file:https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS"
    "fedora42" = "file:https://download.fedoraproject.org/pub/fedora/linux/releases/42/Server/x86_64/iso/Fedora-Server-42-1.1-x86_64-CHECKSUM"
    "fedora43" = "file:https://download.fedoraproject.org/pub/fedora/linux/releases/43/Server/x86_64/iso/Fedora-Server-43-1.6-x86_64-CHECKSUM"
    "ubuntu20" = "file:https://releases.ubuntu.com/20.04/SHA256SUMS"
    "ubuntu22" = "file:https://releases.ubuntu.com/22.04/SHA256SUMS"
    "ubuntu24" = "file:https://releases.ubuntu.com/24.04/SHA256SUMS"
  }
}

variable "unmount_iso" {
  type    = bool
  default = true
}

variable "os" {
  description = "OS Type, defaults to Linux 6.x-2.6 Kernel"
  type        = string
  default     = "l26"
}

variable "vm_id" {
  type = map(number)
  default = {
    "centos8"  = 0
    "centos9"  = 0
    "debian11" = 0
    "debian12" = 0
    "debian13" = 0
    "fedora42" = 0
    "fedora43" = 0
    "ubuntu20" = 0
    "ubuntu22" = 0
    "ubuntu24" = 0
  }
}

// Boot Commands //
variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "boot_cmd_centos" {
  description = "Boot command for CentOS Stream 8-9"
  type        = list(string)
  default = [
    "<tab>",
    "<bs><bs><bs><bs><bs>",
    "hostname=centos ",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/anaconda-ks.cfg ",
    "<wait><enter>"
  ]
}

variable "boot_cmd_debian" {
  description = "Boot command for Debian"
  type        = list(string)
  default = [
    "<tab>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "auto=true ",
    "priority=critical ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "<wait><enter>"
  ]
}

variable "boot_cmd_fedora" {
  description = "Boot command for Fedora"
  type        = list(string)
  default = [
    "<up>",
    "e",
    "<down><down><down><left>",
    " hostname=fedora",
    " inst.ks=http://{{.HTTPIP}}:{{.HTTPPort}}/anaconda-ks.cfg <wait><f10>"
  ]
}

variable "boot_cmd_ubuntu20" {
  description = "Boot command for Ubuntu 20"
  type        = list(string)
  default = [
    "<esc><wait><esc><wait><f6><wait><esc><wait>",
    "<bs><bs><bs><bs>",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<wait><enter>"
  ]
}

variable "boot_cmd_ubuntu22" {
  description = "Boot command for Ubuntu 22 & 24"
  type        = list(string)
  default = [
    "c",
    "linux /casper/vmlinuz --- autoinstall 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot<enter>"
  ]
}

variable "user_scripts" {
  description = "Additional local script paths to upload and run after the built-in scripts. These are appended to the default scripts and will not replace them."
  type        = list(string)
  default     = []
}

variable "task_timeout" {
  description = "The timeout for Promox API operations, e.g. clones. Defaults to 1 minute."
  type        = string
  default     = "1m"
}
