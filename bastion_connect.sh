#!/bin/bash

# Function to print error message and exit with code 5
exit_with_error() {
  echo "Error: $1"
  exit 5
}

# Check if KEY_PATH is set
if [ -z "$KEY_PATH" ]; then
  exit_with_error "KEY_PATH environment variable is not set."
fi

# Ensure the key file exists
if [ ! -f "$KEY_PATH" ]; then
  exit_with_error "Key file at $KEY_PATH does not exist."
fi

# Variables
BASTION_USER="ec2-user"  # Replace with the username for your bastion host
BASTION_HOST="13.53.123.30"  # Replace with your bastion host public IP address
PRIVATE_USER="ec2-user"  # Replace with the username for your private instance
PRIVATE_HOST="51.21.149.22"  # Replace with your private instance IP address

# Connect to the private instance through the bastion host
ssh -i "$KEY_PATH" -o ProxyCommand="ssh -W %h:%p -i $KEY_PATH $BASTION_USER@$BASTION_HOST" $PRIVATE_USER@$PRIVATE_HOST
