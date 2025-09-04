# Terraform Remote State Setup Guide

## 🚀 Overview

This guide explains how to set up and use remote Terraform state storage in Google Cloud Storage (GCS) for better collaboration, state locking, and backup.

## 📋 Prerequisites

- GCP Project with billing enabled
- Terraform CLI installed
- Google Cloud SDK (gcloud) installed and authenticated
- Appropriate IAM permissions for GCS bucket creation

## 🏗️ Architecture

```
Local Development
    ↓ (terraform init)
GCS Bucket (terraform-state-{project}-{env})
    ↓ (terraform plan/apply)
Remote State Management
    ↓
State Locking & Versioning
```

## 🚀 Quick Start

### 1. Initialize Backend (First Time Only)

```bash
# Set your project ID
export TF_VAR_project_id="your-gcp-project-id"
export TF_VAR_environment="dev"

# Initialize Terraform with local state first
terraform init

# Create the state bucket
terraform plan -target=module.bucket
terraform apply -target=module.bucket

# Initialize with remote backend
terraform init -backend-config="bucket=${TF_VAR_project_id}-terraform-state-${TF_VAR_environment}" \
               -backend-config="prefix=terraform/state"
```

### 2. Verify Remote State

```bash
# Check current backend configuration
terraform workspace list
terraform state list

# View state file in GCS
gsutil ls gs://${TF_VAR_project_id}-terraform-state-${TF_VAR_environment}/terraform/state/
```

## 📁 File Structure

```
terraform/
├── backend.tf          # Backend configuration
├── main.tf            # Main configuration with bucket module
├── providers.tf       # Provider configuration
├── variables.tf       # Variable definitions
└── modules/
    └── bucket/        # GCS bucket module
        └── main.tf    # Bucket creation resources
```

## 🔧 Configuration Details

### Backend Configuration (backend.tf)
```hcl
terraform {
  backend "gcs" {
    # Bucket name and prefix configured via -backend-config
  }
}
```

### Bucket Module Features
- ✅ **Versioning**: Automatic state file versioning
- ✅ **Encryption**: Server-side encryption enabled
- ✅ **IAM**: Proper service account permissions
- ✅ **Lifecycle**: Prevent accidental deletion
- ✅ **Labels**: Resource tagging for organization

## 🛠️ Commands Reference

### Initialize Backend
```bash
terraform init -backend-config="bucket=my-project-terraform-state-dev" \
               -backend-config="prefix=terraform/state"
```

### Migrate from Local to Remote State
```bash
# If you have existing local state
terraform init -migrate-state
```

### Force Unlock (Emergency Only)
```bash
terraform force-unlock LOCK_ID
```

### State Operations
```bash
# List resources in state
terraform state list

# Show resource details
terraform state show google_storage_bucket.terraform_state

# Remove resource from state (doesn't destroy)
terraform state rm module.bucket.google_storage_bucket.terraform_state
```

## 🔒 Security Best Practices

### IAM Permissions
Ensure your service account has these roles:
- `roles/storage.objectAdmin` on the state bucket
- `roles/storage.admin` for bucket management

### Bucket Security
- ✅ Uniform bucket-level access enabled
- ✅ Versioning enabled for state history
- ✅ Prevent destroy lifecycle rule
- ✅ Server-side encryption

## 🚨 Troubleshooting

### Common Issues

**1. Backend configuration changed**
```bash
# Reinitialize with new backend config
terraform init -reconfigure
```

**2. State lock conflicts**
```bash
# Check who has the lock
terraform force-unlock LOCK_ID
```

**3. Permission denied**
```bash
# Verify IAM permissions
gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --filter="bindings.role:roles/storage.objectAdmin"
```

## 📊 Monitoring & Maintenance

### State File Management
```bash
# View state file versions
gsutil ls -la gs://bucket/terraform/state/

# Clean up old versions (be careful!)
gsutil rm gs://bucket/terraform/state/*/*/*
```

### Cost Optimization
- State files are typically small (< 1MB)
- GCS storage costs are minimal
- Enable lifecycle policies for old versions if needed

## 🎯 Best Practices

1. **Use different buckets per environment** (dev, staging, prod)
2. **Enable versioning** for state file history
3. **Use state locking** to prevent concurrent modifications
4. **Regular backups** of state files
5. **Access control** with least privilege principle
6. **Documentation** of state file locations

## 📞 Support

For issues with remote state:
1. Check IAM permissions
2. Verify bucket exists and is accessible
3. Ensure backend configuration matches
4. Review Terraform logs for detailed errors

---

**Note**: Always backup your state files before making significant changes!
