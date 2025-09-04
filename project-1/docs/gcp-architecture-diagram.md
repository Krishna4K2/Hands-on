# GCP Architecture Diagram

```mermaid
graph TB
    %% GCP Project and Organization
    subgraph "GCP Organization"
        PROJECT[GCP Project<br/>DevOps Project]

        subgraph "Identity & Access Management (IAM)"
            SA[🔑 Service Accounts<br/>Cloud Build SA<br/>Jenkins SA]
            ROLES[👥 IAM Roles<br/>Editor, Storage Admin<br/>Compute Admin]
        end
    end

    %% Networking Layer
    subgraph "Networking (VPC)"
        VPC[🌐 Virtual Private Cloud<br/>jenkins-vpc]
        SUBNET[📡 Subnet<br/>jenkins-subnet<br/>10.0.0.0/24]

        subgraph "Firewall Rules"
            FW_SSH[🔥 allow-ssh<br/>Port 22]
            FW_JENKINS[🔥 allow-jenkins<br/>Port 8080]
            FW_SONAR[🔥 allow-sonarqube<br/>Port 9000]
        end
    end

    %% Storage Layer
    subgraph "Storage Services"
        GCS[📦 Cloud Storage<br/>terraform-state-env]
        BUCKET_IAM[🔐 Bucket IAM<br/>Object Admin]
    end

    %% Compute Layer
    subgraph "Compute Engine"
        JENKINS_VM[🖥️ Jenkins VM<br/>e2-medium<br/>Ubuntu 22.04]
        SONAR_VM[🖥️ SonarQube VM<br/>e2-standard-2<br/>Ubuntu 22.04]

        subgraph "VM Specifications"
            JENKINS_SPEC[⚙️ Jenkins Config<br/>Docker, kubectl<br/>Helm, Java 17]
            SONAR_SPEC[⚙️ SonarQube Config<br/>PostgreSQL<br/>Code Analysis]
        end
    end

    %% Container & Orchestration
    subgraph "Container Services"
        GCR[🐳 Google Container Registry<br/>Container Images]
        GKE[☸️ Google Kubernetes Engine<br/>GKE Cluster]

        subgraph "Kubernetes Resources"
            DEPLOYMENT[🚀 Deployment<br/>demo-app]
            SERVICE[🔗 Service<br/>LoadBalancer]
            INGRESS[🌐 Ingress<br/>External Access]
        end
    end

    %% CI/CD Layer
    subgraph "CI/CD Services"
        CLOUDBUILD[⚡ Cloud Build<br/>Automated Pipeline]

        subgraph "Build Steps"
            TF_STEP[🏗️ Terraform<br/>IaC Deployment]
            ANSIBLE_STEP[⚙️ Ansible<br/>Configuration]
            TRIVY_STEP[🔍 Trivy<br/>Security Scan]
            SONAR_STEP[🎯 SonarQube<br/>Code Quality]
        end
    end

    %% Security & Monitoring
    subgraph "Security & Compliance"
        SECURITY[🛡️ Security Command Center<br/>Vulnerability Mgmt]
        MONITORING[📊 Cloud Monitoring<br/>Logs & Metrics]
        AUDIT[📋 Cloud Audit Logs<br/>Activity Tracking]
    end

    %% Connections and Flow
    PROJECT --> IAM
    PROJECT --> VPC
    PROJECT --> GCS
    PROJECT --> CLOUDBUILD
    PROJECT --> GKE
    PROJECT --> SECURITY

    VPC --> SUBNET
    VPC --> FW_SSH
    VPC --> FW_JENKINS
    VPC --> FW_SONAR

    SUBNET --> JENKINS_VM
    SUBNET --> SONAR_VM
    SUBNET --> GKE

    SA --> ROLES
    SA --> BUCKET_IAM
    SA --> CLOUDBUILD

    GCS --> BUCKET_IAM

    JENKINS_VM --> JENKINS_SPEC
    SONAR_VM --> SONAR_SPEC

    CLOUDBUILD --> TF_STEP
    CLOUDBUILD --> ANSIBLE_STEP
    CLOUDBUILD --> TRIVY_STEP
    CLOUDBUILD --> SONAR_STEP

    TF_STEP --> VPC
    TF_STEP --> JENKINS_VM
    TF_STEP --> SONAR_VM
    TF_STEP --> GCS

    ANSIBLE_STEP --> JENKINS_SPEC
    ANSIBLE_STEP --> SONAR_SPEC

    GCR --> GKE
    GKE --> DEPLOYMENT
    GKE --> SERVICE
    GKE --> INGRESS

    MONITORING --> JENKINS_VM
    MONITORING --> SONAR_VM
    MONITORING --> GKE
    AUDIT --> PROJECT

    %% Styling
    classDef gcp fill:#4285f4,stroke:#3367d6,stroke-width:2px,color:#ffffff
    classDef networking fill:#34a853,stroke:#2e7d32,stroke-width:2px,color:#ffffff
    classDef compute fill:#ea4335,stroke:#d33b2c,stroke-width:2px,color:#ffffff
    classDef storage fill:#fbbc04,stroke:#f57c00,stroke-width:2px,color:#000000
    classDef security fill:#9c27b0,stroke:#7b1fa2,stroke-width:2px,color:#ffffff
    classDef cicd fill:#00acc1,stroke:#00838f,stroke-width:2px,color:#ffffff

    class PROJECT,IAM,ROLES gcp
    class VPC,SUBNET,FW_SSH,FW_JENKINS,FW_SONAR networking
    class JENKINS_VM,SONAR_VM,JENKINS_SPEC,SONAR_SPEC,GKE,DEPLOYMENT,SERVICE,INGRESS compute
    class GCS,BUCKET_IAM,GCR storage
    class SECURITY,MONITORING,AUDIT security
    class CLOUDBUILD,TF_STEP,ANSIBLE_STEP,TRIVY_STEP,SONAR_STEP cicd
```

## 🏗️ **GCP Architecture Overview**

### **Core GCP Services Used:**

#### 1. **🏗️ Compute Services**
- **Compute Engine**: Ubuntu VMs for Jenkins and SonarQube servers
- **Kubernetes Engine (GKE)**: Container orchestration for application deployment
- **Container Registry (GCR)**: Docker image storage and management

#### 2. **🌐 Networking Services**
- **Virtual Private Cloud (VPC)**: Isolated network environment
- **Subnets**: IP address management and regional deployment
- **Firewall Rules**: Security policies for VM access control

#### 3. **📦 Storage Services**
- **Cloud Storage**: Terraform state file storage with versioning
- **Bucket IAM**: Fine-grained access control for state files

#### 4. **🔐 Identity & Security**
- **Service Accounts**: Automated authentication for CI/CD
- **IAM Roles**: Least-privilege access management
- **Security Command Center**: Vulnerability assessment and compliance

#### 5. **⚡ CI/CD Services**
- **Cloud Build**: Fully managed CI/CD platform
- **Build Triggers**: Automated pipeline execution
- **Artifact Management**: Build artifacts and container images

#### 6. **📊 Monitoring & Observability**
- **Cloud Monitoring**: Infrastructure and application metrics
- **Cloud Logging**: Centralized log aggregation
- **Cloud Audit Logs**: Security and compliance auditing

### **🏛️ Infrastructure Architecture:**

```
GCP Project (DevOps Project)
├── 🏗️ Infrastructure Layer
│   ├── 🌐 VPC Network (jenkins-vpc)
│   │   ├── 📡 Subnet (10.0.0.0/24)
│   │   └── 🔥 Firewall Rules (SSH, Jenkins, SonarQube)
│   └── 📦 Cloud Storage (terraform-state-{env})
├── 🖥️ Compute Layer
│   ├── 🖥️ Jenkins VM (e2-medium)
│   │   ├── Docker, kubectl, Helm
│   │   └── Java 17, Jenkins
│   └── 🖥️ SonarQube VM (e2-standard-2)
│       ├── PostgreSQL Database
│       └── Code Analysis Engine
├── ☸️ Container Layer
│   ├── 🐳 Google Container Registry
│   └── ☸️ Google Kubernetes Engine
│       └── 🚀 Application Deployment
└── ⚡ CI/CD Layer
    └── ⚡ Cloud Build Pipeline
        ├── 🏗️ Terraform (IaC)
        ├── ⚙️ Ansible (Configuration)
        ├── 🔍 Trivy (Security)
        └── 🎯 SonarQube (Quality)
```

### **🔄 Service Dependencies:**

| Service | Dependencies | Purpose |
|---------|-------------|---------|
| **VPC** | Project | Network isolation |
| **Compute Engine** | VPC, Subnet, Firewall | VM hosting |
| **GKE** | VPC, Subnet | Container orchestration |
| **Cloud Storage** | Project, IAM | State management |
| **Cloud Build** | Service Account, IAM | CI/CD automation |
| **IAM** | Project | Access management |

### **🛡️ Security Implementation:**

- **Network Security**: VPC isolation, firewall rules, private subnets
- **Access Control**: Service accounts with minimal required permissions
- **Data Protection**: Encrypted storage, secure state management
- **Compliance**: Audit logging, security scanning integration

### **📈 Scalability Features:**

- **Regional Deployment**: Multi-zone availability
- **Auto-scaling**: GKE cluster scaling capabilities
- **Load Balancing**: Application traffic distribution
- **Resource Management**: Efficient VM sizing and cost optimization

This architecture demonstrates enterprise-grade GCP infrastructure implementation with proper security, scalability, and operational excellence practices! 🚀
