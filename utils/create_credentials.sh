#!/bin/bash
echo "Create a keytab or load one from a file"

# SOME LOGIC HERE TO GET A KEYTAB

# ELSE CREATE IT
# TODO check if we need both packages
if ! rpm -q krb5-workstation 2>&1 > /dev/null
then
  sudo yum install krb5-workstation
fi

if ! rpm -q krb5-libs 2>&1 > /dev/null
then
  sudo yum install krb5-libs
fi

read -p "Kerberos username: " user
read -sp "Kerberos password: " pass
echo

printf "%b" "addent -password -p $user@REDHAT.COM -k 1 -e aes256-cts-hmac-sha1-96\n$pass\nwrite_kt $user.keytab" | ktutil 2>&1 > /dev/null
printf "%b" "read_kt $user.keytab\nlist" | ktutil

echo
kinit -k -t $user.keytab $user@REDHAT.COM
