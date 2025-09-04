# Automated Jenkins Deployment on GCP with Terraform, Ansible, and Cloud Build

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?style=flat&logo=terraform)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-2.9+-EE0000?style=flat&logo=ansible)](https://www.ansible.com/)
[![Docker](https://img.shields.io/badge/Docker-20.10+-2496ED?style=flat&logo=docker)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.24+-326CE5?style=flat&logo=kubernetes)](https://kubernetes.io/)
[![Jenkins](https://img.shields.io/badge/Jenkins-2.387+-D24939?style=flat&logo=jenkins)](https://www.jenkins.io/)
[![GCP](https://img.shields.io/badge/GCP-Cloud-4285F4?style=flat&logo=google-cloud)](https://cloud.google.com/)

This project demonstrates a comprehensive DevOps, DevSecOps, Cloud, Platform, and SRE setup by deploying a Jenkins CI/CD server on GCP. It covers end-to-end automation, security, monitoring, and reliability.

## Project Status
✅ **Infrastructure**: Terraform modules for VPC, VM, firewall, service accounts  
✅ **Configuration**: Ansible roles for Jenkins setup with security hardening  
✅ **CI/CD**: Cloud Build pipeline with security scans  
✅ **Application**: Node.js demo app with Helm deployment  
✅ **Security**: Trivy scans, SonarQube integration, SSH hardening  
✅ **Monitoring**: Prometheus integration, health checks  
✅ **Documentation**: Comprehensive README and setup guides  

**Ready for Deployment!** 🚀
- **terraform/**: Infrastructure as Code using Terraform modules (vpc, vm, firewall, service_account).
- **ansible/**: Configuration management using Ansible roles (jenkins role with Helm installed).
- **cloudbuild/**: CI/CD pipeline for automated deployment.
- **demo-app/**: Sample Node.js app with Helm chart for Kubernetes deployment.
- **docs/**: Images, diagrams, and architecture assets.

## Prerequisites
- GCP account.
- Terraform, Ansible, gcloud CLI installed.
- SSH key pair.

## Setup Steps
1. **Clone and Configure**:
   - Set your GCP project ID in `terraform/variables.tf`.
   - Update `ansible/inventory.ini` with Jenkins VM IP (replace `<JENKINS_IP>`).
   - In `demo-app/Jenkinsfile`, replace `'your-gcp-project-id'` with your actual project ID.
   - In `demo-app/helm/values.yaml`, replace `YOUR_PROJECT_ID` with your GCP project ID.
   - Set environment variables: `JENKINS_ADMIN_PASSWORD`, `SONARQUBE_URL`, `SONARQUBE_TOKEN`.
   - Create GCS bucket for Trivy results and update `gs://your-bucket/` references.

2. **Deploy via Cloud Build**:
   - Push to GitHub.
   - Trigger Cloud Build with `cloudbuild/cloudbuild.yaml` to set up infrastructure and Jenkins.

3. **Configure Jenkins for Demo-App**:
   - Access Jenkins at `http://<JENKINS_IP>:8080`.
   - Create a new pipeline job pointing to the `demo-app/Jenkinsfile`.
   - Upload your GCP service account key to Jenkins credentials for auth.
   - Run the pipeline to build and deploy the demo-app to GKE.

4. **Demo App**:
   - Jenkins pipeline handles building (Docker), pushing to GCR, security scanning, and deploying to GKE via Helm.

## Best Practices Implemented
- **Terraform**: Modular structure with versions.tf, providers.tf, and reusable modules.
- **Ansible**: Roles with defaults, vars, tasks, handlers, and ansible.cfg for configuration.
- **Cloud Build**: Structured YAML with security scans and proper timeouts.
- **Jenkins**: Declarative pipeline with linting, testing, security scans, and post-build cleanup.
- **Docker**: Multi-stage builds, non-root user, and security best practices.
- **Kubernetes**: Resource limits, health probes, and rolling updates.
- **Security**: Trivy scans, SSH hardening, and least-privilege access.

## Security & Monitoring
- **SonarQube Integration**: Scans Terraform (IaC quality) and demo-app (code quality/security). Requires SonarQube server setup.
  - Set `SONARQUBE_URL` and `SONARQUBE_TOKEN` in Cloud Build/Jenkins environment variables.
  - Terraform: Scanned in Cloud Build with project key `terraform-iac`.
  - Demo-App: Scanned in Jenkins with `sonar-project.properties`.
- **Trivy Scans**: Results pushed to SonarQube via API and GCS bucket `gs://your-bucket/trivy-results/`.
- **Access**: View reports in SonarQube dashboard for vulnerabilities, code smells, and quality gates.

## 🤝 Contributing

Feel free to fork and enhance! This project welcomes contributions from the DevOps community.

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](../LICENSE) file for details.

---

## Showcase This Project

This project demonstrates expertise in:
- **DevOps**: Infrastructure as Code, CI/CD pipelines, automation
- **DevSecOps**: Security scanning, hardening, compliance
- **Cloud Engineering**: GCP services, containerization, orchestration
- **Platform Engineering**: Kubernetes, Helm, microservices
- **SRE**: Monitoring, reliability, incident response

Perfect for **LinkedIn posts**, **GitHub portfolio**, and **job applications**! 🎯

⭐ **Don't forget to star this repository** if you found it helpful!
