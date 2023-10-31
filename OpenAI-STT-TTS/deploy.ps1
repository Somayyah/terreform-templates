# Run terraform apply
terraform apply -auto-approve

# Clear the .env file
if (Test-Path .env) {
    Remove-Item .env
}

# Get the output and save to .env file
$key = terraform output -raw storage_account_primary_access_key
"STORAGE_ACCOUNT_PRIMARY_ACCESS_KEY=$key" | Out-File .env -Append

# Add similar lines for other keys you want to save