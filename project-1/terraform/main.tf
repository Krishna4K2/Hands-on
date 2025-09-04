variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# GCS Bucket for Terraform State (must be created first)
module "bucket" {
  source      = "./modules/bucket"
  project_id  = var.project_id
  region      = var.region
  bucket_name = "${var.project_id}-terraform-state-${var.environment}"
  environment = var.environment
}

# VPC Module
module "vpc" {
  source     = "./modules/vpc"
  project_id = var.project_id
  region     = var.region
}

# VM Module
module "vm" {
  source    = "./modules/vm"
  project_id = var.project_id
  region     = var.region
  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.vpc.subnet_id
}

# Firewall Module
module "firewall" {
  source    = "./modules/firewall"
  project_id = var.project_id
  vpc_id     = module.vpc.vpc_id
}

# Service Account Module
module "service_account" {
  source     = "./modules/service_account"
  project_id = var.project_id
}

# SonarQube VM Module
module "sonarqube_vm" {
  source     = "./modules/sonarqube-vm"
  project_id = var.project_id
  region     = var.region
  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.vpc.subnet_id
}

# Outputs
output "terraform_state_bucket" {
  description = "GCS bucket name for Terraform state"
  value       = module.bucket.bucket_name
}

output "terraform_state_bucket_url" {
  description = "GCS bucket URL for Terraform state"
  value       = module.bucket.bucket_url
}

output "jenkins_ip" {
  value = module.vm.jenkins_ip
}

output "sonarqube_ip" {
  value = module.sonarqube_vm.sonarqube_instance_ip
}
