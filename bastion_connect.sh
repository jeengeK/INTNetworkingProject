#!/bin/bash

# Check if enough arguments are provided
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <bastion-ip> <private-instance-ip> <command>"
  exit 1
fi

BASTION_IP="$1"
PRIVATE_INSTANCE_IP="$2"
REMOTE_COMMAND="$3"

# SSH key file path (update if necessary)
SSH_KEY_PATH="$HOME/.ssh/id_rsa"  # Replace with the path to your SSH key if different

# Execute the command on the private instance via the bastion host
ssh -i "$SSH_KEY_PATH" -o ProxyCommand="ssh -i $SSH_KEY_PATH -W %h:%p ubuntu@$BASTION_IP" ubuntu@$PRIVATE_INSTANCE_IP "$REMOTE_COMMAND"
