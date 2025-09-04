variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-jenkins" {
  name    = "allow-jenkins"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}
