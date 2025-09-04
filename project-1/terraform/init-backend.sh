#!/bin/bash

# Terraform Remote State Initialization Script
# This script helps set up remote state storage in GCS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if required tools are installed
check_dependencies() {
    print_info "Checking dependencies..."

    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install Terraform first."
        exit 1
    fi

    if ! command -v gcloud &> /dev/null; then
        print_error "Google Cloud SDK is not installed. Please install gcloud CLI first."
        exit 1
    fi

    print_success "Dependencies check passed"
}

# Get project ID
get_project_id() {
    if [ -z "$TF_VAR_project_id" ]; then
        read -p "Enter your GCP Project ID: " TF_VAR_project_id
        export TF_VAR_project_id
    fi

    if [ -z "$TF_VAR_environment" ]; then
        read -p "Enter environment (dev/staging/prod) [dev]: " TF_VAR_environment
        TF_VAR_environment=${TF_VAR_environment:-dev}
        export TF_VAR_environment
    fi

    BUCKET_NAME="${TF_VAR_project_id}-terraform-state-${TF_VAR_environment}"

    print_info "Using Project ID: $TF_VAR_project_id"
    print_info "Using Environment: $TF_VAR_environment"
    print_info "State Bucket: $BUCKET_NAME"
}

# Initialize Terraform with local state first
init_local() {
    print_info "Initializing Terraform with local state..."
    terraform init -upgrade
    print_success "Local initialization complete"
}

# Create the state bucket
create_bucket() {
    print_info "Creating Terraform state bucket..."

    if terraform plan -target=module.bucket -out=tfplan; then
        print_warning "Review the plan above and confirm bucket creation"
        read -p "Do you want to proceed with bucket creation? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            terraform apply tfplan
            print_success "State bucket created successfully"
        else
            print_warning "Bucket creation cancelled"
            exit 1
        fi
    else
        print_error "Failed to plan bucket creation"
        exit 1
    fi
}

# Initialize with remote backend
init_remote() {
    print_info "Initializing remote backend..."

    terraform init -backend-config="bucket=$BUCKET_NAME" \
                   -backend-config="prefix=terraform/state" \
                   -reconfigure

    print_success "Remote backend initialized successfully"
}

# Verify setup
verify_setup() {
    print_info "Verifying setup..."

    # Check if bucket exists
    if gsutil ls -b gs://$BUCKET_NAME &> /dev/null; then
        print_success "Bucket exists: gs://$BUCKET_NAME"
    else
        print_error "Bucket not found: gs://$BUCKET_NAME"
        exit 1
    fi

    # Check backend configuration
    if terraform workspace show &> /dev/null; then
        print_success "Backend configuration is valid"
    else
        print_error "Backend configuration failed"
        exit 1
    fi

    print_success "Setup verification complete!"
}

# Main execution
main() {
    echo -e "${BLUE}🚀 Terraform Remote State Setup${NC}"
    echo "=================================="

    check_dependencies
    get_project_id
    init_local
    create_bucket
    init_remote
    verify_setup

    echo
    print_success "🎉 Remote state setup complete!"
    echo
    print_info "Next steps:"
    echo "  1. Run 'terraform plan' to see your infrastructure changes"
    echo "  2. Run 'terraform apply' to deploy your infrastructure"
    echo "  3. Your state will now be stored remotely in GCS"
    echo
    print_info "Useful commands:"
    echo "  • terraform state list          # List resources in state"
    echo "  • terraform state show RESOURCE # Show resource details"
    echo "  • gsutil ls gs://$BUCKET_NAME/   # View bucket contents"
}

# Run main function
main "$@"
