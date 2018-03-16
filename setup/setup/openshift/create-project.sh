#!/bin/bash
root_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )/..
cd $root_dir

oc login -u developer
oc new-project redhat-multiarch-qe
exit 0
