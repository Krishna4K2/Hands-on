terraform {
  backend "gcs" {
    # Bucket name will be provided via -backend-config
    # prefix = "terraform/state"
  }
}
