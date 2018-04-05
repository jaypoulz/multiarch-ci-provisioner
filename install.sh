#!/bin/bash
#
# Use this file to setup the OpenShift provisioner in a dedicated VM.
cd "$(dirname "${BASH_SOURCE[0]}")"

# Ensure current user is in the docker group
group=docker
if [ $(id -gn) != $group ]
then
    exec sg $group "bash $0 $*"
fi

# Defaults
default_install_type=1
default_ip_address=127.0.0.1

# Preliminary Questions
echo "Two installation types for the provisioner are available:"
echo "  1. Creating a new single node OpenShift cluster"
echo "  2. Using a pre-existing OpenShift cluster"

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
    echo "Would you like to install dependencies for running OpenShift via docker? (y/N)"
    read install_dependencies
    if [ "$install_dependencies" = "y" ]
    then
        bash setup/dependencies.sh
    fi

    # Get the external IP
    echo "Please enter the external IP address that will be used to route traffic into this cluster [default 127.0.0.1]:"
    read ip_address
    if [ -z "$ip_address" ]
    then
      ip_address="$default_ip_address"
    fi

    sudo iptables -F
    sudo service docker restart

    route_address="$ip_address"".xip.io"
    nohup oc cluster up --public-hostname=$ip_address --routing-suffix=$route_address \
          --host-data-dir=$HOME/origin --use-existing-config

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

     # Get the external IP
     echo "Please enter the external IP address that will be used to route traffic into this cluster [default 127.0.0.1]:"
     read ip_address
     if [ -z "$ip_address" ]
     then
       ip_address="$default_ip_address"
     fi

# Invalid option
else
    echo "Invalid installation type: $install_type"
    exit 0
fi


# Initialize projects within cluster
echo "Installing the OpenShift project to contain the provisioner."
bash setup/openshift/project.sh

echo "Installing the Jenkins instance to use with the provisioner."
echo "$ip_address"
bash setup/openshift/jenkins.sh "$ip_address"

echo "Installing the provisioner image."
bash setup/openshift/provisioner.sh
