#!/bin/bash

# Define symlinks
# Check if version.tf does not exist
if [ ! -e "version.tf" ]; then
    ln -s ../version.tf version.tf
fi

# Check if providers.tf does not exist
if [ ! -e "providers.tf" ]; then
    ln -s ../providers.tf providers.tf
fi

# Check if resource-group.tf does not exist
if [ ! -e "resource-group.tf" ]; then
    ln -s ../resource-group.tf resource-group.tf
fi

# Run terraform init
terraform init

# Run terraform plan
terraform plan

# Run terraform apply
terraform apply -auto-approve

# Clear the .env file
if [ -e ".env" ]; then
    rm .env
fi

# Get the output and save to .env file
# Define an array of output keys
outputKeys=("OPEN_AI_ENDPOINT" "OPEN_AI_KEY" "SPEECH_KEY" "SPEECH_REGION")

# Loop through each key and append to .env
for keyName in "${outputKeys[@]}"; do
    keyValue=$(terraform output -raw "$keyName")
    echo "${keyName}=$keyValue" >> .env
done
