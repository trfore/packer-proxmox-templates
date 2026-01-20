#!/bin/bash
set -euxo pipefail

while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done
# clean image identifiers
cloud-init clean --machine-id --seed
rm /etc/hostname /etc/ssh/ssh_host_* /var/lib/systemd/random-seed
truncate -s 0 /root/.ssh/authorized_keys
sed -i 's/^#PasswordAuthentication\\ yes/PasswordAuthentication\\ no/' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin\\ prohibit-password/PermitRootLogin\\ no/' /etc/ssh/sshd_config