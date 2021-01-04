#!/bin/bash

# Check for root priveleges
if [[ $(/usr/bin/id -u) -ne 0 ]]
then
  echo 'You must run this script with root priveleges'
  exit 1
fi

# Ask for username
read -p 'Enter the username to create: ' USER_NAME

# Ask for name of new account holder
read -p 'Enter name of new account holder: ' COMMENT

# Ask for password
read -p 'Enter the password to be used for this account: ' PASSWORD

# Create the user
useradd -c "${COMMENT}" -m ${USER_NAME}

if [[ ${?} -ne 0 ]]
then
  echo 'Account creation failed at the useradd stage'
  exit 1
fi

# Set password for user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

if [[ ${?} -ne 0 ]]
then
  echo 'Account created but password setup failed'
  exit 1
fi

# Force Password change on first login
passwd -e ${USER_NAME}

# Print new account details
echo
echo "Account Created - Username: ${USER_NAME}"
echo
echo "Password: ${PASSWORD}"
echo
echo "Hostname: $(hostname)"
echo

exit 0