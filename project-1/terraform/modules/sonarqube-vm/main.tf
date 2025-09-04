variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "machine_type" {
  description = "GCE machine type for SonarQube instance"
  type        = string
  default     = "e2-standard-2"
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 50
}

locals {
  name_prefix = "sonarqube-${var.environment}"
  common_tags = {
    Name        = local.name_prefix
    Environment = var.environment
    Service     = "sonarqube"
    ManagedBy   = "terraform"
  }
}

resource "google_compute_instance" "sonarqube" {
  name         = "${local.name_prefix}-instance"
  machine_type = var.machine_type
  zone         = "${var.region}-a"
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = var.disk_size
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id
    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    startup-script = <<-EOF
      #!/bin/bash
      # Update system
      apt-get update
      apt-get upgrade -y

      # Install basic tools
      apt-get install -y curl wget git unzip

      # Create directories
      mkdir -p /opt/sonarqube/data
      mkdir -p /opt/sonarqube/logs
      mkdir -p /opt/sonarqube/extensions

      # Set permissions
      chown -R ubuntu:ubuntu /opt/sonarqube
    EOF
  }

  tags = ["sonarqube", "http-server", "https-server"]

  service_account {
    scopes = ["cloud-platform"]
  }

  # Enable confidential computing for better security (optional)
  # confidential_instance_config {
  #   enable_confidential_compute = false
  # }

  # Shielded VM configuration for enhanced security
  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  lifecycle {
    ignore_changes = [
      metadata["ssh-keys"]  # Ignore changes to SSH keys
    ]
  }
}

# Firewall rule for SonarQube (port 9000)
resource "google_compute_firewall" "sonarqube" {
  name    = "${local.name_prefix}-firewall"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }

  source_ranges = ["0.0.0.0/0"]  # In production, restrict to specific IPs
  target_tags   = ["sonarqube"]

  description = "Allow HTTP access to SonarQube"
}

# Optional: Create a static IP for SonarQube
resource "google_compute_address" "sonarqube" {
  name         = "${local.name_prefix}-ip"
  region       = var.region
  project      = var.project_id
  address_type = "EXTERNAL"
  description  = "Static IP for SonarQube instance"
}

output "sonarqube_instance_ip" {
  description = "Public IP of SonarQube instance"
  value       = google_compute_instance.sonarqube.network_interface[0].access_config[0].nat_ip
}

output "sonarqube_static_ip" {
  description = "Static IP address of SonarQube instance"
  value       = google_compute_address.sonarqube.address
}

output "sonarqube_instance_name" {
  description = "Name of SonarQube instance"
  value       = google_compute_instance.sonarqube.name
}

output "sonarqube_instance_zone" {
  description = "Zone of SonarQube instance"
  value       = google_compute_instance.sonarqube.zone
}
