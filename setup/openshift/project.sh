#!/bin/bash
#
# Creates OpenShift project redhat-multiarch-qe under developer user.
cd "$(dirname "${BASH_SOURCE[0]}")/.."

oc login -u developer
oc new-project redhat-multiarch-qe
