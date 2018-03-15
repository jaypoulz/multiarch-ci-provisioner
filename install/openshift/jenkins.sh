#!/bin/bash
#
# Use this file to setup an OpenShift Jenkins master.
root_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )/..
cd $root_dir

# Initialize Jenkins instance
bash $root_dir/setup/openshift/create-jenkins.sh
