#!/bin/bash
oc login -u developer
oc create -f templates jenkins-persistent.yml
oc new-app jenkins-builder
exit 0
