# Contributing

## Contribute

- Please discuss large refactors or major features by creating an [ISSUE](https://github.com/trfore/packer-proxmox-templates/issues) first.
- [Fork the repository](https://github.com/trfore/packer-proxmox-templates/fork) on github and clone it.
- Create a new branch and add your code.
  - Please test changes using your local PVE cluster before creating a pull-request.
  - For simple distro adds, duplicating and renaming the [template](template) folder will preserve all symlinks and provide a starting point. **Be sure to rename `template.auto.pkrvars.hcl` and `template.pkr.hcl`**
- Push the changes to your fork and submit a pull-request on github.
  - The maintainer(s) will confirm the changes on a private cluster.

```sh
git clone https://github.com/USERNAME/packer-proxmox-templates/ && cd packer-proxmox-templates
git checkout -b MY_BRANCH
# add code and test
git push -u origin MY_BRANCH
gh pr create --title 'feature: add ...'
```

### All `*.auto.pkrvars.hcl` Files Are Ignored

- Creating a `*.auto.pkrvars.hcl` within a distro folder, for example `debian/debian.auto.pkrvars.hcl`, is helpful for storing your own private PVE token values and quickly testing changes. This should allow you to simply run the command: `packer build -only=proxmox-iso.DISTRO_NAME`.
- This is due to these files being ignored in [gitignore](.gitignore), except for `template/template.auto.pkrvars.hcl`.

```hcl
// template/template.auto.pkrvars.hcl
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
```

### Documentation

- New features or extensive code changes need to be accompanied by documentation in the README.


## Additional References

- [Ansible community guide](https://docs.ansible.com/ansible/devel/community/index.html)
- [Github Docs: Forking a repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#forking-a-repository)
- [Ansible Docs: `ansible-core` support matrix](https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-core-support-matrix)
