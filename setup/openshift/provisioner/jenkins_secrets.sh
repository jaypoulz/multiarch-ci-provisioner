#!/bin/bash
#
# Attempts to install OpenShift secrets that will be mounted in Jenkins. Functions from credentials directory.
dir=$(pwd)
cd "$(dirname "${BASH_SOURCE[0]}")/../../.."
mkdir -p credentials

# Get or install a keytab
echo "Would you like to load a keytab from a file or create a new one?"
echo "  0. Do nothing if keytab is already installed"
echo "  1. Load existing keytab"
echo "  2. Create a new keytab"
read -p "Install option (default 0): " keytab_option

if [ "$keytab_option" = "1" ]
then
    echo "What kerberos principal should be used with this keytab?"
    read -p "Kerberos Principal: " krb_user
    echo "You are current in $(pwd)"
    read -e -p "Enter the path to the keytab: " keytab
    cp "$keytab" credentials/$krb_user.keytab
elif [ "$keytab_option" = "2" ]
then
    # Check if we need both packages
    if ! rpm -q krb5-workstation 2>&1 > /dev/null
    then
        sudo yum install krb5-workstation
    fi

    if ! rpm -q krb5-libs 2>&1 > /dev/null
    then
        sudo yum install krb5-libs
    fi

    echo "What kerberos principal should be used with this keytab?"
    read -p "Kerberos Principal: " krb_user
    read -sp "Kerberos Password: " pass
    echo

    rm credentials/$krb_user.keytab
    printf "%b" "addent -password -p $krb_user@REDHAT.COM -k 1 -e aes256-cts-hmac-sha1-96\n$pass\nwrite_kt credentials/$krb_user.keytab" | ktutil 2>&1 > /dev/null
    printf "%b" "read_kt credentials/$krb_user.keytab\nlist" | ktutil
    kinit -k -t credentials/$krb_user.keytab $krb_user@REDHAT.COM
    echo
else
    # Prompt for kerberos user
    echo "Skipped: Keytab installion"
    echo "What kerberos principal should be used with this keytab?"
    read -p "Kerberos Principal: " krb_user
fi

# Install ssh key pair
echo "Would you like to load an existing key pair or create a new one?"
echo "  0. Do nothing (key pair already installed)"
echo "  1. Load existing key pair"
echo "  2. Create a new key pair"
read -p "Install option (default 0): " key_pair_option

if [ "$key_pair_option" = "1" ]
then
    echo "You are current in $(pwd)"
    read -e -p "Enter the path to the private key: " priv_key
    read -e -p "Enter the path to the public key: " pub_key
    cp "$priv_key" credentials/id_rsa
    cp "$pub_key" credentials/id_rsa.pub
    echo "Installed key pair"
elif [ "$key_pair_option" = "2" ]
then
    echo "Preparing to create a new key pair"
    read -p "Email: " email
    ssh-keygen -t rsa -C $email -f credentials/id_rsa
    echo "Created new key pair"
    echo
    echo "In order to use this new keypair, you'll need to upload the public key to the beaker user account associated with this keytab."
    echo "  - You can do this at https://beaker.engineering.redhat.com/prefs/#ssh-public-keys"
    echo "  - The key you want to upload is at $(pwd)/credentials/id_rsa.pub"
    echo "Public key file:"
    cat credentials/id_rsa.pub
    echo
    echo "Have you finished uploading this new key to the beaker account associated with the provided keytab? (y/N)?"
    read public_key_uploaded
    if [ "$public_key_uploaded" = "y" ]
    then
        echo "Key install completed."
    else
        echo "Warning: key not uploaded to beaker, so provisioner requests will fail"
        exit 1
    fi
else
    echo "Skipped: Key pair installion"
fi
echo "The multi-arch provisioner currently only supports provisioning from beaker."
echo "Provisioning from beaker will require the following:"
echo "  - SSH Private Key"
echo "  - SSH Public Key"
echo "  - Kerberos Keytab"

echo "Moving into credentials directory to install secrets"
cd credentials
echo "Now at: $(pwd)"

# Install SSH Private Key
echo "Installing $(pwd)/id_rsa"
# Create the secret
oc create secret generic sshprivkey --from-file=filename="id_rsa"
# Add label to mark that it should be synced.
oc label secret sshprivkey credential.sync.jenkins.openshift.io=true

# Install SSH Public Key
echo "Installing $(pwd)/id_rsa.pub"
# Create the secret
oc create secret generic sshpubkey --from-file=filename="id_rsa.pub"
# Add label to mark that it should be synced.
oc label secret sshpubkey credential.sync.jenkins.openshift.io=true

# Install the Kerberos Principal
echo "Install Kerberos Principal"
# Create the secret
oc create secret generic krbprincipal --from-literal="username=$krb_user" --from-literal="password=none"
# Add label to mark that it should synced.
oc label secret krbprincipal credential.sync.jenkins.openshift.io=true

# Install Kerberos Keytab
echo "Installing ${krb_user}.keytab"
# Create the secret
oc create secret generic keytab --from-file=filename="${krb_user}.keytab"
# Add label to mark that it should be synced.
oc label secret keytab credential.sync.jenkins.openshift.io=true

echo "Restoring previous working directory"
cd $dir
