#!/bin/bash

# Check if the IP address of the private instance is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <10.0.1.235>"
  exit 1
fi

PRIVATE_INSTANCE_IP="$1"

# Generate a new SSH key pair
NEW_KEY_PATH="$HOME/new_key"
ssh-keygen -t rsa -b 2048 -f "$NEW_KEY_PATH" -q -N ""

# Check if the key generation was successful
if [ $? -ne 0 ]; then
  echo "Failed to generate a new SSH key pair."
  exit 1
fi

# Copy the new public key to the private instance's authorized_keys
ssh-copy-id -i "${NEW_KEY_PATH}.pub" ubuntu@"$10.0.1.235"

# Check if the key was successfully copied
if [ $? -ne 0 ]; then
  echo "Failed to copy the new SSH key to the private instance."
  exit 1
fi

echo "New SSH key pair has been created and added to the private instance."
echo "Use the following command to connect to the private instance:"
echo "ssh -i $NEW_KEY_PATH ubuntu@$PRIVATE_INSTANCE_IP"
