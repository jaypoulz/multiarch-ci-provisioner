#!/bin/bash
#
# Use this file to setup the OpenShift provisioner in a dedicated VM.
root_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )/..
cd $root_dir

# Setup dependencies and docker
bash $root_dir/install/dependencies.sh

# Launch OpenShift cluster
bash $root_dir/setup/start-cluster.sh

# Initialize projects within cluster
bash $root_dir/install/openshift.sh
