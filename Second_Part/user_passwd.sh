#!/bin/bash
#
# This script creates a new user on the local system.
# You will be prompted to enter the username (login), the person name, and a password.
# The username, password, and host for the account will be displayed.

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
   echo 'Please run this script with sudo or as root.'
   exit 1
fi

# Get the username (login).
read -p 'Enter the username to create: ' USER_NAME

# Get the real name (contents for the description field).
read -p 'Enter the profession of the person or application that will be using this account: ' COMMENT

# Get the password.
read -sp 'Enter the password to use for the account: ' PASSWORD

# optional - automatically generate a password
#PASSWORD=$(openssl rand -base64 20) 

# Create the account.
useradd -m -p $(echo $PASSWORD | openssl passwd -6 -stdin) -c "${COMMENT}" ${USER_NAME}

# Check to see if the useradd command succeeded.
# We don't want to tell the user that an account was created when it hasn't been.
if [[ "${?}" -eq 0 ]]
then
  echo -e '\nThis username and password have been successfully added.'
  echo "Here : $(tail -1 /etc/passwd)"
else
  echo 'This username is already exit. Please select different username '
  exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo