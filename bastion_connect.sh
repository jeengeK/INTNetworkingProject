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
BASTION_USER="ubuntu"  # Replace with the username for your bastion host
BASTION_HOST="13.60.10.155"  # Replace with your bastion host public IP address
PRIVATE_USER="ubuntu"  # Replace with the username for your private instance
PRIVATE_HOST="10.0.1.232"  # Replace with your private instance IP address


# Connect to the private instance through the bastion host
ssh -t -i "$KEY_PATH"  "$BASTION_USER@$BASTION_HOST" $PRIVATE_USER@$PRIVATE_HOST

