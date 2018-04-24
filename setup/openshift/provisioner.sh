#!/bin/bash
#
# Attempts to install provisioner and its secrets. Spits out the Jenkins service account credentials.
cd "$(dirname "${BASH_SOURCE[0]}")/.."

oc login -u developer

# Install Jenkins secrets
bash openshift/provisioner/jenkins_secrets.sh

# Create the template and its configuration secrets
oc create -f ../templates/provisioner.yml
oc create secret generic beaker --from-file ../images/provisioner/secrets/beaker/client.conf
oc create secret generic krb5 --from-file ../images/provisioner/secrets/krb5/krb5.conf

# Create the actual provisioner
oc new-app provisioner-builder

# Promote Jenkins Service Account to privileged for external Jenkins setups
oc login -u system:admin
oc adm policy add-scc-to-user privileged system:serviceaccount:redhat-multiarch-qe:jenkins
oc login -u developer

# List the jenkins token so you can easily copy it into the Jenkins instance
oc serviceaccounts get-token jenkins
