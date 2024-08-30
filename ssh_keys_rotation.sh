#!/bin/bash

# Check if KEY_PATH is set
if [ -z "$KEY_PATH" ]; then
  echo "Error: KEY_PATH environment variable is not set."
  exit 5
fi

# Variables
BASTION_USER="ubuntu"  # Replace with the username for your bastion host
BASTION_HOST="13.60.213.231"  # Replace with your bastion host public IP address
PRIVATE_USER="ubuntu"  # Replace with the username for your private instance
PRIVATE_HOST="10.0.1.235"  # Replace with your private instance IP address
NEW_KEY_PATH="$HOME/.ssh/new_key"
NEW_PUB_KEY_PATH="${NEW_KEY_PATH}.pub"

# Generate a new SSH key pair
ssh-keygen -t rsa -b 2048 -f $NEW_KEY_PATH -q -N ""

# Copy the new public key to the private instance
cat $NEW_PUB_KEY_PATH | ssh -i "$KEY_PATH" -o ProxyCommand="ssh -W %h:%p -i $KEY_PATH $BASTION_USER@$BASTION_HOST" $PRIVATE_USER@$PRIVATE_HOST "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

#
