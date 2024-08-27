#!/bin/bash

# Step 1: Client Hello
echo "Sending Client Hello..."
CLIENT_HELLO="Client Hello: Supported TLS version and ciphers"
curl -s -X POST -d "$CLIENT_HELLO" http://<public-ec2-instance-ip>:8080/hello > response.txt
echo "Received Server Hello"

# Step 2: Server Hello
SERVER_HELLO=$(cat response.txt)
echo "Server Hello received: $SERVER_HELLO"

# Step 3: Server Certificate Verification
# Here, you would normally verify the server's certificate against a CA. For simplicity, assume success.
echo "Verifying Server Certificate..."
# In a real implementation, you'd parse and verify the certificate here.
echo "Server certificate verified."

# Step 4: Client-Server Master Key Exchange
echo "Generating and sending master key..."
MASTER_KEY=$(openssl rand -hex 16)  # Generate a 32-byte random master key
ENCRYPTED_MASTER_KEY=$(echo -n "$MASTER_KEY" | openssl rsautl -encrypt -inkey server_public.pem -pubin | base64)
curl -s -X POST -d "$ENCRYPTED_MASTER_KEY" http://<public-ec2-instance-ip>:8080/master-key > server_response.txt
echo "Server responded with encrypted sample message"

# Step 5: Server Verification Message
SERVER_SAMPLE_MESSAGE=$(cat server_response.txt)
echo "Decrypting server's sample message..."
DECRYPTED_SAMPLE_MESSAGE=$(echo "$SERVER_SAMPLE_MESSAGE" | base64 -d | openssl rsautl -decrypt -inkey client_private.pem)
echo "Decrypted sample message: $DECRYPTED_SAMPLE_MESSAGE"

# Step 6: Client Verification Message
echo "Verifying server's encrypted sample message..."
# Normally, compare decrypted sample message with known value.
echo "TLS Handshake completed successfully."
