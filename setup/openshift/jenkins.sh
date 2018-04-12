#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")/.."

bash openshift/jenkins/validating-string-param-plugin.sh

oc login -u developer
oc create -f ../templates/jenkins-persistent.yml
oc new-app jenkins-persistent -p PUBLIC_IP=$1
