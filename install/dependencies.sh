#!/bin/bash
root_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )/..
cd $root_dir

# Install yum dependecies
sudo yum install -y git docker firewalld;

# Get desired openshift client
. openshift/config.sh;
echo "Enter the desired OpenShift version (e.g. v3.6.1) [default LATEST]:";
read openshift_version;

# Download Specified OpenShift client
if [ -z "$openshift_version" ] 
then
  openshift_version="$OPENSHIFT__LATEST"
else
  openshift_version="OPENSHIFT__${openshift_version//./_}"
fi
eval curl -L --create-dirs --output downloads/openshift-tools.gz \${$openshift_version} &&
mkdir downloads/openshift-tools &&
tar xvzf downloads/openshift-tools.gz -C downloads/openshift-tools --strip-components=1 &&
sudo cp downloads/openshift-tools/oc /bin;

# Start Services
sudo systemctl enable docker;
sudo systemctl enable firewalld;
sudo systemctl start docker;
sudo systemctl start firewalld;

# Allow OpenShift docker registry
echo "INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'" | sudo tee -a /etc/sysconfig/docker;
echo "{ \"mtu\": 1400 }" | sudo tee /etc/docker/daemon.json;

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
