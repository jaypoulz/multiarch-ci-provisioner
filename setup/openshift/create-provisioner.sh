#!/bin/bash
root_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )/..
cd $root_dir

oc login -u developer
oc create -f ../templates/provisioner.yml

oc create secret generic beaker --from-file ../images/provisioner/secrets/beaker/client.conf
oc create secret generic krb5 --from-file ../images/provisioner/secrets/krb5/krb5.conf

oc new-app provisioner-builder
oc login -u system:admin
oc adm policy add-scc-to-user privileged system:serviceaccount:redhat-multiarch-qe:jenkins
oc login -u developer

# List the jenkins token so you can easily copy it into the Jenkins instance
oc serviceaccounts get-token jenkins

exit 0