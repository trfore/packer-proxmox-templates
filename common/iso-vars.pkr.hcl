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
    "ubuntu20" = "https://releases.ubuntu.com/20.04/ubuntu-20.04.5-live-server-amd64.iso"
    "ubuntu22" = "https://releases.ubuntu.com/22.04/ubuntu-22.04.2-live-server-amd64.iso"
  }
}

variable "iso_checksum" {
  type = map(string)
  default = {
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
    "ubuntu20" = 0
    "ubuntu22" = 0
  }
}

// Boot Commands //
variable "boot_wait" {
  type    = string
  default = "5s"
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
