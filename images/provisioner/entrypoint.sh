#!/bin/bash
source $(which virtualenvwrapper.sh)
workon provisioner
exec "$@"
