#!/bin/bash
#
# Use this file to setup the OpenShift provisioner in a dedicated VM.
root_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )/..
cd $root_dir

# Initialize projects within cluster
bash install/openshift/project.sh
bash install/openshift/jenkins.sh
bash install/openshift/provisioner.sh