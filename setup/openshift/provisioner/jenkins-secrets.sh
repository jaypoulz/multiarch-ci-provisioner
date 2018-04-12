#!/bin/bash
# Prompt the user if they want to install secrets
echo "The multi-arch provisioner currently only supports provisioning from beaker."
echo "Provisioning from beaker will require the following:"
echo "  - SSH Private Key"
echo "  - SSH Public Key"
echo "  - Kerberos Keytab"
echo "Would like like to install beaker secrets? [y/N]"
read install_secrets
if [ "$install_secrets"= "y" ]
then
  # Install SSH Private Key
  echo "Please enter the path of the SSH Private Key:"
  read ssh_priv_key
  # Create the secret
  oc create secret generic SSHPRIVKEY --from-file=filename="${ssh_priv_key}"
  # Add label to mark that it should be synced.
  oc label secret SSHPRIVKEY credential.sync.jenkins.openshift.io=true
  
  # Install SSH Public Key
  echo "Please enter the path of the SSH Public Key:"
  read ssh_pub_key
  # Create the secret
  oc create secret generic SSHPUBKEY --from-file=filename="${ssh_pub_key}"
  # Add label to mark that it should be synced.
  oc label secret SSHPUBKEY credential.sync.jenkins.openshift.io=true

  # Install Kerberos Keytab
  echo "Please enter the path of the Kerberos Keytab:"
  read keberos_keytab 
  # Create the secret
  oc create secret generic KEYTAB --from-file=filename="${kerberos_keytab}"
  # Add label to mark that it should be synced.
  oc label secret KEYTAB credential.sync.jenkins.openshift.io=true
else
  exit 0
fi



