#!/bin/bash
#
# Sets up the OpenShift provisioner locally, on a dedicated VM, or on an existing OpenShift cluster.

cd "$(dirname "${BASH_SOURCE[0]}")"

# Ensure current user is in the docker group
group=docker
if [ $(id -gn) != $group ]
then
    exec sg $group "bash $0 $*"
fi

# Defaults
default_install_type=1

# Source functions
. setup/dependencies.sh
. setup/networking.sh

# Preliminary Questions
echo "Two installation types for the provisioner are available:"
echo "  1. Create a new single node OpenShift cluster"
echo "  2. Use a pre-existing OpenShift cluster"

echo "Please select your desired installation type: (default 1)"
read install_type
if [ -z "$install_type" ]
then
    install_type="$default_install_type"
fi

# Full installation
if [ "$install_type" = "1" ]
then
    echo "You've opted into installing a new single node OpenShift cluster."
    echo "Is this the node on which you'd like to install the cluster? (y/N)"
    read confirm
    if [ "$confirm" != "y" ]
    then
        echo "Please run this installation script on the host where you'd like to install the cluster."
        exit 0
    fi

    # Setup dependencies and docker
    echo "Installing dependencies is necessary before the provisioner can run."
    echo "Would you like to install dependencies (y/N)"
    read install_dependencies
    if [ "$install_dependencies" = "y" ]
    then
        setup_dependencies
    fi

    setup_networking
    route_address="$ip_address"".xip.io"
    nohup oc cluster up --public-hostname=$ip_address --routing-suffix=$route_address \
          --host-data-dir=/var/lib/origin/local --use-existing-config 
    cat nohup.out

# OpenShift content only
elif [ "$install_type" = "2" ]
then
    echo "You've opted into installing into a preexisting OpenShift cluster."
    echo "Is this a node in the cluster where the install can be preformed? (y/N)"
    read confirm
    if [ "$confirm" != "y" ]
    then
        echo "Please run this installation script on a host in the cluster where the install can be performed."
        exit 0
    fi

    setup_networking

# Invalid option
else
    echo "Invalid installation type: $install_type"
    exit 0
fi

echo "Would you like to install the provisioner on your OpenShift cluster? (y/N)"
read install_provisioner
if [ $install_provisioner = "y" ]
then
    # Initialize projects within cluster
    echo "Installing the OpenShift project to contain the provisioner."
    bash setup/openshift/project.sh

    echo "Installing the Jenkins instance to use with the provisioner."
    echo "$ip_address"
    bash setup/openshift/jenkins.sh "$ip_address"

    echo "Installing the provisioner image."
    bash setup/openshift/provisioner.sh
fi
