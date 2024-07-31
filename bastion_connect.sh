#!/bin/bash
#!/bin/bash

# Check if KEY_PATH is set
if [ -z "$KEY_PATH" ]; then
    echo "Error: KEY_PATH environment variable is not set."
    exit 5
fi

# Set the public and private instance details
PUBLIC_INSTANCE_USER="ubuntu"        # Replace with the username for your public instance
PUBLIC_INSTANCE_IP="public.instance.ip"   # Replace with the IP address of your public instance
PRIVATE_INSTANCE_USER="ubuntu"       # Replace with the username for your private instance
PRIVATE_INSTANCE_IP="private.instance.ip" # Replace with the IP address of your private instance

# SSH command to connect to the private instance through the public instance
ssh -i "$KEY_PATH" -o ProxyCommand="ssh -i $KEY_PATH -W %h:%p $PUBLIC_INSTANCE_USER@$PUBLIC_INSTANCE_IP" $PRIVATE_INSTANCE_USER@$PRIVATE_INSTANCE_IP
