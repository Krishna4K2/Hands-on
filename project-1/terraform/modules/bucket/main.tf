variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "Name of the GCS bucket for Terraform state"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# GCS Bucket for Terraform State
resource "google_storage_bucket" "terraform_state" {
  name                        = var.bucket_name
  location                    = var.region
  project                     = var.project_id
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  labels = {
    environment = var.environment
    purpose     = "terraform-state"
    managed_by  = "terraform"
  }
}

# Bucket IAM binding for Terraform service account
resource "google_storage_bucket_iam_member" "terraform_state_sa" {
  bucket = google_storage_bucket.terraform_state.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.project_id}@${var.project_id}.iam.gserviceaccount.com"
}

# Outputs
output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.terraform_state.name
}

output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = google_storage_bucket.terraform_state.url
}
