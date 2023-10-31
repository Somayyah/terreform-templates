#!/bin/bash

# Run terraform apply
terraform apply -auto-approve

# Clear the .env file
> .env

# Get the output and save to .env file
key=$(terraform output -raw storage_account_primary_access_key)
echo "STORAGE_ACCOUNT_PRIMARY_ACCESS_KEY=$key" >> .env

# Add similar lines for other keys you want to save
