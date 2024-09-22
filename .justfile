# Justfile for common Terraform operations

# Default target
default: help

# Show help message with available targets
help:
    @echo "Available targets:"
    @echo "  validate    Validate the Terraform configuration files"
    @echo "  fmt         Format the Terraform files"
    @echo "  plan        Create an execution plan for Terraform"
    @echo "  apply       Apply the changes required to reach the desired state"
    @echo "  destroy     Destroy the Terraform-managed infrastructure"
    @echo "  output      Show output values from Terraform"
    @echo "  clean       Remove .tfstate files"
    @echo "  cost        Show the cost estimation for resources"

# Validate Terraform configuration
validate:
    @terraform -chdir=example init
    @terraform -chdir=example validate 

# Format Terraform files
fmt:
    @terraform -chdir=example fmt -recursive

# Plan Terraform changes
plan:
    @terraform -chdir=example init
    @terraform -chdir=example plan -var-file=./terraform.tfvars -out=tfplan

# Deploy Terraform-managed infrastructure
apply:
    @terraform -chdir=example apply -var-file=./terraform.tfvars -auto-approve

# Destroy Terraform-managed infrastructure
destroy:
    @terraform -chdir=example destroy -var-file=./terraform.tfvars -auto-approve

# Show Terraform outputs
output:
    @terraform -chdir=example output -json

# Clean up
clean:
    @rm -rf example/*.tfstate*
    @rm -rf example/.terraform
    @rm -rf example/.terraform.lock.hcl
    @rm -rf example/.helm

# Show cost estimation
