storage "file" {
  path = "/vault/file"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = false  # Disable TLS for simplicity; in production, use HTTPS
}

disable_mlock = true  # For Docker containers; mlock isn't supported in containers
ui = true  # Enable Vault UI
