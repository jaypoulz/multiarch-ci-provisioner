#!/bin/bash
#
# Prompts user for a public facing IP that beaker can use to talk back, and resets the networking config.

default_ip_address=$(hostname -I | awk '{ print $1 }')

function setup_networking() {
    # Get the external IP
    echo "Please enter the external IP address that will be used to route traffic into this cluster."
    echo "  - In the case of installation on a CI-RHOS host, this should be your public/external IP."
    echo "  - If this is your local workstation, this should be the internal IP given to you by the RedHat network DHCP server. *Note* this will only work for as long as this IP belongs *uniquely* to you."
    echo "IP Address [default $default_ip_address]:"
    read ip_address
    if [ -z "$ip_address" ]
    then
        ip_address="$default_ip_address"
    fi

    sudo iptables -F
    sudo service docker restart
}
