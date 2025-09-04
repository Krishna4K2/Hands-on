terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region

  # Best practices for GCP provider
  request_timeout = "60s"
  request_reason  = "Terraform deployment for DevOps project"

  # Enable beta features if needed
  # beta = true
}

# Optional: Add random provider for generating unique names
provider "random" {
  # No configuration needed
}
