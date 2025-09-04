# DevOps Project Architecture Diagram

```mermaid
graph TB
    %% Developer Workflow
    subgraph "Developer Workflow"
        DEV[👨‍💻 Developer]
        GIT[📚 Git Repository<br/>Hands-on/project-1]
        PUSH[Push Code]
    end

    %% CI/CD Pipeline
    subgraph "CI/CD Pipeline (Cloud Build)"
        CB[☁️ GCP Cloud Build]
        TF[🏗️ Terraform<br/>Infrastructure Provisioning]
        ANS[⚙️ Ansible<br/>Configuration Management]
        TRIVY[🔍 Trivy<br/>Security Scanning]
        SONAR[🎯 SonarQube<br/>Code Quality Analysis]
    end

    %% Infrastructure Layer
    subgraph "Infrastructure Layer (GCP)"
        VPC[🌐 VPC Network<br/>Custom VPC]
        FW[🔥 Firewall Rules<br/>Security Groups]
        SA[🔑 Service Accounts<br/>IAM Roles]

        subgraph "Compute Resources"
            JENKINS_VM[🖥️ Jenkins Server VM<br/>Ubuntu 22.04]
            SONAR_VM[🖥️ SonarQube Server VM<br/>Ubuntu 22.04]
        end

        subgraph "Container Orchestration"
            GKE[☸️ GKE Cluster<br/>Kubernetes]
        end
    end

    %% Application Layer
    subgraph "Application Layer"
        DEMO_APP[🚀 Demo Application<br/>Node.js + Express]

        subgraph "Containerization"
            DOCKER[🐳 Docker<br/>Multi-stage Build]
        end

        subgraph "Deployment"
            HELM[⚓ Helm Charts<br/>Kubernetes Deployment]
        end
    end

    %% Configuration Management
    subgraph "Configuration Management"
        JENKINS_ROLE[📋 Jenkins Ansible Role<br/>- Docker Installation<br/>- kubectl Setup<br/>- Helm Installation<br/>- Security Hardening]
        SONAR_ROLE[📋 SonarQube Ansible Role<br/>- PostgreSQL Setup<br/>- SonarQube Installation<br/>- Database Configuration]
    end

    %% Monitoring & Security
    subgraph "Monitoring & Security"
        HEALTH[💚 Health Checks<br/>Application Monitoring]
        LOGS[📊 Logging<br/>Centralized Logs]
        SEC[🛡️ Security<br/>Vulnerability Scanning]
    end

    %% Flow Connections
    DEV --> PUSH
    PUSH --> GIT
    GIT --> CB

    CB --> TF
    CB --> ANS
    CB --> TRIVY
    CB --> SONAR

    TF --> VPC
    TF --> FW
    TF --> SA
    TF --> JENKINS_VM
    TF --> SONAR_VM
    TF --> GKE

    ANS --> JENKINS_ROLE
    ANS --> SONAR_ROLE

    JENKINS_ROLE --> JENKINS_VM
    SONAR_ROLE --> SONAR_VM

    DEMO_APP --> DOCKER
    DOCKER --> HELM
    HELM --> GKE

    GKE --> HEALTH
    GKE --> LOGS
    GKE --> SEC

    %% Styling
    classDef infrastructure fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef cicd fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef application fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef security fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef developer fill:#fce4ec,stroke:#880e4f,stroke-width:2px

    class VPC,FW,SA,JENKINS_VM,SONAR_VM,GKE infrastructure
    class CB,TF,ANS,TRIVY,SONAR cicd
    class DEMO_APP,DOCKER,HELM application
    class HEALTH,LOGS,SEC security
    class DEV,GIT,PUSH,JENKINS_ROLE,SONAR_ROLE developer
```

## 📋 Architecture Overview

### 🏗️ **Infrastructure as Code (Terraform)**
- **VPC Module**: Custom network with subnets and routing
- **VM Modules**: Jenkins and SonarQube server provisioning
- **Firewall Module**: Security rules and network policies
- **Service Account Module**: IAM roles and permissions
- **GKE Module**: Kubernetes cluster for application deployment

### ⚙️ **Configuration Management (Ansible)**
- **Jenkins Role**: Complete CI/CD server setup with Docker, kubectl, Helm
- **SonarQube Role**: Code quality server with PostgreSQL database
- **Playbooks**: Automated configuration deployment
- **Inventory**: Dynamic host management

### ☁️ **CI/CD Pipeline (Cloud Build)**
- **Multi-stage Pipeline**: Infrastructure → Configuration → Security → Deployment
- **Parallel Processing**: Concurrent security scanning and testing
- **Artifact Management**: Docker images and Helm charts
- **Integration Testing**: End-to-end validation

### 🐳 **Containerization & Orchestration**
- **Docker**: Multi-stage builds with security hardening
- **Kubernetes**: Container orchestration via GKE
- **Helm**: Application packaging and deployment
- **Health Checks**: Application monitoring and auto-healing

### 🔍 **Security & Quality**
- **Trivy**: Container and IaC vulnerability scanning
- **SonarQube**: Code quality analysis and technical debt tracking
- **Security Contexts**: Kubernetes pod security policies
- **Network Security**: VPC firewalls and service mesh

### 📊 **Monitoring & Observability**
- **Health Checks**: Application availability monitoring
- **Logging**: Centralized log aggregation
- **Metrics**: Performance and resource monitoring
- **Alerting**: Automated incident response

## 🔄 **Workflow Sequence**

1. **Development** → Developer pushes code to Git repository
2. **CI Trigger** → Cloud Build detects changes and starts pipeline
3. **Infrastructure** → Terraform provisions GCP resources
4. **Configuration** → Ansible configures servers (Jenkins & SonarQube)
5. **Security Scan** → Trivy scans for vulnerabilities
6. **Code Quality** → SonarQube analyzes code quality
7. **Build** → Docker creates application container
8. **Deploy** → Helm deploys to Kubernetes cluster
9. **Monitor** → Health checks and logging ensure stability

## 🛠️ **Technology Stack**

| Category | Technologies |
|----------|-------------|
| **IaC** | Terraform, HCL |
| **Configuration** | Ansible, YAML |
| **CI/CD** | Cloud Build, Jenkins |
| **Containerization** | Docker, Containerd |
| **Orchestration** | Kubernetes, Helm |
| **Security** | Trivy, SonarQube |
| **Cloud** | Google Cloud Platform |
| **Application** | Node.js, Express |
| **Database** | PostgreSQL |
| **Monitoring** | Health Checks, Logging |

## 🎯 **Key Features Demonstrated**

- ✅ **DevOps**: Complete automation from code to production
- ✅ **DevSecOps**: Security scanning integrated into pipeline
- ✅ **Cloud Engineering**: GCP services and best practices
- ✅ **Platform Engineering**: Kubernetes orchestration
- ✅ **Site Reliability**: Monitoring and reliability patterns
- ✅ **Infrastructure as Code**: Version-controlled infrastructure
- ✅ **GitOps**: Git-driven deployment workflows
