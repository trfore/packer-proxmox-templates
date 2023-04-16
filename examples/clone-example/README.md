# Packer Proxmox Plugin: Clone Templates

Minimal example for creating clones of templates using the [Proxmox Packer builder - clone](https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/clone).

## Use

```sh
packer init .

# create a template clone
packer build \
-var 'pve_api_url=https://pve.example.com/api2/json' \
-var 'pve_node=pve' \
-var 'pve_username=packer@pve!token' \
-var 'pve_token=782a7700-4010-4802-8f4d-820f1b226850' \
-var 'template_name=ubuntu22-clone' \
-var 'vm_id=9023' \
-var 'clone_vm_id=9022' \
.
```
