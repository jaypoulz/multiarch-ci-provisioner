#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Defaults
default_openshift_version=v3.9.0

# Install yum dependecies
sudo yum install -y git docker firewalld;

# Get desired openshift client
. setup/openshift/config.sh;
echo "Enter the desired OpenShift version [default $default_openshift_version]:";
read openshift_version;

# Download Specified OpenShift client
if [ -z "$openshift_version" ]
then
  openshift_version=$default_openshift_version
fi
openshift_version="OPENSHIFT__${openshift_version//./_}"

eval curl -L --create-dirs --output downloads/${openshift_version}.gz \${$openshift_version} &&
mkdir -p downloads/${openshift_version} &&
tar xvzf downloads/${openshift_version}.gz -C downloads/${openshift_version} --strip-components=1 &&
sudo cp downloads/${openshift_version}/oc /usr/local/bin

# Start Services
sudo systemctl enable docker;
sudo systemctl enable firewalld;
sudo systemctl start docker;
sudo systemctl start firewalld;

# Allow OpenShift docker registry
echo "Adding OpenShift insecure registry to docker"
if grep -xqsE "^[[:space:]]*INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'" /etc/sysconfig/docker
then
  echo "Registry already enabled"
else
  if grep -xqsE "# INSECURE_REGISTRY='--insecure-registry'" /etc/sysconfig/docker
  then
    echo "Adding insecure registery to /etc/sysconfig/docker"
    sed -E "/# INSECURE_REGISTRY='--insecure-registry'/a INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'" /etc/sysconfig/docker | sudo tee 1> /dev/null /etc/sysconfig/docker
  else
    echo "Appending insecure registry to end of /etc/sysconfig/docker"
    echo "INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'" | sudo tee 1> /dev/null -a /etc/sysconfig/docker
  fi
fi

# Reduce the MTU for docker so that packets don't get dropped
echo "Reducing MTU to match CI-RHOS environment"
if grep -qsE "[\'\"]mtu[\'\"]\s*:\s*[\'\"]?[0-9]+[\'\"]?" /etc/docker/daemon.json
then
  echo "Downgrading existing MTU configuration to 1400 in /etc/docker/daemon.json"
  sed -E "s/[\'\"]mtu[\'\"]\s*:\s*[\'\"]?[0-9]+[\'\"]?/\"mtu\": 1400/" /etc/docker/daemon.json | sudo tee 1> /dev/null /etc/docker/daemon.json
else
  if grep -qzsE "\{.*:.*\}" /etc/docker/daemon.json
  then
    echo "Adding MTU configuration to /etc/docker/daemon.json after the opening curly brace"
    sed -E "s/\{/\{\n  \"mtu\"\: 1400\,/" /etc/docker/daemon.json | sudo tee 1> /dev/null /etc/docker/daemon.json
  else
    echo "Create a new /etc/docker/daemon.json to set MTU to 1400"
    echo "{ \"bip\": \"172.17.0.0/16\", \"mtu\": 1400 }" | sudo tee 1> /dev/null /etc/docker/daemon.json
  fi
fi

# Open up ports for connections to docker
sudo firewall-cmd --permanent --new-zone dockerc;
sudo firewall-cmd --permanent --zone dockerc --add-source 172.17.0.0/16;
sudo firewall-cmd --permanent --zone dockerc --add-port 8443/tcp;
sudo firewall-cmd --permanent --zone dockerc --add-port 53/udp;
sudo firewall-cmd --permanent --zone dockerc --add-port 8053/udp;
sudo firewall-cmd --permanent --zone dockerc --add-port 50000/tcp;
sudo firewall-cmd --reload;

# Allow sudoless docker
echo "Creating docker group"
sudo getent group docker &>/dev/null || sudo groupadd docker
echo "Adding user to docker group"
sudo usermod -aG docker $USER
