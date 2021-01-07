#!/bin/bash

# Check for root priveleges
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  echo 'You must run this script with root priveleges' 2> std.err | cat
  exit 1
fi

# Usage message
HOW_TO_USE='Usage: add-new-user.sh username accountholders name [...]'

# Check for correct no. of args
if [[ "${#}" -lt 1 ]]; then
  echo 'You must provide a Username' 2> std.err | cat
  echo ${HOW_TO_USE}
  exit 1
elif [[ "${#}" -lt 2 ]]; then
  echo 'You must provide the account holders name' 2> std.err | cat
  echo ${HOW_TO_USE}
  exit 1
fi


# Assign username
USER_NAME="${1}"

# Comment for the name of the account holder
shift
COMMENT="${*}"
# Create the user
useradd -c "${COMMENT}" -m ${USER_NAME}

if [[ ${?} -ne 0 ]]
then
  echo 'Account creation failed at the useradd stage' 2> std.err | cat
  exit 1
fi

# Set random password for user
PASSWORD="$(echo ${RANDOM}$(date +%s%N) | sha256sum | head -c 12)"
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

if [[ ${?} -ne 0 ]]
then
  echo 'Account created but password setup failed' 2> std.err | cat
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
