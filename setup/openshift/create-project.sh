#!/bin/bash
oc login -u developer
oc new-project redhat-multiarch-qe
oc new-app jenkins-persistent
oc create -f templates/jenkins-jnlp-external.yml
exit 0
