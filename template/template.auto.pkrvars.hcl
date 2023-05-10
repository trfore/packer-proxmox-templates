pve_api_url     = "https://192.168.100.1/api2/json" // PVE IP or FQDN
pve_node        = "node01"                          // PVE node name
ssh_username    = "packer"                          // Default user
ssh_password    = "packer!password"                 // Default user password
vcpu            = 2                                 // Increase CPU (default: 1)
memory          = 2048                              // Increase Memory (default: 1024)
apt_proxy_http  = "http://192.168.100.2:3142"       // APT cache for Ubuntu
apt_proxy_https = "DIRECT"                          // APT cache for Ubuntu
vm_id = {                                           // Manually assign VM numbers
  "packer00" = 9000
  "packer01" = 9001
}
