variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
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
output "jenkins_ip" {
  value = module.vm.jenkins_ip
}

output "sonarqube_ip" {
  value = module.sonarqube_vm.sonarqube_instance_ip
}
