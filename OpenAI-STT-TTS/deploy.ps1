# Define symlinks
# Check if version.tf does not exist
if (-not (Test-Path "version.tf")) {
    New-Item -ItemType SymbolicLink -Name "version.tf" -Target "..\version.tf"
}

# Check if providers.tf does not exist
if (-not (Test-Path "providers.tf")) {
    New-Item -ItemType SymbolicLink -Name "providers.tf" -Target "..\providers.tf"
}

# Check if resource_group.tf does not exist (assuming you also want to create this symlink based on your earlier messages)
if (-not (Test-Path "resource-group.tf")) {
    New-Item -ItemType SymbolicLink -Name "resource-group.tf" -Target "..\resource-group.tf"
}

# Run terraform init
terraform init
<# 
# Run terraform apply
terraform apply -auto-approve

# Clear the .env file
if (Test-Path .env) {
    Remove-Item .env
}

# Get the output and save to .env file
$key = terraform output -raw storage_account_primary_access_key
"STORAGE_ACCOUNT_PRIMARY_ACCESS_KEY=$key" | Out-File .env -Append

# Add similar lines for other keys you want to save #>