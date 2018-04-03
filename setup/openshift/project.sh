#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")/.."

oc login -u developer
oc new-project redhat-multiarch-qe
exit 0
