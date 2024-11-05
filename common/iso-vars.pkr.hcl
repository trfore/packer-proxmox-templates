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
    "debian10" = "https://get.debian.org/images/archive/10.13.0/amd64/iso-cd/debian-10.13.0-amd64-netinst.iso"
    "debian11" = "https://get.debian.org/images/archive/11.11.0/amd64/iso-cd/debian-11.11.0-amd64-netinst.iso"
    "debian12" = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso"
    "fedora38" = "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Server/x86_64/iso/Fedora-Server-netinst-x86_64-38-1.6.iso"
    "fedora39" = "https://download.fedoraproject.org/pub/fedora/linux/releases/39/Server/x86_64/iso/Fedora-Server-netinst-x86_64-39-1.5.iso"
    "fedora40" = "https://download.fedoraproject.org/pub/fedora/linux/releases/40/Server/x86_64/iso/Fedora-Server-netinst-x86_64-40-1.14.iso"
    "fedora41" = "https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/x86_64/iso/Fedora-Server-netinst-x86_64-41-1.4.iso"
    "ubuntu20" = "https://releases.ubuntu.com/20.04/ubuntu-20.04.6-live-server-amd64.iso"
    "ubuntu22" = "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
    "ubuntu24" = "https://releases.ubuntu.com/24.04/ubuntu-24.04.1-live-server-amd64.iso"
  }
}

variable "iso_checksum" {
  type = map(string)
  default = {
    "centos8"  = "file:"
    "centos9"  = "file:"
    "debian10" = "file:https://get.debian.org/images/archive/10.13.0/amd64/iso-cd/SHA256SUMS"
    "debian11" = "file:https://get.debian.org/images/archive/11.11.0/amd64/iso-cd/SHA256SUMS"
    "debian12" = "file:https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS"
    "fedora38" = "file:https://download.fedoraproject.org/pub/fedora/linux/releases/38/Server/x86_64/iso/Fedora-Server-38-1.6-x86_64-CHECKSUM"
    "fedora39" = "file:https://download.fedoraproject.org/pub/fedora/linux/releases/39/Server/x86_64/iso/Fedora-Server-39-1.5-x86_64-CHECKSUM"
    "fedora40" = "file:https://download.fedoraproject.org/pub/fedora/linux/releases/40/Server/x86_64/iso/Fedora-Server-40-1.14-x86_64-CHECKSUM"
    "fedora41" = "file:https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/x86_64/iso/Fedora-Server-41-1.4-x86_64-CHECKSUM"
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
    "debian10" = 0
    "debian11" = 0
    "debian12" = 0
    "fedora38" = 0
    "fedora39" = 0
    "fedora40" = 0
    "fedora41" = 0
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
