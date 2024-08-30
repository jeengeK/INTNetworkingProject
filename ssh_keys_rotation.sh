#!/bin/bash

# Check if the IP address of the private instance is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <private-instance-ip>"
  exit 1
fi

PRIVATE_INSTANCE_IP="$1"
NEW_KEY_PATH="$HOME/new_key"

# Generate a new SSH key pair
echo "Generating a new SSH key pair..."
ssh-keygen -t rsa -b 2048 -f "$NEW_KEY_PATH" -q -N ""

# Check if the key generation was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to generate a new SSH key pair."
  exit 1
fi
echo "New SSH key pair generated at $NEW_KEY_PATH and ${NEW_KEY_PATH}.pub"

# Test connection to the private instance
echo "Testing SSH connection to the private instance..."
ssh -o BatchMode=yes -o ConnectTimeout=5 ubuntu@"$PRIVATE_INSTANCE_IP" "echo 'Connected successfully.'"

if [ $? -ne 0 ]; then
  echo "Error: Unable to connect to the private instance at $PRIVATE_INSTANCE_IP. Check network or SSH key permissions."
  exit 1
fi

# Copy the new public key to the private instance's authorized_keys
echo "Copying the new SSH public key to the private instance..."
ssh-copy-id -i "${NEW_KEY_PATH}.pub" ubuntu@"$PRIVATE_INSTANCE_IP"

# Check if the key was successfully copied
if [ $? -ne 0 ]; then
  echo "Error: Failed to copy the new SSH key to the private instance."
  exit 1
fi
echo "New SSH key successfully copied to the private instance."

# Verify the new key works by connecting and running a command
echo "Verifying the new key works by connecting to the private instance..."
ssh -i "$NEW_KEY_PATH" -o BatchMode=yes -o ConnectTimeout=5 ubuntu@"$PRIVATE_INSTANCE_IP" "echo 'New key is working.'"

if [ $? -ne 0 ]; then
  echo "Error: Failed to connect to the private instance with the new SSH key."
  exit 1
fi

echo "Success: The new SSH key works. You can now connect using the command:"
echo "ssh -i $NEW_KEY_PATH ubuntu@$PRIVATE_INSTANCE_IP"
