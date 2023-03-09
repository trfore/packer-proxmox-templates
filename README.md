# Packer Proxmox Templates

Turnkey Packer templates for downloading Debian and Ubuntu images on Proxmox (PVE) and creating PVE templates -
see below for details on [CentOS](#centos).

```sh
# create a SSH key for Packer
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/packer_id_ed25519 -C "Packer"

# clone the repo & cd into it
git clone https://github.com/trfore/packer-proxmox-templates.git
cd packer-proxmox-templates

# initialize packer
packer init common/.

# choose a distro
cd ubuntu

# create the PVE templates
packer build \
-var='pve_api_url=https://pve.example.com/api2/json' \
-var='pve_node=pve' \
-var='pve_username=packer@pve!token' \
-var='pve_token=782a7700-4010-4802-8f4d-820f1b226850' \
.
```

**NOTE**: The **default user** is the distributions name, e.g. `ubuntu`, with the exception of CentOS being
`cloud-user`. Cloud-init will create a default user on all cloned VMs,
**must add SSH key(s) and/or password in the Proxmox GUI cloud-init settings to access the VM** - SSH only
accepts key based authentication. All images have `cloud-init`, `openssh-server` and `qemu-guest-agent` installed.

**NOTE**: All images are built using only the `root` user, **no default users are created during the build**. We suggest
creating a temporary SSH key-pair for Packer to use, i.e. `packer_id_ed25519`. This key is removed from the `root`
account prior to finishing the build. After the build, `root` SSH access is disabled.

```sh
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/packer_id_ed25519 -C "Packer"
```

## Repo Layout

- Common files are stored in `common/`, with each distribution folder containing symlinks to these files.

  - [`iso-vars.pkr.hcl`](common/iso-vars.pkr.hcl) contains ISO URLs and boot commands for each distribution. This file
    is updated as new releases become available.
  - [`pve-image.pkr.hcl`](common/pve-image.pkr.hcl) is the main source file.
  - [`pve-vars.pkr.hcl`](common/pve-vars.pkr.hcl) is used to store variables related to Proxmox.

- cloud-init, kickstart, and preseed configurations are stored within the `configs/` folder and are
  distribution-specific.

- The `template/` folder is useful for generating new build configurations, as it:
  - Contains symlinks to the common files.
  - An [`template.auto.pkrvars.hcl`](template/template.auto.pkrvars.hcl) file for overwriting the default variable values.
    - Note: If you clone or fork this repo, `.gitignore` is set to ignore other `.auto.pkrvars.hcl` files.
  - An example build section in [`template.pkr.hcl`](template/template.pkr.hcl) with multiple approaches.

## Grant Packer Access to Proxmox

```sh Grant Packer Access to Proxmox
# create role
pveum role add PackerUser --privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Sys.Audit Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Console VM.Monitor VM.PowerMgmt"

# create group
pveum group add packer-users

# add permissions
pveum acl modify / -group packer-users -role PackerUser

# create user 'packer'
pveum useradd packer@pve -groups packer-users

# generate a token
pveum user token add packer@pve token -privsep 0
```

The last command will output a token value similar to the following:

```sh Example PVE Token
┌──────────────┬──────────────────────────────────────┐
│ key          │ value                                │
╞══════════════╪══════════════════════════════════════╡
│ full-tokenid │ packer@pve!token                     │
├──────────────┼──────────────────────────────────────┤
│ info         │ {"privsep":"0"}                      │
├──────────────┼──────────────────────────────────────┤
│ value        │ 782a7700-4010-4802-8f4d-820f1b226850 │
└──────────────┴──────────────────────────────────────┘
```

## Packer Commands

Initialize Packer:

```sh
packer init common/.
```

With the symlinked common files, Packer commands work within each linux folder:

```sh
cd ubuntu
packer fmt .
packer init .
packer validate .
```

Distro folders typically contain multiple images, you can limit the build by adding the `-except=` or `-only=` flag.
Example passing Proxmox credentials:

```sh
cd ubuntu
# build all images
packer build \
-var='pve_api_url=https://pve.example.com/api2/json' \
-var='pve_node=node01' \
-var='pve_username=packer@pve!token' \
-var='pve_token=782a7700-4010-4802-8f4d-820f1b226850' \
.

# build a single image
packer build \
-var='pve_api_url=https://pve.example.com/api2/json' \
-var='pve_node=node01' \
-var='pve_username=packer@pve!token' \
-var='pve_token=782a7700-4010-4802-8f4d-820f1b226850' \
-only=proxmox-iso.ubuntu20 \
.
```

## Important Variables

All variables can be redefined using a `*.auto.pkrvars.hcl` file, see example file: [`template.auto.pkrvars.hcl`](template/template.auto.pkrvars.hcl).
Reminder: `.gitignore`is set to ignore other `.auto.pkrvars.hcl` files, so storing your personal values in a new file,
`ubuntu.auto.pkrvars.hcl`, inside each distribution's directory will be ignored by git.

| Variable                  | Default           | Description                                              | Required | Plugin Variable Equivalent |
| ------------------------- | ----------------- | -------------------------------------------------------- | -------- | -------------------------- |
| `pve_api_url`             |                   | String, Proxmox URL                                      | **Yes**  | `proxmox_url`              |
| `pve_node`                | `pve`             | String, Proxmox target node for ISOs and templates       | **Yes**  | `node`                     |
| `pve_username`            |                   | String, Proxmox username for Packer                      | **Yes**  | `username`                 |
| `pve_token`               |                   | String, Proxmox token value for Packer                   | **Yes**  | `token`                    |
| `iso_download_pve`        | `true`            | Boolean, All ISOs are downloaded to Proxmox              | No       |                            |
| `cloud_init`              | `true`            | Boolean, Attach a cloud-init drive                       | No       | `cloud_init`               |
| `cloud_init_storage_pool` | `local-lvm`       | String, Proxmox storage pool to use for cloud-init drive | No       | `cloud_init_storage_pool`  |
| `scsi_controller`         | `virtio-scsi-pci` | String, SCSI controller model                            | No       |                            |
| `disk_type`               | `scsi`            | String, Storage bus/device                               | No       | `type`                     |
| `disk_storage_pool`       | `local-lvm`       | String, Storage pool name                                | No       | `storage_pool`             |
| `disk_cache_mode`         | `writeback`       | String, Storage cache mode                               | No       | `cache_mode`               |
| `net_bridge`              | `vmbr0`           | String, NIC name                                         | No       | `bridge`                   |
| `net_model`               | `virtio`          | String, NIC type                                         | No       | `model`                    |
| `net_vlan_tag`            | `1`               | String, NIC VLAN tag                                     | No       | `vlan_tag`                 |

### SSH

**NOTE**: We suggest creating a temporary SSH key-pair for Packer to use during the build, i.e. `packer_id_ed25519`. This key is removed from the `root` account
prior to finishing the build. Alternatively, you can use a pre-existing key and set: `ssh_keypair_name`, `ssh_private_key_file` and `ssh_public_key_file`.
Example key generation:

```sh
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/packer_id_ed25519 -C "Packer"
```

| Variable                    | Default                        | Description                                                          | Required |
| --------------------------- | ------------------------------ | -------------------------------------------------------------------- | -------- |
| `ssh_username`              | `root`                         | String, SSH user for Packer build, used by SSH communicator          | No       |
| `ssh_password`              | `password`                     | String, SSH user password for Packer build (**Debian** only)         | No       |
| `ssh_timeout`               | `20m`                          | String, Packer SSH timeout                                           | No       |
| `ssh_clear_authorized_keys` | `true`                         | Boolean, Remove the Packer SSH key from `/root/.ssh/authorized_keys` | No       |
| `ssh_keypair_name`          | `packer_id_ed25519`            | String, SSH key name for Packer to use                               | **Yes**  |
| `ssh_private_key_file`      | `~/.ssh/packer_id_ed25519`     | String, Private SSH key for Packer                                   | **Yes**  |
| `ssh_public_key_file`       | `~/.ssh/packer_id_ed25519.pub` | String, Public SSH key for Packer                                    | **Yes**  |

### VM IDs

VM IDs, `vm_id`, default to `0` and will use the next free value from Proxmox. If you would like to fix these values
create a `*.auto.pkrvars.hcl` within each OS folder (HCL type: `map(numeric)`):

```HCL
// ubuntu.auto.pkrvars.hcl
vm_id = {
  "ubuntu20" = 9020
  "ubuntu22" = 9022
}
```

### Other Variables

See [`iso-vars.pkr.hcl`](common/iso-vars.pkr.hcl) and [`pve-vars.pkr.hcl`](common/pve-vars.pkr.hcl)

## Distro Configurations

### CentOS

- The **default** user is `cloud-user`, update the **username**, **ssh key(s)**, and/or **password** using the Proxmox
  cloud-init GUI.
- [CentOS kickstart file (link)](centos/configs/anaconda-ks.cfg)
- **Important**: CentOS URLs and checksums are intentionally not provided, as bandwidth is limited and ISOs are not
  available from `mirror.centos.org`. To set a mirror create an auto vars file, `centos/centos.auto.pkrvars.hcl`, and
  add the closest geographic mirror from the list: [CentOS 9 Stream Mirrors] or [Fedora Mirror Manager]. Alternatively,
  create your own installation tree: [CentOS Docs - Creating Installation Sources for Kickstart].

  | Variable                  | Default | Description                                                                | Required |
  | ------------------------- | ------- | -------------------------------------------------------------------------- | -------- |
  | `iso_url`                 | `''`    | Map(string), URL                                                           | **Yes**  |
  | `iso_checksum`            | `''`    | Map(string), prepend URL with `file:`                                      | **Yes**  |
  | `centos_install_url`      | `''`    | Map(string), URL - single source, not a mirror list                        | **Yes**  |
  | `centos_mirror_appstream` | `''`    | Map(string), URL - mirror list, if set packages will be updated on install | No       |
  | `centos_mirror_baseos`    | `''`    | Map(string), URL - mirror list, if set packages will be updated on install | No       |
  | `centos_mirror_extras`    | `''`    | Map(string), URL - mirror list, if set packages will be updated on install | No       |

  ```HCL
  // centos.auto.pkrvars.hcl
  centos_install_url = {
    "centos8" = "https://mirror.example.com/centos/8-stream/BaseOS/x86_64/os/"
    "centos9" = "https://mirror.example.com/centos-stream/9-stream/BaseOS/x86_64/os/"
  }
  iso_url = {
    "centos8" = "https://mirror.example.com/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-latest-boot.iso"
    "centos9" = "https://mirror.example.com/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-boot.iso"
  }
  iso_checksum = {
    "centos8" = "file:https://mirror.example.com/centos/8-stream/isos/x86_64/CHECKSUM"
    "centos9" = "file:https://mirror.example.com/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-boot.iso.MD5SUM"
  }
  ```

### Debian

- The **default** user is `debian`, update the **username**, **ssh key(s)**, and/or **password** using the Proxmox
  cloud-init GUI.
- [Debian preseed file (link)](debian/configs/preseed.cfg)

### Ubuntu

- The **default** user is `ubuntu`, update the **username**, **ssh key(s)**, and/or **password** using the Proxmox
  cloud-init GUI.
- [Ubuntu cloud-config file (link)](ubuntu/configs/user-data)
- Setting `apt_proxy_http` and/or `apt_proxy_https`, creates a proxy file at `/etc/apt/apt.conf.d/90curtin-aptproxy`.
  Set using format: `"https://[[user][:pass]@]host[:port]/"`, also possible to set value of `"DIRECT"` when using
  [Apt-Cacher NG](https://help.ubuntu.com/community/Apt-Cacher%20NG).

  | Variable          | Default | Description                                                         | Required |
  | ----------------- | ------- | ------------------------------------------------------------------- | -------- |
  | `apt_proxy_http`  | `''`    | String, APT proxy URL for Ubuntu. Default value skips setting proxy | No       |
  | `apt_proxy_https` | `''`    | String, APT proxy URL for Ubuntu. Default value skips setting proxy | No       |

- Result of setting `apt_proxy_http="http://192.168.100.2:3142"` and `apt_proxy_https="DIRECT"`:

  ```sh
  # /etc/apt/apt.conf.d/90curtin-aptproxy
  Acquire::http::proxy "http://192.168.100.2:3142";
  Acquire::https::proxy "DIRECT";
  ```

## Maintainers & License

Taylor Fore [(@trfore)](https://github.com/trfore)

See [LICENSE](LICENSE) File

## References

Blog Post:

- [Golden Images and Proxmox Templates with Packer](https://trfore.com/posts/)

Packer:

- [Packer](https://developer.hashicorp.com/packer)
- [Packer Docs: Build Command](https://developer.hashicorp.com/packer/docs/commands/build)
- [Packer Plugin: Proxmox](https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox)
- [GitHub: hashicorp/packer-plugin-proxmox](https://github.com/hashicorp/packer-plugin-proxmox)

CentOS:

- [CentOS Docs - Creating Installation Sources for Kickstart]
- [CentOS 8 Stream Mirrors](http://isoredirect.centos.org/centos/8-stream/isos/x86_64/)
- [CentOS 9 Stream Mirrors]
- [Fedora Mirror Manager]

Debian:

- [Debian Release - Stable](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/)
- [Debian Release - Archive](https://get.debian.org/images/archive/)
- [Debian Preseed](https://wiki.debian.org/DebianInstaller/Preseed)
- [Debian Installation Guide - Preseeding](https://www.debian.org/releases/stable/amd64/apb.en.html)
- [Debian Preseed Example](https://www.debian.org/releases/stable/example-preseed.txt)

Ubuntu:

- [Ubuntu Releases](https://releases.ubuntu.com/)
- [Ubuntu Docs: Automated Server Installation](https://ubuntu.com/server/docs/install/autoinstall)

[CentOS Docs - Creating Installation Sources for Kickstart]: https://docs.centos.org/en-US/8-docs/advanced-install/assembly_creating-installation-sources-for-kickstart-installations/
[CentOS 9 Stream Mirrors]: https://www.centos.org/download/mirrors/
[Fedora Mirror Manager]: https://mirrors.fedoraproject.org/
