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

resource "google_compute_instance" "jenkins" {
  name         = "jenkins-instance"
  machine_type = "e2-medium"
  zone         = "${var.region}-a"
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id
    access_config {}
  }

  metadata = {
    ssh-keys = "user:${file("~/.ssh/id_rsa.pub")}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

output "jenkins_ip" {
  value = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
}
