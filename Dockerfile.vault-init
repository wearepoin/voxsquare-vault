# Start from a base image that has curl
FROM appropriate/curl

# Install jq for parsing JSON
RUN apk add --no-cache jq bash openssl

# Set the working directory
WORKDIR /app

# Copy the init script into the container
COPY init-vault.sh .

# Make the script executable
RUN chmod +x init-vault.sh

# Set entrypoint to run your initialization script
ENTRYPOINT ["bash", "./init-vault.sh"]
