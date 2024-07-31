#!/bin/bash

# Ensure the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <private-instance-ip>"
    exit 1
fi

PRIVATE_INSTANCE_IP="$1"
KEY_DIR="$HOME/.ssh"
OLD_KEY="${KEY_DIR}/id_rsa"
NEW_KEY="${KEY_DIR}/id_rsa_new"

# Generate a new SSH key pair
ssh-keygen -t rsa -b 2048 -f "$NEW_KEY" -N ""

# Copy the new public key to the private instance
ssh -i "$KEY_PATH" ubuntu@"$PRIVATE_INSTANCE_IP" "mkdir -p ~/.ssh && chmod 700 ~/.ssh"
scp -i "$KEY_PATH" "${NEW_KEY}.pub" ubuntu@"$PRIVATE_INSTANCE_IP":~/.ssh/authorized_keys_new

# Add the new public key to the authorized_keys file on the private instance
ssh -i "$KEY_PATH" ubuntu@"$PRIVATE_INSTANCE_IP" "cat ~/.ssh/authorized_keys_new >> ~/.ssh/authorized_keys"

# Remove the old key from authorized_keys
ssh -i "$KEY_PATH" ubuntu@"$PRIVATE_INSTANCE_IP" "grep -v -f ~/.ssh/authorized_keys_new ~/.ssh/authorized_keys > ~/.ssh/authorized_keys_temp && mv ~/.ssh/authorized_keys_temp ~/.ssh/authorized_keys"

# Clean up
ssh -i "$KEY_PATH" ubuntu@"$PRIVATE_INSTANCE_IP" "rm ~/.ssh/authorized_keys_new"

# Notify the user
echo "SSH key rotation complete. New key pair generated: ${NEW_KEY} and ${NEW_KEY}.pub"

# Test connection with the new key
echo "Testing connection with new key..."
ssh -i "$NEW_KEY" ubuntu@"$PRIVATE_INSTANCE_IP" "echo 'Connection successful with new key!'"

# Optional: clean up old key files
rm "$OLD_KEY" "$NEW_KEY" "$NEW_KEY.pub"

# Notify the user
echo "Old key removed and new key pair cleaned up."

