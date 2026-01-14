// SSH Variables //
variable "ssh_username" {
  description = "SSH Username During Packer Build"
  type        = string
  default     = "root"
}

variable "ssh_password" {
  description = "SSH Password During Packer Build"
  type        = string
  default     = "password"
  sensitive   = true
}

variable "ssh_timeout" {
  type    = string
  default = "20m"
}

variable "ssh_keypair_name" {
  default = "packer_id_ed25519"
  type    = string
}

variable "ssh_private_key_file" {
  description = "Private SSH Key for VM"
  default     = "~/.ssh/packer_id_ed25519"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_file" {
  description = "Public SSH Key for VM"
  default     = "~/.ssh/packer_id_ed25519.pub"
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("(?i)PRIVATE", var.ssh_public_key_file)) == false
    error_message = "ERROR Private SSH Key."
  }
}

variable "ssh_clear_authorized_keys" {
  type    = bool
  default = true
}

//HTTP server Variabels
variable "http_interface" {
  description = "Optional. Interface name to use as source for {{ .HTTPIP }} (e.g. vmbr0). Leave empty for default auto-selection."
  type        = string
  default     = ""
}
variable "http_bind_address" {
  description = "Optional. IP address to bind Packer's internal HTTP server (used for {{ .HTTPIP }}). Leave empty for default auto-selection."
  type        = string
  default     = ""
}
variable "http_port_min" {
  description = "Optional. The minimum HTTP port of the range for preloading files."
  type        = number
  default     = 8033
}
variable "http_port_max" {
  description = "Optional. The maximum HTTP port in the range for preloading files."
  type        = number
  default     = 8033
}


// PVE Variables //
// Sensitive Variables to Pass as CLI Args or Env Vars
variable "pve_token" {
  description = "Proxmox API Token"
  type        = string
  sensitive   = true
}

variable "pve_username" {
  description = "Username when authenticating to Proxmox, including the realm."
  type        = string
  sensitive   = true
}

variable "pve_api_url" {
  description = "Proxmox API Endpoint, e.g. 'https://pve.example.com/api2/json'"
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("(?i)^http[s]?://.*/api2/json$", var.pve_api_url))
    error_message = "Proxmox API Endpoint Invalid. Check URL - Scheme and Path required."
  }
}

// Non-Sensitive Variables
variable "pve_node" {
  type    = string
  default = "pve"
}

variable "skip_tls_check" {
  type    = bool
  default = true
}

// System Variables //
variable "machine" {
  type    = string
  default = "q35"
}

variable "bios" {
  type    = string
  default = "seabios"
}

variable "qemu_agent" {
  type    = bool
  default = true
}

variable "scsi_controller" {
  type    = string
  default = "virtio-scsi-pci"
}

// Cloud-init Variables //
variable "cloud_init" {
  description = "Attach cloud-init drive."
  type        = bool
  default     = true
}

variable "cloud_init_storage_pool" {
  description = "Proxmox storage pool to use for cloud-init drive, e.g. 'local-lvm' (default)."
  type        = string
  default     = "local-lvm"
}

// CPU & Memory Variables //
variable "sockets" {
  type    = number
  default = 1
}

variable "vcpu" {
  type    = number
  default = 1
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "memory" {
  type    = number
  default = 1024
}

// Disk Variables //
variable "disk_cache_mode" {
  type    = string
  default = "writeback"
}

variable "disk_discard" {
  type    = bool
  default = false
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_io_thread" {
  type    = bool
  default = false
}

variable "disk_size" {
  type    = string
  default = "10G"
}

variable "disk_ssd" {
  type    = bool
  default = false
}

variable "disk_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "disk_type" {
  type    = string
  default = "scsi"
}

// Network Variables //
variable "net_bridge" {
  type    = string
  default = "vmbr0"
}

variable "net_model" {
  type    = string
  default = "virtio"
}

variable "net_vlan_tag" {
  type    = string
  default = "1"
}

variable "net_firewall" {
  type    = bool
  default = false
}
