// ISO Variables //
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

variable "iso_url" {
  type = map(string)
  default = {
    "debian10" = "https://get.debian.org/images/archive/10.13.0/amd64/iso-cd/debian-10.13.0-amd64-netinst.iso"
    "debian11" = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.6.0-amd64-netinst.iso"
    "ubuntu20" = "https://releases.ubuntu.com/20.04/ubuntu-20.04.5-live-server-amd64.iso"
    "ubuntu22" = "https://releases.ubuntu.com/22.04/ubuntu-22.04.2-live-server-amd64.iso"
  }
}

variable "iso_checksum" {
  type = map(string)
  default = {
    "debian10" = "file:https://get.debian.org/images/archive/10.13.0/amd64/iso-cd/SHA256SUMS"
    "debian11" = "file:https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS"
    "ubuntu20" = "file:https://releases.ubuntu.com/20.04/SHA256SUMS"
    "ubuntu22" = "file:https://releases.ubuntu.com/22.04/SHA256SUMS"
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
    "debian10" = 0
    "debian11" = 0
    "ubuntu20" = 0
    "ubuntu22" = 0
  }
}

// Boot Commands //
variable "boot_wait" {
  type    = string
  default = "5s"
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
  description = "Boot command for Ubuntu 22"
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