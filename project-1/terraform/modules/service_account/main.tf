variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

resource "google_service_account" "cloudbuild_sa" {
  account_id   = "cloudbuild-sa"
  display_name = "Cloud Build Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "cloudbuild_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

output "service_account_email" {
  value = google_service_account.cloudbuild_sa.email
}
