#!/bin/bash

# Check if KEY_PATH environment variable is set
if [ -z "$KEY_PATH" ]; then
    echo "KEY_PATH env var is expected"
    exit 5
fi

# Check for the correct number of arguments
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <public-instance-ip> [<private-instance-ip> <command>]"
    echo "Please provide bastion IP address"
    exit 5
fi

# Extract arguments
PUBLIC_INSTANCE_IP="$1"
PRIVATE_INSTANCE_IP="$2"
COMMAND="$3"
#nothing

# Function to connect to the public instance directly
connect_to_public_instance() {
    ssh -i "$KEY_PATH" "ubuntu@$PUBLIC_INSTANCE_IP"
}

# Function to connect to the private instance through the public instance
connect_to_private_instance() {
    ssh -i "$KEY_PATH" -o ProxyCommand="ssh -i $KEY_PATH -W %h:%p ubuntu@$PUBLIC_INSTANCE_IP" ubuntu@$PRIVATE_INSTANCE_IP
}

# Function to execute a command on the private instance
execute_command_on_private_instance() {
    ssh -i "$KEY_PATH" -o ProxyCommand="ssh -i $KEY_PATH -W %h:%p ubuntu@$PUBLIC_INSTANCE_IP" ubuntu@$PRIVATE_INSTANCE_IP "$COMMAND"
}

# Determine the action based on the number of arguments
if [ -z "$PRIVATE_INSTANCE_IP" ]; then
    # No private instance IP provided, connect to the public instance directly
    connect_to_public_instance
else
    # Private instance IP provided, connect to the private instance through the public instance
    if [ -z "$COMMAND" ]; then
        # No command provided, just connect to the private instance
        connect_to_private_instance
    else
        # Command provided, execute the command on the private instance
        execute_command_on_private_instance
    fi
fi
