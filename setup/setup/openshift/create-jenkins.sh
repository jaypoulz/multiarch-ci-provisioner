#!/bin/bash
root_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )/..
cd $root_dir

oc login -u developer
oc create -f ../templates/jenkins-persistent.yml
oc new-app jenkins-persistent
exit 0
