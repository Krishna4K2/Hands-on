# Documentation Assets

This folder contains images, architecture diagrams, and Mermaid diagrams for the project.

## Contents
- **Images**: Screenshots and visuals from deployments.
- **Architecture Diagrams**: High-level overviews of the setup.
- **Mermaid Diagrams**: Interactive flowcharts (e.g., CI/CD pipelines).

## Sample Architecture Diagram

```
GCP Cloud
├── Cloud Build (CI/CD Pipeline)
│   ├── Terraform (IaC)
│   ├── Ansible (Configuration)
│   ├── Trivy (Security Scans)
│   └── SonarQube (Code Quality)
├── Compute Engine VMs
│   ├── Jenkins Server
│   │   ├── Docker
│   │   ├── kubectl
│   │   └── Helm
│   └── SonarQube Server
│       ├── PostgreSQL
│       └── Code Analysis
└── GKE Cluster
    └── Demo App (via Helm)
        ├── Node.js Application
        ├── Health Checks
        └── Monitoring
```

*Add actual diagram images here for visual representation.*

## Things to Do (Setup Checklist)

Before deploying the project, complete these steps:

### 1. GCP Configuration
- [ ] Create/enable GCP project with billing
- [ ] Enable required APIs: Compute Engine, Cloud Build, Container Registry, Kubernetes Engine
- [ ] Create service account with necessary permissions (Editor role)
- [ ] Download service account key JSON file
- [ ] Create GCS bucket for Trivy scan results (e.g., `your-project-trivy-results`)

### 2. Local Environment Setup
- [ ] Install Terraform (>= 1.0)
- [ ] Install Ansible
- [ ] Install gcloud CLI and authenticate
- [ ] Generate SSH key pair (`ssh-keygen -t rsa -b 2048`)
- [ ] Set environment variables:
  - `JENKINS_ADMIN_PASSWORD` (secure password)
  - `SONARQUBE_URL` (SonarQube server URL)
  - `SONARQUBE_TOKEN` (SonarQube authentication token)

### 3. Project Configuration
- [ ] Update `terraform/variables.tf` with your GCP project ID
- [ ] Update `ansible/inventory.ini` with Jenkins VM IP (after Terraform deployment)
- [ ] Update `demo-app/Jenkinsfile`:
  - Replace `'your-gcp-project-id'` with actual GCP project ID
  - Update GCS bucket references from `your-bucket` to actual bucket name
- [ ] Update `demo-app/helm/values.yaml`:
  - Replace `YOUR_PROJECT_ID` with actual GCP project ID
- [ ] Update `cloudbuild/cloudbuild.yaml`:
  - Update GCS bucket references

### 4. Optional Components
- [ ] Set up SonarQube server (for code quality scans)
- [ ] Configure Jenkins credentials with GCP service account key
- [ ] Add SSL certificates for secure access
- [ ] Set up monitoring/alerting (e.g., Prometheus, GCP Monitoring)

### 5. Deployment Steps
- [ ] Run `terraform init && terraform plan && terraform apply` (or via Cloud Build)
- [ ] Update Ansible inventory with VM IP
- [ ] Run Ansible playbook: `ansible-playbook -i inventory.ini playbook.yml`
- [ ] Access Jenkins at `http://<VM_IP>:8080`
- [ ] Configure Jenkins pipeline with `demo-app/Jenkinsfile`
- [ ] Test the deployment

### 6. Post-Deployment
- [ ] Verify all components are running
- [ ] Run security scans and review results
- [ ] Add monitoring dashboards
- [ ] Document any custom configurations
- [ ] Create backup/restore procedures

### Notes
- All placeholder values (marked with `your-` or `YOUR_`) must be replaced with actual values
- Ensure all environment variables are set before deployment
- Test in a development environment first
- Keep sensitive files (keys, passwords) secure and not committed to git
