#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"
oc cluster down
rm nohup.out
mount | grep /var/lib/origin/openshift.local.volumes/ | awk '{ print $3 }' | sudo xargs umount
sudo rm -rf /var/lib/origin
