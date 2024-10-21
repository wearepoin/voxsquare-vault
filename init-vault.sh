#!/bin/sh

# Wait for Vault to be ready
until curl -s ${VAULT_CONTAINER_ADDR}/v1/sys/health | grep '"initialized":true' > /dev/null; do
  echo "Waiting for Vault to be ready..."
  sleep 2
done

# Export the Vault token for authentication
export VAULT_TOKEN=${VAULT_TOKEN}

# Check if the secrets already exist
EXISTING_SECRETS=$(curl --header "X-Vault-Token: ${VAULT_TOKEN}" \
                     --request GET \
                     --silent \
                     ${VAULT_CONTAINER_ADDR}/v1/secret/data/encryption-secrets | jq -r '.data.data')

# If the secrets don't exist, create and insert new ones
if [ "$EXISTING_SECRETS" = "null" ]; then
  echo "No encryption secrets found. Generating new secrets..."

  ENCRYPTION_ALGORITHM="aes-256-cbc"
  KEY=$(openssl rand -hex 32)  # Generate a 32-byte hex key for AES-256
  IV=$(openssl rand -hex 16)   # Generate a 16-byte hex IV

  # Insert the encryption details into Vault
  curl --header "X-Vault-Token: ${VAULT_TOKEN}" \
       --request POST \
       --data "{\"data\": {\"algorithm\": \"${ENCRYPTION_ALGORITHM}\", \"key\": \"${KEY}\", \"iv\": \"${IV}\"}}" \
       ${VAULT_CONTAINER_ADDR}/v1/secret/data/encryption-secrets

  echo "Vault has been initialized with new encryption secrets."
else
  echo "Encryption secrets already exist. Skipping generation."
fi
