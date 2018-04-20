#!/bin/bash
# Prompt the user if they want to install secrets
echo "The multi-arch provisioner currently only supports provisioning from beaker."
echo "Provisioning from beaker will require the following:"
echo "  - SSH Private Key"
echo "  - SSH Public Key"
echo "  - Kerberos Keytab"
echo "Would like like to install beaker secrets? [y/N]"
read install_secrets
if [ "$install_secrets"="y" ]
then
  dir=$(pwd)

  echo "Moving into credentials directory to install secrets"
  cd "$(dirname "${BASH_SOURCE[0]}")/../../../credentials"
  echo "You are now at: $(pwd)"

  # Install SSH Private Key
  echo "Please enter the path of the SSH Private Key:"
  read -e ssh_priv_key
  # Create the secret
  oc create secret generic sshprivkey --from-file=filename="${ssh_priv_key}"
  # Add label to mark that it should be synced.
  oc label secret sshprivkey credential.sync.jenkins.openshift.io=true
  
  # Install SSH Public Key
  echo "Please enter the path of the SSH Public Key:"
  read -e ssh_pub_key
  # Create the secret
  oc create secret generic sshpubkey --from-file=filename="${ssh_pub_key}"
  # Add label to mark that it should be synced.
  oc label secret sshpubkey credential.sync.jenkins.openshift.io=true

  # Install Kerberos Keytab
  echo "Please enter the path of the Kerberos Keytab:"
  read -e kerberos_keytab 
  # Create the secret
  oc create secret generic keytab --from-file=filename="${kerberos_keytab}"
  # Add label to mark that it should be synced.
  oc label secret keytab credential.sync.jenkins.openshift.io=true

  echo "Restoring previous working directory"
  cd $dir
else
  exit 0
fi



