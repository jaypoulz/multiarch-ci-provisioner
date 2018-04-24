#!/bin/bash
#
# Installs Jenkins persistent template under developer account.
cd "$(dirname "${BASH_SOURCE[0]}")/.."

oc login -u developer
oc create -f ../templates/jenkins-persistent.yml
oc new-app jenkins-persistent -p PUBLIC_IP=$1
